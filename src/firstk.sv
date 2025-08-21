/**
 * firstk.sv:
 *   This module is to find first k-th positions of 1s in the
 *   input bits, the basic algorithm is divide-and-conquer.
 */

module firstk #(
    parameter width = 64, // data width
    parameter k     = 4   // the parameter k
)(
    input  logic [width-1:0] bits,
    output logic [k:1][$clog2(width):0] pos // MSB is found bit
);
    localparam iw = $clog2(width); // index width
    logic [iw:0][width-1:0][k:1][iw:0] sel;
    always_comb begin
        sel = 0;
        for (int i = 0; i < width; i++) if (bits[i]) sel[0][i][1] = {1'b1, iw'(i)};
        for (int d = 1; d <= iw; d++)
            for (int i = 0; i < width / 2; i++)
                for (int j = 1; j <= k; j++) begin
                    sel[d][i][j] = sel[d-1][2*i+1][j];
                    for (int l = 1; l < k; l++)
                        if (l < j & sel[d-1][2*i][l][iw]) // l-th 1 found in left node
                            sel[d][i][j] = sel[d-1][2*i+1][j-l];
                    if (sel[d-1][2*i][j][iw]) sel[d][i][j] = sel[d-1][2*i][j];
                end
    end
    always_comb pos = sel[iw][0];
endmodule
