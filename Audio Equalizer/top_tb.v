module top_tb;

    // Định nghĩa các tín hiệu
    reg clk;
    reg reset;
    reg [9:0] i_SW;
    wire [15:0] dout;
    wire [15:0] data_wave;
    wire [15:0] data_low_filtered;
    wire [15:0] data_high_filtered;
    wire [15:0] data_band_filtered;

    // Khởi tạo mô-đun 'top'
    top uut (
        .clk(clk),
        .reset(reset),
        .i_SW(i_SW),
        .dout(dout),
        .data_wave(data_wave),
        .data_low_filtered(data_low_filtered),
        .data_high_filtered(data_high_filtered),
        .data_band_filtered(data_band_filtered)
    );

    // Tạo tín hiệu đồng hồ (chu kỳ 10 đơn vị thời gian)
    always begin
        clk = 1'b0;
        #5 clk = 1'b1;
        #5;
    end

    // Khối mô phỏng tín hiệu
    initial begin
        // Khởi tạo các tín hiệu đầu vào
        reset = 1'b1;
        i_SW = 10'd0;

        // Giải phóng reset sau 10 chu kỳ đồng hồ
        #10 reset = 1'b0;

        // Kiểm tra các giá trị của i_SW và điều khiển tần số (i_SW[3:2])
        #20 i_SW[3:2] = 2'b01;  // Chọn tần số 00
        $display("Time = %t | i_SW = %b | Chọn tần số 00", $time, i_SW);

        // Kiểm tra các giá trị của i_SW cho gain
        // Kiểm tra gain_low, gain_high, gain_band
        #200 i_SW[5:4] = 2'b01;  // Chọn gain_low = 1
            i_SW[7:6] = 2'b01;  // Chọn gain_high = 0
            i_SW[9:8] = 2'b01;  // Chọn gain_band = 0
        $display("Time = %t | i_SW = %b | Chọn gain_low = 1, gain_high = 0, gain_band = 0", $time, i_SW);

        #20000 i_SW[5:4] = 2'b00;  // Chọn gain_low = 0
            i_SW[7:6] = 2'b01;  // Chọn gain_high = 1
            i_SW[9:8] = 2'b01;  // Chọn gain_band = 0
        $display("Time = %t | i_SW = %b | Chọn gain_low = 0, gain_high = 1, gain_band = 0", $time, i_SW);

        #20000 i_SW[5:4] = 2'b00;  // Chọn gain_low = 0
            i_SW[7:6] = 2'b00;  // Chọn gain_high = 0
            i_SW[9:8] = 2'b00;  // Chọn gain_band = 1
        $display("Time = %t | i_SW = %b | Chọn gain_low = 0, gain_high = 0, gain_band = 1", $time, i_SW);
#20000
        // Kết thúc mô phỏng
        #50 $stop;
    end

    // Quan sát tín hiệu trong mô phỏng
    initial begin
        $monitor("Time = %t | i_SW = %b | dout = %d | data_wave = %d | low_filtered = %d | high_filtered = %d | band_filtered = %d",
                 $time, i_SW, dout, data_wave, data_low_filtered, data_high_filtered, data_band_filtered);
    end

endmodule
