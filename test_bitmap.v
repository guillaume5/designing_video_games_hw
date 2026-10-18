module test_bitmap(
  input clk,
  input reset,
  output hsync,
  output vsync,
  output [2:0] rgb,
  output [8:0] hpos,
  output [8:0] vpos,
  output display_on
);

//reg sprite_active;
wire [8:0] player_x = 9'd127;
wire [8:0] player_y = 9'd120;

reg [3:0] car_sprite_xofst;
reg [3:0] car_sprite_yofst;
reg [7:0] car_sprite_bits;

reg hsync_old = 0;

hvsync_generator hvsync_gen(
  .clk(clk),
  .reset(reset),
  .hsync(hsync),
  .vsync(vsync),
  .display_on(display_on),
  .hpos(hpos),
  .vpos(vpos)
);

car_bitmap u_car_bitmap(
  .yofst(car_sprite_yofst),
  .bits(car_sprite_bits)
);

always @(posedge clk)
begin
  // vsync rising edge detect
  if(hsync==1 && hsync_old==0 && vpos==player_y)
     car_sprite_yofst <= 15;
  else if(hsync==1 && hsync_old==0 && car_sprite_yofst!=0)
     car_sprite_yofst <= car_sprite_yofst-1;
  hsync_old <= hsync;
end

always @(posedge clk)
begin
  if(hpos==player_x)
     car_sprite_xofst <= 15;
  else if(car_sprite_xofst!=0)
     car_sprite_xofst <= car_sprite_xofst-1;
end


wire [2:0] car_bit = (car_sprite_xofst>=8)?car_sprite_xofst[2:0]^7:car_sprite_xofst[2:0];

wire r = display_on && car_sprite_bits[car_bit];
wire g = display_on && car_sprite_bits[car_bit];
wire b = display_on && car_sprite_bits[car_bit];


assign rgb = {b,g,r};

endmodule;


