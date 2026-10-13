`ifndef HVSYNC_GENERATOR_H
`define  HVSYNC_GENERATOR_H


module hvsync_generator(
  input clk,
  input reset,
  output reg hsync,
  output reg vsync,
  output display_on,
  output reg [8:0] hpos,
  output reg [8:0] vpos
);

localparam H_DISPLAY = 256;
localparam H_FRONT = 7;
localparam H_SYNC = 23;
localparam H_BACK = 23;

localparam V_DISPLAY = 240;
localparam V_BOTTOM = 14;
localparam V_SYNC = 3;
localparam V_TOP = 5;

localparam H_SYNC_START = H_DISPLAY+H_FRONT;
localparam H_SYNC_END = H_DISPLAY+H_FRONT+H_SYNC-1;
localparam H_MAX = H_BACK+H_DISPLAY+H_FRONT+H_SYNC-1;

localparam V_SYNC_START = V_DISPLAY+V_BOTTOM;
localparam V_SYNC_END = V_DISPLAY+V_BOTTOM+V_SYNC-1;
localparam V_MAX = V_SYNC+V_TOP+V_DISPLAY+V_BOTTOM-1;


always @(posedge clk)
begin
  hsync <= (hpos>=H_SYNC_START && hpos<H_SYNC_END);
  if (hmaxed) begin
    hpos <= 0;
  end else
    hpos <= hpos+1; 
end

wire hmaxed = hpos==H_MAX || reset;

always @(posedge clk, reset)
begin
  vsync <= (vpos>=V_SYNC_START && vpos<V_SYNC_END);

  if (hmaxed) begin
    if (vmaxed)
      vpos <= 0;
    else 
      vpos <= vpos+1;
  end
end

wire vmaxed = vpos==V_MAX || reset;


assign display_on = hpos < H_DISPLAY &&
                    vpos < V_DISPLAY;


endmodule;

`endif
