module press_duty_cycle (
    input wire clk,            // Clock (ví dụ: clk_48k)
    input wire reset,          // Reset đồng bộ
    input wire i_KEY,          // Nút nhấn để thay đổi giá trị duty cycle
    output reg [3:0] wave_sel  // Giá trị duty cycle từ 0 đến 15
);

    reg key_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wave_sel <= 4'd0;
            key_prev <= 1'b1;
        end else begin
            key_prev <= i_KEY;

            // Phát hiện cạnh xuống (nhấn phím)
            if (key_prev && ~i_KEY) begin
                if (wave_sel == 4'd15)
                    wave_sel <= 4'd0;
                else
                    wave_sel <= wave_sel + 1'b1;
            end
        end
    end

endmodule
