module triangle_wave_gen (
    input clk,
    input reset,
    input [9:0] phase_acc, // Đổi từ frequency thành phase_step
    output reg [15:0] triangle_wave
);
    
    reg [15:0] triangle_lut [0:1023];
    
    // Load dữ liệu LUT từ file
    initial begin
        $readmemh("D:/k242/Fgpa/fir_iir/fir/triangle_lut.dump", triangle_lut);
    end
    

    
    // Tính địa chỉ LUT
    wire [9:0] lut_addr;
    assign lut_addr = phase_acc;

    // Lấy giá trị sóng tam giác từ LUT
    always @(posedge clk) begin
        triangle_wave <=  triangle_lut[lut_addr];
    end
	 
endmodule
