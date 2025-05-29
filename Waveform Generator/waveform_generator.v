module waveform_generator(
    input wire clk_50m, clk_48k,    // Xung clock hệ thống  	                               // Đặt lại hệ thống//  !i_KEY[0]
    input wire [9:0] i_SW,                           // Công tắc điều khiển
    input wire [3:0] i_KEY,                          // Các phím bấm
    output  [15:0] waveform_out                   // Tín hiệu sóng ra
	
);

	 wire [15:0] sine_wave, square_wave, triangle_wave, ecg_wave, sawtooth_wave;
    wire [9:0]  phase_step;
    wire [9:0] phase_acc;
    wire [15:0] noise_wave;
	 wire [3:0] duty_cycle;
	 wire [15:0] final_wave;
    wire [15:0] filtered_wave;
	  wire [2:0] waveform_select;

    wire noise_enable;
    wire [1:0] freq_wave,amp_wave;
    wire firiir;
	 
	 wire reset			  	= !i_KEY[0];
	 assign amp_wave		  = i_SW[2:1];
    assign noise_enable   = i_SW[3];
	 assign freq_wave      = i_SW[5:4]; 
    assign firiir         = i_SW[8];
   //tang duty_cycle


  //chon song
  choose_wave_sel choose_wave(
		.clk(clk_48k),
      .reset(reset),
		.key(i_KEY[2]),
		.wave_sel(waveform_select)
  );
  
//song
    sine_wave_gen sine_gen (
        .clk(clk_48k),
        .reset(reset),
        .phase_acc(phase_acc),
        .sine_wave(sine_wave)
    );
       square_wave_gen square_gen (
        .phase_acc(phase_acc),
        .duty_cycle(duty_cycle),
        .square_wave(square_wave)
    );
	 
	 press_duty_cycle 	press_duty(
		.clk(clk_48k),
      .reset(reset),
      .i_KEY(i_KEY[1]),
		.wave_sel(duty_cycle)

);
	    triangle_wave_gen triangle_gen (
        .clk(clk_48k),
        .reset(reset),
        .phase_acc(phase_acc),
        .triangle_wave(triangle_wave)
    );
	   ecg_wave_gen ecg_gen (
        .clk(clk_48k),
        .reset(reset),
        .phase_acc(phase_acc),
        .ecg_wave(ecg_wave)
    );
	   sawtooth_wave_gen sawtooth_gen (
        .clk(clk_48k),
        .reset(reset),
        .phase_acc(phase_acc),
        .sawtooth_wave(sawtooth_wave)
    );
	 
	 // tan so va phase
    phase_accumulator phase_gen (
        .clk(clk_48k),
        .reset(reset),
        .phase_step(phase_step),
        .phase_acc(phase_acc)
    );
    
    
    frequency_wave_sel freq1(
        .freq_wave(freq_wave),
        .phase_step(phase_step)
    );
    
    // bo loc
   fir fir_pipelined (
        .clk(clk_48k),
        .reset(reset),
        .data_in(final_wave),
        .data_out(filtered_wave)
    );

 
    // Lựa chọn sóng cuối cùng (sóng đã chọn + nhiễu nếu có)
	 
	  reg [15:0] selected_wave;
    always @(*) begin
        case (waveform_select)
            3'b000: selected_wave = sine_wave;               // Chọn sóng sin
            3'b001: selected_wave = square_wave;             // Chọn sóng vuông
            3'b010: selected_wave = triangle_wave;           // Chọn sóng tam giác
            3'b011: selected_wave = ecg_wave;                // Chọn sóng ECG
            3'b100: selected_wave = sawtooth_wave;           // Chọn sóng răng cưa
            default: selected_wave = 16'b0;                  // Giá trị mặc định là 0
        endcase
    end   
	 
	 noise_injection noise_gen (
        .clk(clk_48k),
        .rst(reset),
        .input_wave(selected_wave),
        .output_wave(noise_wave)
    );

    assign final_wave = noise_enable ? noise_wave : selected_wave;

  wire signed [15:0] scaled_wave;
  wire signed [15:0] wave_data = firiir ? filtered_wave : final_wave;
      assign scaled_wave = (amp_wave == 2'b00) ? wave_data :
                     (amp_wave == 2'b01) ? wave_data <<< 1 : // x2
                     (amp_wave == 2'b10) ? wave_data <<< 2 : // x4
                                           wave_data <<< 3 ; // x8

assign waveform_out = scaled_wave;
       
    

endmodule
