module sine_wave_gen (
    input clk,               // System clock
    input reset,             // Reset signal
    input [9:0] phase_acc,  // External phase accumulator
    output reg [15:0] sine_wave // 24-bit sine wave output
);

    // LUT for sine wave (1024 samples, 24-bit each)
    reg [15:0] sin_lut [0:1023];

    // Load LUT data from a file
    initial begin
        $readmemh("D:/k242/Fgpa/fir_iir/fir/sine_lut.dump", sin_lut);
    end

  wire [9:0] lut_addr;
    assign lut_addr = phase_acc; 
    // Output sine wave value from LUT
    always @(posedge clk) begin
        if (reset)
            sine_wave <= 16'd0;
        else
            sine_wave <= sin_lut[lut_addr];
    end

endmodule
