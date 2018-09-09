`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2018 12:17:33 PM
// Design Name: 
// Module Name: Atan
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

//NOTE: IN CORDIC, input = {Y,X} where Y,X = TWO INT BITS, 14 FRACTIONAL BITS


module Atan(input [15:0] X,
    input [15:0] Y,
    input clk,
    input reset_n,
    output [15:0] phase,
    output reg pulse = 0
    );
    
    //Assignemnts and initialization of wires and registers
    reg [31:0] temp1;
    reg [15:0] X_new; // CHNAGED THESE TO UNSIGNED
    reg [15:0] Y_new;
    reg negX = 0;
    reg negY = 0;
    reg [15:0]temp_variable1;
    reg [15:0]temp_variable2;    
    reg [15:0] normX;
    reg [15:0] normY;
    wire [31:0] divA;
    reg [15:0] dividend;
    reg [15:0] divisor;
    wire [15:0] temp_variable3, temp_variable4;
    reg [4:0] counter = 5'b0;
    reg regulation_variable = 1'b0;
    reg total_negative;
    reg [31:0] prevdivA;
    reg prevtotal_negative;
    
    
                
    // Assignmnets check the sign bit to identify negative numbers
    assign temp_variable3 = X&16'b1000000000000000; // CHNAGED THIS TO MAKE IT UNSIGNED
    assign temp_variable4 = Y&16'b1000000000000000; // KEEPING THIS HERE FOR NOW, WILL GET RID OF IT IF IT IS NOT REQUIRED
    
    // Negative numbers are reformatted and dealt with here, scaling is also done in this block
    always @(posedge clk)
    begin
        if (temp_variable3 == 16'b1000000000000000)
           begin // negativ number X
               negX <= 1'b1;
               X_new <= ~X + 16'b1; //take 2s complement to get positive number
           end
        else begin
             negX <= 1'b0;
             X_new <= X;
        end
        
        if (temp_variable4 == 16'b1000000000000000)
            begin                     
               negY <= 1'b1;
               Y_new <= ~Y + 16'b1; //take 2s complement to get positive number                
            end
        else begin
            negY <= 1'b0;
            Y_new <= Y;
        end
        
        total_negative = negX^negY;
                  
        if (X_new>Y_new) begin
                //divisor <= X_new>>1; // Changed this to move down one bit because the divider generator recognizes sign bits in 2s complement form
                //dividend <= Y_new>>1;// Changed this to move down one bit because the divider generator recognizes sign bits in 2s complement form
                divisor <= X_new;
                dividend <= Y_new;
                
                // assigning norm X
                normX <= 16'b0100000000000000;
                
                
                // assigning norm Y
                normY <= (divA[15:0])>>1;
         end
                
          
         else if (X_new<Y_new)
         begin
                divisor <= Y_new;
                dividend <= X_new;
                
                // assigning norm X
                    normX <= (divA[15:0])>>1;
                // assigning norm Y
                    normY <= 16'b0100000000000000;
         end
         
         else begin
                dividend <= 16'b01111100000000000;
                divisor <=  16'b01111100000000000;
                
                // assigning norm X
                normX <= (divA[16:1])>>1;

                //assigning norm Y
                normY <= (divA[16:1])>>1;
         end
    end
    
    //Note: At this point, the inputs have all been converted to positive values and the flags negX and negY
    //keep track of what was initially negative. Now we will make the required adjustment
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            temp1 <= 0; 
        end
        else if (total_negative) begin
                temp1 <= {~normY + 16'b1,normX};
        end
        else begin
                temp1 <= {normY, normX};
        end
    end

    

// Divider Circuits Used For Scaling
   div_gen_0 YdivX(
        .aclk(clk),
        .s_axis_divisor_tdata(divisor),
        .s_axis_dividend_tdata(dividend),
        .m_axis_dout_tdata(divA)
        );
                            
               
//instatntiate CORDIC IP with our input
     cordic_0 IP(
         .aclk(clk),
         .s_axis_cartesian_tdata(temp1),
         .m_axis_dout_tdata(phase),
         .s_axis_cartesian_tvalid(1'b1)
     );
  
  
 

  
// Pulse wave generation to specify when to sample for accurate results (to avoid fluctutations)
    always @(posedge clk, negedge reset_n) begin
          if (!reset_n) begin
                pulse <= 0;
          end
          else if (divA != prevdivA || prevtotal_negative != total_negative) begin
                counter <= 5'b00000;
                regulation_variable <= 1'b1;
          end 
          else if (counter > 5'b11110) begin
                counter <= 5'b00000;
                if (regulation_variable == 1'b1) begin
                    pulse <= 1'b1;
                    regulation_variable <= 1'b0;
                end
                else begin
                pulse <= 1'b0;
                end    
          end
          else begin
                counter <= counter + 8'b000000001;
                pulse <= 1'b0;
          end
          prevdivA <= divA;
    end      
    
    
//    always @(divA) begin
//        if (!reset_n) begin
//            pulse <= 0;
//            temp1 <= 0;
//        end
//        else begin
//        //count 25 clock edges, generate pulse, reset
//            counter <= 5'b00000;
//            regulation_variable <= 1'b1;
//            end
//        end
          
          
          
//// Pulse wave generation to specify when to sample for accurate results (to avoid fluctutations)
//            always @(posedge clk, negedge reset_n) begin
//                  if (!reset_n) begin
//                        pulse <= 0;
//                        temp1 <= 0;
//                  end
//                  else if (counter > 9'b100000000) begin
//                        counter <= 9'b0000000;
//                        if (regulation_variable == 1'b1) begin
//                            pulse <= 1'b1;
//                            regulation_variable <= 1'b0;
//                        end
//                        else begin
//                        pulse <= 1'b0;
//                        end    
//                  end
//                  else begin
//                        counter <= counter + 9'b00000001;
//                        pulse <= 1'b0;
//                  end
//            end      
            
            
//            always @(X, Y, negedge reset_n) begin
//                if (!reset_n) begin
//                    pulse <= 0;
//                    temp1 <= 0;
//                end
//                else begin
//                //count 25 clock edges, generate pulse, reset
//                    counter <= 9'b0000000;
//                    regulation_variable <= 1'b1;
//                    end
//                end
endmodule

