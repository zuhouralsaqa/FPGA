`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:35:58 08/29/2022 
// Design Name: 
// Module Name:    FPGA_project 
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
module FPGA_project(
input clk,
input go,
output reg [31:0]I1,output reg [31:0]R1,output reg [31:0]Pt
    );

reg [31:0]I;
reg [31:0]R;
reg [31:0]w1;
reg [31:0]w2;
wire[31:0]sin2pit;
reg [31:0]w3; 
wire sign;
reg [31:0]t;
wire [15:0]R1_int=R1[31:16];
wire [15:0]I1_int=I1[31:16];
wire [15:0]Pt1_int=Pt[31:16];
integer i;

always@(posedge clk) 
begin
I1<=I;
R1<=R;             
end

always@(posedge clk, posedge go)
begin


if(go) begin
I[31:16]<=(4'd10);
I[15:0]<=0;
R[31:16]<=(14'd8500);
R[15:0]<=0;
t<=0;  
w1<=0;
w2<=0;
Pt<=0;
w3<=0;
end


else  //sequantial circuit, use non_bloking assignment	 
begin
//I1 = p(t) - ß(I+R)I	 ß=0.1, and is a higly segnificant parameter 
// so we cannt do it thte easy way
 I<=Pt-w1;//pt and I1 have the same size of w1
 w1<=((w2<<15)+(w2<<14)+(w2<<11)+(w2<<10)+(w2<<7)+(w2<<6)+(w2<<3)+(w2<<2)+1)>>19;//size of w2+3 we did if we multbly 0.1 by 2^19 we git 52429 whitch we can get by shifting
 w2[31:0]<=((I[31:0]+R[31:0])*I[31:0])<<16;

//R1 = aI - ?R     a=100 ?=0.05 and are not sensiteve parameters we can assume it to be 128 and 0.625 respectively
R<=(I<<7)-(R>>3);    



//p(t ) = p(1 - p1 sin 2p t )  p1=0.2 is a higly segnificant parameter;
//we will do *2^20 then we will have 209715 and when we represent it we now can go backword and do/2^20
//p=mean value of p(t)=1000 and is not a segnificant parameter we can ssume it to be 1024
if(sign)
 Pt<=((1<<31)+w3)<<10;
else 
 Pt<=((1<<31)-w3)<<10;
 w3<={((sin2pit<<17)+(sin2pit<<16)+(sin2pit<<13)+(sin2pit<<12)+(sin2pit<<9)+(sin2pit<<8)+(sin2pit<<5)+(sin2pit<<4)+(sin2pit<<1))>>20};



t[31:11]<=t[31:11]+1'b1; //resulotion=0.00048828125 
end

end

sinxfunction sin(t,clk,sin2pit,sign);

always@(w3)
begin
i<=0;
for(i=0;i<32;i=i+1)
begin
if(w3[i]===1'bx)
w3[i]<=0;
end
end



endmodule
