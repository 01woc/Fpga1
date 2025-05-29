module button (
  // input
  input wire i_clk,
  input wire i_rst_n,
  input wire i_button,
  // output
  output wire o_stable
);

  // local declaration
  parameter IDLE  = 2'b00;
  parameter PRESS = 2'b01;
  parameter HOLD  = 2'b10;

  reg [1:0] state_q;
  reg [1:0] state_d;

  // next_state combinational logic
  always @(*) begin
    case (state_q)
      IDLE:  state_d = (~i_button) ? PRESS : IDLE;
      PRESS: state_d = (~i_button) ? HOLD  : IDLE;
      HOLD:  state_d = (~i_button) ? HOLD  : IDLE;
      default: state_d = IDLE;
    endcase
  end

  // state flip-flop
  always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n)
      state_q <= IDLE;
    else
      state_q <= state_d;
  end

  // output logic
  assign o_stable = (state_q == PRESS) ? 1'b0 : 1'b1;

endmodule
