module character_gen(
  input wire [1:0] state,
  input clk,
  input clk_18,
  input rst,
  input [9:0] h_cnt,
  input [9:0] v_cnt,
  input wire KEY_RIGHT_MASTER,//for keyboard
  input wire KEY_LEFT_MASTER,//for keyboard
  input wire character_dead,
  output reg character_valid,
  output reg signed [10:0] character_block_x,  // 水平方向的塊位置
  output reg signed [10:0] character_block_y,   // 垂直方向的塊位置
  output reg signed [10:0] character_x,
  output reg signed [10:0] character_y,
  output reg pass4
  
);
 

  always @(*) begin
    if (h_cnt >= character_x && h_cnt < character_x+32 && v_cnt >= character_y && v_cnt < character_y+32) begin
      character_valid=1; character_block_x=character_x;  character_block_y=character_y; end
    else begin
        character_valid=0; character_block_x=0;  character_block_y=0;
    end
  end

  //move the character by keyboard
  parameter [8:0] A_CODES = 9'b0_0001_1100;//1C
	parameter [8:0] D_CODES = 9'b0_0010_0011;//23
    


  always@(posedge clk_18, posedge rst)begin
    if(rst)begin 
      character_y<=224;
    end else begin
      case(state)
        0,2:begin
          character_y<=224;
        end
        1:begin
          if(character_dead)begin
              pass4<=1;
              character_y<=character_y+1;
          end 
        end
      endcase
    end
  end

	always @ (posedge clk, posedge rst) begin
		if (rst) begin
			character_x<=384 ;
		end else begin
      case(state)
      0,2:begin 
        character_x<=384;
      end
      1:begin
        if(KEY_RIGHT_MASTER   && character_x<=608)begin 
            character_x<=character_x+8;
        end else if(KEY_LEFT_MASTER  && character_x!=0)begin 
            character_x<=character_x-8;
        end 
        else begin end
      end
      endcase
	  end
  end



    
endmodule