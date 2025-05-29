module waveLUT (
    input clk,               // System clock
    input reset,             // Reset signal
    input [9:0] phase_acc,  // External phase accumulator
    output reg [15:0] wave // 24-bit sine wave output
);

    // LUT for sine wave (1024 samples, 24-bit each)
    reg [15:0] s_lut [0:1023];

    // Load LUT data from a file
    initial begin
        $readmemh("D:/k242/Fgpa/fir_iir/lab3/wave48hz48k.dump", s_lut);
    end

  wire [9:0] lut_addr;
    assign lut_addr = phase_acc; 
    // Output sine wave value from LUT
    always @(posedge clk) begin
        if (reset)
            wave <= 16'd0;
        else
            wave <= s_lut[lut_addr];
    end

endmodule