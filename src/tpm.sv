/**
 * tpm.sv:
 *   This file includes tag-based performance monitor module
 *   with AXI slave interface
 */

module tpm #(
    parameter twd = 16,    // tag width
    parameter iwd = 64,    // info width
    parameter ewd = 4,     // event width
    parameter tagn  = 32,  // tag number
    parameter filtn = 4,   // filter number
    parameter bufsz = 1024 // buffer size
)(
    input  logic           clk,
    input  logic           rst,
    input  logic [twd-1:0] tag,  // tag for performance monitoring
    input  logic [iwd-1:0] info, // additional sampling info
    input  logic [ewd-1:0] evm,  // event mask
    /* AXI slave interface */
    input  logic [15:0] s_axi_awaddr,
    input  logic        s_axi_awvalid,
    output logic        s_axi_awready,
    input  logic [63:0] s_axi_wdata,
    input  logic        s_axi_wvalid,
    output logic        s_axi_wready,
    output logic  [1:0] s_axi_bresp,
    output logic        s_axi_bvalid,
    input  logic        s_axi_bready,
    input  logic [15:0] s_axi_araddr,
    input  logic        s_axi_arvalid,
    output logic        s_axi_arready,
    output logic [63:0] s_axi_rdata,
    output logic  [1:0] s_axi_rresp,
    output logic        s_axi_rvalid,
    input  logic        s_axi_rready
);
    /*------------ address map -------------*\
    | 0x0000: (rw) control register          |
    | 0x0008: (rw) comparator register       |
    | 0x0010: (rw) tag filter value 0        |
    | 0x0018: (rw) tag filter mask 0         |
    | 0x0020: (rw) tag filter value 1        |
    | 0x0028: (rw) tag filter mask 1         |
    |    ...                                 |
    | 0x1000: (r)  sample counter 0          |
    | 0x1008: (r)  sample counter 1          |
    |    ...                                 |
    | 0x2000: (r)  sample tag                |
    | 0x2008: (r)  sample info               |
    | 0x2010: (r)  remaining tag             |
    |    ...                                 |
    | 0x3000: (r)  remaining counter 0       |
    | 0x3008: (r)  remaining counter 1       |
    |    ...                                 |
    |                                        |
    | control register:                      |
    |     [63:32] (rw) sample selection mask |
    |     [31:16] (rw) remaining selection   |
    |     [1]     (r)  buffer full           |
    |     [0]     (r)  valid (w) retrieve    |
    \*--------------------------------------*/

    /* sample buffer */
    localparam bwd = ewd * 64 + iwd + twd;     // counters, info and tag
    logic           [bwd-1:0] buff[bufsz-1:0]; // buffer for storing samples
    logic [$clog2(bufsz)-1:0] buffr;           // buffer front index
    logic   [$clog2(bufsz):0] bufnm;           // buffer number
    logic                     bufre, bufwe;    // buffer enable signals
    logic [$clog2(bufsz)-1:0] bufra, bufwa;    // buffer addresses
    logic           [bwd-1:0] bufrd, bufwd;    // buffer read data
    always_ff @(posedge clk) if (bufre) buffr <= buffr + 1;
    always_ff @(posedge clk)
        if (32'(bufnm) + (bufwe ? 1 : 0) - (bufre ? 1 : 0) > bufsz) // avoid overflow
            bufnm <= bufsz;
        else bufnm <= bufnm + (bufwe ? 1 : 0) - (bufre ? 1 : 0);
    always_ff @(posedge clk) if (bufre) bufrd <= buff[bufra];
    always_ff @(posedge clk) if (bufwe) buff[bufwa] <= bufwd;

    /* registers and events */
    logic               [31:0] ssel;         // sample selection
    logic               [15:0] rsel;         // remaining selection
    logic               [63:0] cmp;          // comparator
    logic [filtn-1:0][twd-1:0] filtm, filtv; // tag filter registers
    logic [ewd-1:0]            fevents;      // filtered events
    always_comb begin
        fevents = 0;
        for (int i = 0; i < filtn; i++)
            if ((filtm[i] & tag) == (filtm[i] & filtv[i]))
                fevents = evm;
    end

    /* tags and counters */
    logic [tagn-1:0][twd-1:0] ctag;           // tags
    logic        [ewd*64-1:0] ccnt[tagn-1:0]; // event counters
    logic     [ewd-1:0][63:0] crdata, cwdata; // read and write data
    logic     [ewd-1:0][63:0] bwdata;         // buffer write data of counters
    logic     [ewd-1:0][63:0] rmdata;         // remaining data
    logic  [$clog2(tagn)-1:0] caddr, victim;  // read/write address and victim way
    logic [tagn-1:0]          hit;            // hit bitmap
    logic                     rep;            // replacement
    logic           [ewd-1:0] ovf;            // overflow
    logic    [$clog2(tagn):0] hpos;           // hit and free position
    firstk #(.width(tagn), .k(1)) hit_inst(.bits(hit), .pos(hpos));
    always_comb for (int i = 0; i < tagn; i++) hit[i] = ctag[i] == tag;
    always_comb crdata = ccnt[caddr];
    always_comb rmdata = ccnt[32'(rsel)]; // todo: multiplexing to save read ports
    always_comb for (int i = 0; i < ewd; i++) bwdata[i] = crdata[i] + 64'(fevents[i]);
    always_comb for (int i = 0; i < ewd; i++)
        if      (rep)    cwdata[i] = 64'(fevents[i]);
        else if (ovf[i]) cwdata[i] = 0;
        else             cwdata[i] = bwdata[i];
    always_comb rep = ~hpos[$clog2(tagn)] & |fevents;
    always_comb if (hpos[$clog2(tagn)]) begin
        for (int i = 0; i < ewd; i++)
            ovf[i] = ssel[i] & bwdata[i] >= cmp;
    end else ovf = 0;
    always_comb caddr = rep ? victim : $clog2(tagn)'(hpos);
    always_comb bufwe = |ovf | rep;
    always_comb bufwa = buffr + $clog2(bufsz)'(bufnm);
    always_comb bufwd = {bwdata, info, tag};
    always_ff @(posedge clk) if (rst) victim <= 0; else if (rep) victim <= victim + 1;
    always_ff @(posedge clk) if (|fevents) ctag[caddr] <= tag;
    always_ff @(posedge clk) ccnt[caddr] <= cwdata;

    /* AXI transaction */
    logic          [15:0] waddr;
    logic          [63:0] wdata;
    logic                 bvld;
    logic [ewd-1:0][63:0] bcnt;
    logic [iwd-1:0]       binfo;
    logic [twd-1:0]       btag;
    always_comb {bcnt, binfo, btag} = bufrd;
    always_comb bufre = |bufnm & ~bvld;
    always_comb bufra = buffr;
    always_ff @(posedge clk) if (rst) begin
        ssel          <= 0;
        rsel          <= 0;
        cmp           <= ~64'd0;
        filtv         <= 0;
        filtm         <= ~(filtn*twd)'(0);
        bvld          <= 0;
        s_axi_arready <= 1;
        s_axi_awready <= 1;
        s_axi_wready  <= 1;
        s_axi_rvalid  <= 0;
        s_axi_bvalid  <= 0;
    end else begin
        /* buffer read */
        if (bufre) bvld <= 1; // bvld is synchronized with bufrd
        /* handle AXI transaction */
        if (s_axi_arvalid & s_axi_arready) begin // AR handshake
            s_axi_arready <= 0;
            s_axi_rvalid  <= 1;
            case (s_axi_araddr[15:12])
                0: // control registers
                    if (s_axi_araddr[11:0] == 12'h000) begin
                        s_axi_rdata        <= 0;
                        s_axi_rdata[63:32] <= ssel;
                        s_axi_rdata[31:16] <= rsel;
                        s_axi_rdata[1]     <= bufnm > bufsz / 2 ? 1'b1 : 1'b0; // report full when half full
                        s_axi_rdata[0]     <= bvld;
                    end else if (s_axi_araddr[11:0] == 12'h008) s_axi_rdata <= cmp;
                    else if (s_axi_araddr[3:0] == 4'h0) s_axi_rdata <= 64'(filtv[32'(s_axi_araddr[11:4]) - 1]);
                    else if (s_axi_araddr[3:0] == 4'h8) s_axi_rdata <= 64'(filtm[32'(s_axi_araddr[11:4]) - 1]);
                1: // sample counters
                    s_axi_rdata <= bcnt[32'(s_axi_araddr[11:3])];
                2: // sample info and tag
                    if      (s_axi_araddr[11:0] == 12'h000) s_axi_rdata <= 64'(btag);
                    else if (s_axi_araddr[11:0] == 12'h008) s_axi_rdata <= binfo;
                    else if (s_axi_araddr[11:0] == 12'h010) s_axi_rdata <= 64'(ctag[32'(rsel)]);
                3: // remaining counters
                    s_axi_rdata <= rmdata[32'(s_axi_araddr[11:3])];
            endcase
        end
        if (~s_axi_awready & ~s_axi_wready & ~s_axi_bvalid) begin // AW and W handshake done
            s_axi_bvalid <= 1;
            case (waddr[15:12])
                0: // control registers
                    if (waddr[11:0] == 12'h000) begin
                        ssel <= wdata[63:32];
                        rsel <= wdata[31:16];
                        if (~wdata[0]) bvld <= 0; // retrieve and clear valid
                    end else if (waddr[11:0] == 12'h008) cmp <= wdata;
                    else if (waddr[3:0] == 4'h0) filtv[32'(waddr[11:4]) - 1] <= wdata[twd-1:0];
                    else if (waddr[3:0] == 4'h8) filtm[32'(waddr[11:4]) - 1] <= wdata[twd-1:0];
            endcase
        end
        if (s_axi_rvalid  & s_axi_rready)  {s_axi_rvalid, s_axi_arready}               <= 1; // R  handshake
        if (s_axi_bvalid  & s_axi_bready)  {s_axi_bvalid, s_axi_awready, s_axi_wready} <= 3; // B  handshake
        if (s_axi_awvalid & s_axi_awready) {s_axi_awready, waddr} <= {1'b0, s_axi_awaddr};   // AW handshake
        if (s_axi_wvalid  & s_axi_wready)  {s_axi_wready,  wdata} <= {1'b0, s_axi_wdata};    // W  handshake
    end
endmodule
