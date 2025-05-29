`timescale 1ns / 1ps

module top_tb;

    // Inputs
    reg clk_50m;
    reg [9:0] i_SW;
    reg [3:0] i_KEY;
	
    
    // Outputs
    wire AUD_ADCLRCK;
    wire AUD_DACLRCK;
    wire AUD_DACDAT;
    wire AUD_BCLK;
    wire [15:0] debug_audio;
    wire I2C_SCLK;
    wire I2C_SDAT;
    wire [3:0] i2c_status;
    
    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk_50m(clk_50m),
        .i_SW(i_SW),
        .i_KEY(i_KEY),
        .AUD_ADCLRCK(AUD_ADCLRCK),
        .AUD_ADCDAT(1'b0),
        .AUD_DACLRCK(AUD_DACLRCK),
        .AUD_DACDAT(AUD_DACDAT),
        .AUD_BCLK(AUD_BCLK),
        .debug_audio(debug_audio),
        .I2C_SCLK(I2C_SCLK),
        .I2C_SDAT(I2C_SDAT),
        .i2c_status(i2c_status)
    );
    
    // Clock generation
    initial begin
        clk_50m = 0;
        forever #10 clk_50m = ~clk_50m; // 50MHz clock
    end
    
    initial begin
    // Initialize Inputs
    i_SW = 10'b0000000000; // All switches off
        // All keys not pressed (active low)

    // Reset hệ thống
    #100;
    i_KEY[0] = 1'b0; // Nhấn reset (active low)
    #100;
    i_KEY[0] = 1'b1; // Thả reset

    // Đảm bảo hệ thống ổn định
    #1000;
  $display("Testing Sine Wave");
    i_SW[5:4] = 2'b00; // Chọn tần số thấp nhất
    #10_000_000;
	 
	i_KEY[2] = 1'b0; // Nhấn nút chọn dạng sóng
    #200000;
    i_KEY[2] = 1'b1; // Thả nút
  #10_000_000;
  i_SW[2:1]=2'b10;
  #10000000;
  
		i_SW[3] =1'b1;
	 #30_000_000;
	 	i_SW[8] =1'b1;
	 #30_000_000;


    $display("All waveform tests completed");
    $finish;
end


    
    // Monitor output
    initial begin
        $monitor("Time = %t, Waveform = %h", $time, debug_audio);
    end
    
endmodule