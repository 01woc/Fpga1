module fir (
    input clk,
    input reset,
    input signed [15:0] data_in,
    output signed [15:0] data_out
);

    // Hệ số FIR Q1.15 (16-bit signed)
    wire signed [15:0] coeffs [0:15];
assign coeffs[ 0] = 16'sd13;     // ≈ 0.000406
assign coeffs[ 1] = 16'sd90;     // ≈ 0.002757
assign coeffs[ 2] = 16'sd296;    // ≈ 0.009029
assign coeffs[ 3] = 16'sd685;    // ≈ 0.020975
assign coeffs[ 4] = 16'sd1277;   // ≈ 0.038901
assign coeffs[ 5] = 16'sd1999;   // ≈ 0.060790
assign coeffs[ 6] = 16'sd2695;   // ≈ 0.082359
assign coeffs[ 7] = 16'sd3214;   // ≈ 0.098288
assign coeffs[ 8] = 16'sd3401;   // ≈ 0.104167
assign coeffs[ 9] = 16'sd3214;   // ≈ 0.098288
assign coeffs[10] = 16'sd2695;   // ≈ 0.082359
assign coeffs[11] = 16'sd1999;   // ≈ 0.060790
assign coeffs[12] = 16'sd1277;   // ≈ 0.038901
assign coeffs[13] = 16'sd685;    // ≈ 0.020975
assign coeffs[14] = 16'sd296;    // ≈ 0.009029
assign coeffs[15] = 16'sd90;     // ≈ 0.002757


    // Thanh ghi dịch
    reg signed [15:0] shift_reg [0:15];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                shift_reg[i] <= 0;
        end else begin
            shift_reg[0] <= data_in;
            for (i = 1; i < 16; i = i + 1)
                shift_reg[i] <= shift_reg[i-1];
        end
    end

    // Nhân hệ số: 16x16 = 32 bit signed
    reg signed [31:0] products [0:15];
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                products[i] <= 0;
        end else begin
            for (i = 0; i < 16; i = i + 1)
                products[i] <= shift_reg[i] * coeffs[i];
        end
    end

    // Cộng pipeline (adder tree)
    reg signed [32:0] sum1 [0:7];
    reg signed [33:0] sum2 [0:3];
    reg signed [34:0] sum3 [0:1];
    reg signed [35:0] sum4;
    reg signed [15:0] data_out_reg;
    assign data_out = data_out_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) sum1[i] <= 0;
            for (i = 0; i < 4; i = i + 1) sum2[i] <= 0;
            for (i = 0; i < 2; i = i + 1) sum3[i] <= 0;
            sum4 <= 0;
            data_out_reg <= 0;
        end else begin
            for (i = 0; i < 8; i = i + 1)
                sum1[i] <= products[2*i] + products[2*i+1];

            for (i = 0; i < 4; i = i + 1)
                sum2[i] <= sum1[2*i] + sum1[2*i+1];

            sum3[0] <= sum2[0] + sum2[1];
            sum3[1] <= sum2[2] + sum2[3];

            sum4 <= sum3[0] + sum3[1];

            // Q1.15 * Q1.15 = Q2.30 → shift 14 để lấy về Q1.15
            data_out_reg <= sum4[30:15]; // Giữ lại 16 bit Q1.15
        end
    end

endmodule
