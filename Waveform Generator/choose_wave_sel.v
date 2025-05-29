module choose_wave_sel (
    input wire clk,             // Clock (vd: clk_48k)
    input wire reset,           // Reset đồng bộ (từ !i_KEY[0])
    input wire key,             // Nút nhấn để chuyển sóng (i_KEY[1])
    output reg [2:0] wave_sel  // Mã chọn sóng
);

    reg key_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wave_sel <= 3'b000;
            key_prev <= 1'b1;
        end else begin
            key_prev <= key;

            // Phát hiện cạnh xuống của phím (nhấn)
            if (key_prev && ~key) begin
                if (wave_sel == 3'b100)
                    wave_sel <= 3'b000;
                else
                    wave_sel<= wave_sel + 1'b1;
            end
        end
    end

endmodule
