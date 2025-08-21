/**
 * tpm.sv:
 *   This file includes tag-based performance monitor module
 *   with AXI slave interface
 */

module tpm #(
    parameter evnum = 64,  // event number
    parameter tagn  = 8,   // tag number
    parameter bufsz = 1024 // buffer size
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic          [127:0] tag,    // tag for performance monitoring
    input  logic [evnum-1:0][3:0] events, // numbers of each event
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
    /*----------------------- address map -----------------------*\
    | 0:           (r) sample counter 0 (w) tag 0                 |
    | 8:           (r) sample counter 1 (w) tag 1                 |
    |    ...                                                      |
    | 8*(evnum-1): (r) sample counter evnum - 1 (w) tag evnum - 1 |
    | 8*(evnum  ): (r) sample tag lower 64-bit                    |
    | 8*(evnum+1): (r) sample tag higher 64-bit                   |
    | 8*(evnum+2): (rw) control register                          |
    | 8*(evnum+3): (rw) comparator register                       |
    | 8*(evnum+4): (rw) tag filter floor lower 64-bit             |
    | 8*(evnum+5): (rw) tag filter floor higher 64-bit            |
    | 8*(evnum+6): (rw) tag filter ceiling lower 64-bit           |
    | 8*(evnum+7): (rw) tag filter ceiling higher 64-bit          |
    | 8*(evnum+8): (rw) tag mask lower 64-bit                     |
    | 8*(evnum+9): (rw) tag mask higher 64-bit                    |
    |                                                             |
    | control register:                                           |
    |     [31:8] (rw) sample selection                            |
    |     [1]    (r) buffer full                                  |
    |     [0]    (r) valid (w) retrieve                           |
    \*-----------------------------------------------------------*/

    /* sample buffer */
    logic    [evnum*64+127:0] buff[bufsz-1:0]; // buffer for storing samples
    logic [$clog2(bufsz)-1:0] buffr;           // buffer front index
    logic   [$clog2(bufsz):0] bufnm;           // buffer number
    logic                     bufre, bufwe;    // buffer enable signals
    logic [$clog2(bufsz)-1:0] bufra, bufwa;    // buffer addresses
    logic    [evnum*64+127:0] bufrd, bufwd;    // buffer read data
    always_ff @(posedge clk) if (bufre) buffr <= buffr + 1;
    always_ff @(posedge clk)
        if (32'(bufnm) + (bufwe ? 1 : 0) - (bufre ? 1 : 0) > bufsz) // avoid overflow
            bufnm <= bufsz;
        else bufnm <= bufnm + (bufwe ? 1 : 0) - (bufre ? 1 : 0);
    always_ff @(posedge clk) if (bufre) bufrd <= buff[bufra];
    always_ff @(posedge clk) if (bufwe) buff[bufwa] <= bufwd;

    /* register control */
    logic  [23:0] sel;         // sample selection register
    logic  [63:0] comp;        // comparator register
    logic [127:0] floor, ceil; // tag filter registers
    logic [127:0] mask;        // tag mask register
    logic  [15:0] waddr;       // AXI write address
    logic  [63:0] wdata;       // AXI write data
    /* counters */
    logic     [evnum*64-1:0] ccnt[tagn-1:0];   // counter
    logic     [evnum*64-1:0] scnt[tagn-1:0];   // sampled counter
    logic  [tagn-1:0]        cvld, svld;       // valid bits
    logic  [tagn-1:0][127:0] ctag, stag;       // tags
    logic  [evnum-1:0][63:0] crdata, cwdata;   // counter read and write values
    logic [$clog2(tagn)-1:0] caddr, victim;    // counter read/write address and victim way
    logic         [tagn-1:0] hit;              // tag hit bitmap
    logic                    rep, ovf;         // replacement and overflow
    logic   [$clog2(tagn):0] hpos, fpos, spos; // hit, free and sample valid position
    logic   [evnum-1:0][3:0] fevents;          // filtered events
    firstk #(.width(tagn), .k(1)) hit_inst(.bits(hit), .pos(hpos));
    firstk #(.width(tagn), .k(1)) free_inst(.bits(~cvld), .pos(fpos));
    firstk #(.width(tagn), .k(1)) svpos_inst(.bits(svld), .pos(spos));
    always_comb
        if (tag[127:96] < floor[127:96] | tag[127:96] > ceil[127:96] | // filter by 32-bit
            tag[ 95:64] < floor[ 95:64] | tag[ 95:64] > ceil[ 95:64] |
            tag[ 63:32] < floor[ 63:32] | tag[ 63:32] > ceil[ 63:32] |
            tag[ 31: 0] < floor[ 31: 0] | tag[ 31: 0] > ceil[ 31: 0]
        ) fevents = 0;
        else fevents = events;
    always_comb for (int i = 0; i < tagn; i++) hit[i] = cvld[i] & (ctag[i] & mask) == (tag & mask);
    always_comb crdata = ccnt[caddr] ;
    always_comb rep = ~hpos[$clog2(tagn)] & |fevents;
    always_comb ovf = hpos[$clog2(tagn)] & cwdata[$clog2(evnum)'(sel)] >= comp;
    always_comb if (rep) caddr = fpos[$clog2(tagn)] ? $clog2(tagn)'(fpos) : victim;
        else             caddr = $clog2(tagn)'(hpos);
    always_comb for (int i = 0; i < evnum; i++) cwdata[i] = (rep ? 0 : crdata[i]) + 64'(fevents[i]);
    always_comb bufwe = spos[$clog2(tagn)];
    always_comb bufwa = buffr + $clog2(bufsz)'(bufnm);
    always_comb bufwd = {scnt[$clog2(tagn)'(spos)], stag[$clog2(tagn)'(spos)]};
    always_ff @(posedge clk) if (rst) victim <= 0; else victim <= victim + 1;
    always_ff @(posedge clk) ccnt[caddr] <= cwdata;
    always_ff @(posedge clk) if (rst) svld <= 0; else begin
        if (bufwe)      svld[$clog2(tagn)'(spos)] <= 0;
        if (rep | ovf) {svld[caddr], stag[caddr]} <= {cvld[caddr], ctag[caddr]};
    end
    always_ff @(posedge clk) if (rep | ovf) scnt[caddr] <= rep ? crdata : cwdata;
    always_ff @(posedge clk) if (rst) cvld <= 0;
        else if (rep) cvld[caddr] <= 1;
        else if (ovf) cvld[caddr] <= 0;
    always_ff @(posedge clk) if (|fevents) ctag[caddr] <= tag;

    /* AXI transaction */
    logic [evnum-1:0][63:0] bcnt;
    logic                   bvld;
    logic           [127:0] btag;
    always_comb {bcnt, btag} = bufrd;
    always_comb bufre = |bufnm & ~bvld;
    always_comb bufra = buffr;
    always_ff @(posedge clk) if (rst) begin
        sel           <= 0;
        comp          <= -64'd1;
        floor         <= 0;
        ceil          <= -128'd1;
        mask          <= 0;
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
            if      (s_axi_araddr[15:3] <  evnum)     s_axi_rdata <= bcnt[32'(s_axi_araddr) >> 3];
            else if (s_axi_araddr[15:3] == evnum)     s_axi_rdata <= btag[63:0];
            else if (s_axi_araddr[15:3] == evnum + 1) s_axi_rdata <= btag[127:64];
            else if (s_axi_araddr[15:3] == evnum + 2) begin
                s_axi_rdata       <= 0;
                s_axi_rdata[31:8] <= sel;
                s_axi_rdata[1]    <= bufnm > bufsz / 2 ? 1'b1 : 1'b0; // report full when half full
                s_axi_rdata[0]    <= bvld;
            end else if (s_axi_araddr[15:3] == evnum + 3) s_axi_rdata <= comp;
            else if (s_axi_araddr[15:3] == evnum + 4) s_axi_rdata <= floor[63:0];
            else if (s_axi_araddr[15:3] == evnum + 5) s_axi_rdata <= floor[127:64];
            else if (s_axi_araddr[15:3] == evnum + 6) s_axi_rdata <= ceil[63:0];
            else if (s_axi_araddr[15:3] == evnum + 7) s_axi_rdata <= ceil[127:64];
            else if (s_axi_araddr[15:3] == evnum + 8) s_axi_rdata <= mask[63:0];
            else if (s_axi_araddr[15:3] == evnum + 9) s_axi_rdata <= mask[127:64];
        end
        if (~s_axi_awready & ~s_axi_wready & ~s_axi_bvalid) begin // AW and W handshake done
            s_axi_bvalid <= 1;
            if (waddr[15:3] == evnum + 2) begin
                sel <= wdata[31:8];
                if (~wdata[0]) bvld <= 0; // retrieve and clear valid bit
            end else if (waddr[15:3] == evnum + 3) comp <= wdata;
            else if (waddr[15:3] == evnum + 4) floor[63:0] <= wdata;
            else if (waddr[15:3] == evnum + 5) floor[127:64] <= wdata;
            else if (waddr[15:3] == evnum + 6) ceil[63:0] <= wdata;
            else if (waddr[15:3] == evnum + 7) ceil[127:64] <= wdata;
            else if (waddr[15:3] == evnum + 8) mask[63:0] <= wdata;
            else if (waddr[15:3] == evnum + 9) mask[127:64] <= wdata;
        end
        if (s_axi_rvalid  & s_axi_rready)  {s_axi_rvalid, s_axi_arready}               <= 1; // R  handshake
        if (s_axi_bvalid  & s_axi_bready)  {s_axi_bvalid, s_axi_awready, s_axi_wready} <= 3; // B  handshake
        if (s_axi_awvalid & s_axi_awready) {s_axi_awready, waddr} <= {1'b0, s_axi_awaddr};   // AW handshake
        if (s_axi_wvalid  & s_axi_wready)  {s_axi_wready,  wdata} <= {1'b0, s_axi_wdata};    // W  handshake
    end
endmodule
