module top (
    input  clk_50m,         // Clock 50MHz từ FPGA          // Nút reset
    input  [9:0] i_SW,      // DIP switch điều khiển
    input  [3:0] i_KEY,     // Nút bấm điều khiển

    // Audio Codec Interface
    output AUD_ADCLRCK,     // LRCK (48kHz)
    input  AUD_ADCDAT,      // ADC Data (không dùng)
    output AUD_DACLRCK,     // LRCK (48kHz)
    output AUD_DACDAT,      // DAC Data (ra oscilloscope)
    output AUD_BCLK,        // Bit Clock (12.5MHz)
	 
output  [15:0] debug_audio,
    // I2C Config
    output I2C_SCLK,        // I2C Clock
    inout  I2C_SDAT,        // I2C Data
    output [3:0] i2c_status // Trạng thái I2C (debug)
);
wire reset = !i_KEY[0];
    //------------------------------------
    // Tín hiệu nội bộ
    //------------------------------------
    wire clk_48k;           // Clock 48kHz (LRCK)
    wire clk_12m;           // Clock 12.5MHz (BCLK)
    wire [15:0] audio_out;  // Tín hiệu audio từ waveform_generator

    //------------------------------------
    // Clock Divider: 50MHz → 12.5MHz và 48kHz
    //------------------------------------
     clk_12M clk_12m_inst (
        .clk_in(clk_50m),
        .reset_n(reset),
        .clk_out(clk_12m)  // Tín hiệu BCLK
    );

    clock_48K clk_48k_inst (
        .clk_in(clk_50m),
        .reset_n(reset),
        .clk_out(clk_48k)  // Tín hiệu LRCK
    );


    //------------------------------------
    // Waveform Generator (Tạo sóng sine/noise)
    //------------------------------------
    waveform_generator waveform_gen (
        .clk_50m(clk_50m),
        .clk_48k(clk_48k),
        .i_SW(i_SW),        
        .i_KEY(i_KEY),    
        .waveform_out(audio_out)
    );

    //------------------------------------
    // Audio Codec (I2S Interface)
    //------------------------------------
    audio_codec codec (
        .clk(clk_12m),
        .reset(reset),
        .sample_end(),         
        .sample_req(),         
        .audio_output(audio_out),
        .audio_input(),         
        .channel_sel(2'b11),   

        .AUD_ADCLRCK(AUD_ADCLRCK),
        .AUD_ADCDAT(AUD_ADCDAT),
        .AUD_DACLRCK(AUD_DACLRCK),
        .AUD_DACDAT(AUD_DACDAT),
        .AUD_BCLK(AUD_BCLK)
    );

    //------------------------------------
    // I2C Config (Khởi tạo codec)
    //------------------------------------
    i2c_av_config i2c_config (
        .clk(clk_50m),
        .reset(reset),
        .i2c_sclk(I2C_SCLK),
        .i2c_sdat(I2C_SDAT),
        .status(i2c_status)
    );
 assign debug_audio = audio_out;

endmodule
