`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2018 02:40:27 PM
// Design Name: 
// Module Name: test_atan
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_atan(

    );
    
wire [15:0] phase;
reg [15:0]X,Y;
reg reset_n;
reg clk;
wire pulse;

Atan test(
    .X          (X),
    .Y          (Y),
    .clk        (clk),
    .phase      (phase),
    .reset_n    (reset_n),
    .pulse (pulse)
);

initial begin
    clk = 0;
    reset_n = 0;
    #15 reset_n = 1;  
    
    Y = 16'd30000; X = -16'd15000; #1000;
    Y = 16'd30000; X = 16'd30000; #1000;
    Y = 16'd15000; X = -16'd30000; #1000;
    Y = 16'd10000; X = 16'd30000; #1000;
    Y = 16'd30000; X = 16'd5000; #1000;
    Y = 16'd2500; X = 16'd10000; #1000;
    Y = 16'd5000; X = -16'd10000; #1000;
    Y = 16'd64000; X = -16'd8000;
    
    
    

        
end




   //          0100000000000000
       div_gen_0 check(
         .aclk(clk),
         .s_axis_divisor_tdata(Y),
         .s_axis_dividend_tdata(X),
         .m_axis_dout_tdata(tte)
         );



always begin
    #5 clk = !clk;  //100 MHz
    
end


endmodule
