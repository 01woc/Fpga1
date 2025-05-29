module gain_selector (
    input  wire [1:0] gain_sel,          // Giá trị từ 0 đến 3
    output reg  signed [15:0] gain_out   // Hệ số gain 16-bit signed
);

    always @(*) begin
        case (gain_sel)
            2'd0: gain_out = 16'sd0;
            2'd1: gain_out = 16'sd1;
            2'd2: gain_out = 16'sd2;
            2'd3: gain_out = 16'sd3;
            default: gain_out = 16'sd0;
        endcase
    end

endmodule
