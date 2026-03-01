module character2_gen(
  input wire [1:0] state,
  input clk,
  input clk_18,
  input rst,
  input [9:0] h_cnt,
  input [9:0] v_cnt,
  input wire KEY_RIGHT,
  input wire KEY_LEFT,
  input wire character2_dead,
  output reg character2_valid,
  output reg signed [10:0] character2_block_x,  // 水平方向的塊位置
  output reg signed [10:0] character2_block_y,   // 垂直方向的塊位置
  output reg signed [10:0] character2_x,
  output reg signed [10:0] character2_y,
  output reg pass,
  output reg pass2
);
 
 
  always @(*) begin
    if (h_cnt >= character2_x && h_cnt < character2_x+32 && v_cnt >= character2_y && v_cnt < character2_y+32) begin
      character2_valid=1; character2_block_x=character2_x;  character2_block_y=character2_y; end
    else begin
        character2_valid=0; character2_block_x=0;  character2_block_y=0;
    end
  end
  wire KEY_DOWN_op,KEY_LEFT_op,KEY_RIGHT_op,KEY_UP_op;
//   one_pulse x1(.clk(clk),.pb_in(KEY_DOWN),.pb_out(KEY_DOWN_op));
//   one_pulse x2(.clk(clk),.pb_in(KEY_UP),.pb_out(KEY_UP_op));
//   one_pulse x3(.clk(clk),.pb_in(KEY_LEFT),.pb_out(KEY_LEFT_op));
//   one_pulse x4(.clk(clk),.pb_in(KEY_RIGHT),.pb_out(KEY_RIGHT_op));
  //move the character by keyboard
  always@(posedge clk_18)begin
    if(rst)begin
       character2_y<=224;
    end else begin
      case(state)
      0,2:begin 
          character2_y<=224;
      end
      1:begin
        if(character2_dead)begin
            character2_y<=character2_y+1;
        end
      end
      endcase
    end
  end
   
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            character2_x<=384;
        end else begin
           case(state)
           0,2:begin
             character2_x<=224-32;
          end
           1:begin
              if(KEY_RIGHT   && character2_x<=608)begin 
                pass<=1;pass2<=0;
                  character2_x<=character2_x+8;
              end else if(KEY_LEFT  && character2_x!=0)begin 
                pass<=0;pass2<=1;
                  character2_x<=character2_x-8;
              end 
              else begin pass<=0;pass2<=1;end
           end
           endcase
        end 
    end
    
endmodule