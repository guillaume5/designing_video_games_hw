module test_hvsync_generator_top(
  input clk,
  input reset,
  output hsync,
  output vsync,
  output [2:0] rgb,
  output [8:0] hpos,
  output [8:0] vpos,
  output display_on
);

//wire display_on;
//wire [8:0] hpos;
//wire [8:0] vpos;

/* verilator lint_off PINMISSING */
hvsync_generator hvsync_gen(
  .clk(clk),
  .reset(reset),
  .hsync(hsync),
  .vsync(vsync),
  .display_on(display_on),
  .hpos(hpos),
  .vpos(vpos)
);
/* verilator lint_on PINMISSING */

wire r = display_on && ((hpos&7)==0 || (vpos&7)==0);
wire g = display_on & vpos[4];
wire b = display_on & hpos[4];


assign rgb = {b,g,r};

endmodule;


