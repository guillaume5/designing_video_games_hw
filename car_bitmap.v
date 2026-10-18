module car_bitmap(
  input [3:0] yofst,
  output [7:0] bits
);


reg [7:0] bitarray[0:15];

assign bits = bitarray[yofst];

initial begin
  /* {w:8,h:16}  */
  bitarray[0] = 8'b0;
  bitarray[1] = 8'b1100;
  bitarray[2] = 8'b11001100;
  bitarray[3] = 8'b11111100;
  bitarray[4] = 8'b11101100;
  bitarray[5] = 8'b11100000;
  bitarray[6] = 8'b1100000;
  bitarray[7] = 8'b1110000;
  bitarray[8] = 8'b110000;
  bitarray[9] = 8'b110000;
  bitarray[10] = 8'b110000;
  bitarray[11] = 8'b1101110;
  bitarray[12] = 8'b11101110;
  bitarray[13] = 8'b11111110;
  bitarray[14] = 8'b11101110;
  bitarray[15] = 8'b101110;

 
  /*bitarray[0] = 8'd15;
  bitarray[1] = 8'd15;
  bitarray[2] = 8'd15;
  bitarray[3] = 8'd15;
  bitarray[4] = 8'd15;
  bitarray[5] = 8'd15;
  bitarray[6] = 8'd15;
  bitarray[7] = 8'd15;
  bitarray[8] = 8'd15;
  bitarray[9] = 8'd15;
  bitarray[10] = 8'd15;
  bitarray[11] = 8'd15;
  bitarray[12] = 8'd15;
  bitarray[13] = 8'd15;
  bitarray[14] = 8'd15;
  bitarray[15] = 8'd15;*/
end 


endmodule // car_bitmap
