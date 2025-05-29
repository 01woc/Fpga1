module clk_12M (
    input  wire reset_n,
    input  wire clk_in,      // 50MHz
    output reg clk_out       // 12.5MHz
);
    reg [1:0] counter;

    always @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 2'd0;
            clk_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'd1)
                clk_out <= ~clk_out; // Đảo tín hiệu sau mỗi 2 chu kỳ đồng hồ → chia tần số cho 4
        end
    end
endmodule
