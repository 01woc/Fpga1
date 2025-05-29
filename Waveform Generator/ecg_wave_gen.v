module ecg_wave_gen (
    input clk,
    input reset,
    input [9:0] phase_acc,   // Đổi từ frequency thành phase_step
    output reg [15:0] ecg_wave // Sóng ECG đầu ra 24 bit
);

  
    reg [15:0] ecg_lut [0:1023]; // LUT chứa 1024 giá trị 24 bit

    // Khởi tạo LUT từ file
    initial begin
        $readmemh("D:/k242/Fgpa/fir_iir/fir/ecg_lut.dump", ecg_lut); // Nạp dữ liệu LUT từ file hex
    end

 

    // Tính địa chỉ LUT
    wire [9:0] lut_addr;
    assign lut_addr = phase_acc; // Sử dụng 10 bit cao nhất của pha

    // Đọc giá trị sóng từ LUT
    always @(posedge clk) begin
        ecg_wave <=  ecg_lut[lut_addr];
		  
    end

endmodule
