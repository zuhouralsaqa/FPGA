`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:16:20 08/29/2022 
// Design Name: 
// Module Name:    sinxfunction 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sinxfunction(
    input [31:0]x,//num of integer digits is 16, number of fraction digits is 16
    input clk,
    output reg [31:0]y, output reg sign
    );
reg [31:0]w2;	 
reg [31:0]w3;
reg [31:0]w4;
integer i;
always@(posedge clk)
begin 

//w1=x*1/2pi; 1/2pi=0.15919 which we assume it to be 0.15917 and multibling it by 2^10 will give us 163 
w2=(((x<<7)<<5)<<1)>>10; //163-128=35;  35-32=2; now w1=x*163; we have to put that valua at the int part of w1
//now we need just the fraction part 

if (w2[15:0]<16'd32768) //if num of fraction digites is equal to 16; w2 fraction part<0.5?
begin //y<= (w2<<3)-(w2*(w2<<4)); y=-16t^2+8t;
w4=(w2<<4);
w3[31:0]=(w4[31:0]*w2[31:0])<<11;
y= (w2<<3)-(w3); // must have the double size of w2, and the fraction part will be 21 digits 
end
else begin
//y<= (w2*(w2<<4))-(w2<<4)-(w2<<3)+8; y=16t^2-16t-8t+8; but we want a negative declaration so
w4=(w2<<4);
w3[31:0]=(w4[31:0]*w2[31:0])<<11;
y= ((w2<<4)+(w2<<3)-(w3));
y[31:16]=y[31:16]+4'd8;
sign=1; end
end




endmodule
