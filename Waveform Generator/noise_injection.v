module noise_injection (
    input wire clk,                      // Clock hệ thống
    input wire rst,                      // Reset
    input wire [15:0] input_wave,        // Tín hiệu gốc
    output reg [15:0] output_wave        // Tín hiệu sau khi thêm nhiễu
);

    // Định nghĩa thanh ghi LFSR (sử dụng 16-bit)
    reg [15:0] lfsr_reg; 
    
    // Cài đặt feedback polynomial (x^16 + x^14 + x^13 + x^11 + 1)
    wire feedback;
    assign feedback = lfsr_reg[15] ^ lfsr_reg[13] ^ lfsr_reg[12] ^ lfsr_reg[10];

    // Quá trình tạo ngẫu nhiên từ LFSR
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Khởi tạo LFSR với một giá trị ngẫu nhiên
            lfsr_reg <= 16'hACE1;
            output_wave <= 16'b0;
        end else begin
            // Lưu giá trị mới vào LFSR
            lfsr_reg <= {lfsr_reg[14:0], feedback};
            
            // Thêm nhiễu vào tín hiệu đầu vào bằng cách XOR với giá trị LFSR
            output_wave <= input_wave ^ lfsr_reg>>2;
        end
    end

endmodule
