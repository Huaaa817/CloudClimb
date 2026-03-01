module background_gen(
  input wire [1:0] state,
  input clk,
  input clk_ori,
  input rst,
  input [9:0] h_cnt,
  input [9:0] v_cnt,
  input start_game,
  input signed [10:0] character_x,
  input signed [10:0] character_y,
  input signed [10:0] character2_x,
  input signed [10:0] character2_y,
  output reg cloud_valid,
  output reg bomb_valid,
  output reg signed [10:0] cloud_block_x,  // 水平方向的塊位置
  output reg signed [10:0] cloud_block_y,   // 垂直方向的塊位置
  output reg character_dead,
  output reg character2_dead,
  output reg time_valid,
  output reg [4:0] time_tens,
  output reg [4:0] time_ones,
  output reg [5:0] counter,
  output wire santa_valid,
  output reg pass3
);

  assign santa_valid=(character2_dead || character_dead)?1:0;
  //clock_divider #(.n(26)) clk26(.clk(clk), .clk_div(clk_26));

  // 定義多個雲的位置與大小
  parameter CLOUD_COUNT = 10;
  reg signed [10:0] cloud_x [0:CLOUD_COUNT-1];
  reg signed [10:0] cloud_y [0:CLOUD_COUNT-1];

  parameter MOVE_SPEED = 1;
  integer i;
  //捲動雲
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // 重置雲的位置
      cloud_x[0] <= 128; cloud_y[0] <= 64; 
      cloud_x[1] <= 544; cloud_y[1] <= 128; 
      cloud_x[2] <= 224; cloud_y[2] <= 160; 
      cloud_x[3] <= 352; cloud_y[3] <= 224; 
      cloud_x[4] <= 544; cloud_y[4] <= 256; 
      cloud_x[5] <= 0; cloud_y[5] <= 288; 
      cloud_x[6] <= 224; cloud_y[6] <= 320; 
      cloud_x[7] <= 256; cloud_y[7] <= 0; 
      cloud_x[8] <= 416; cloud_y[8] <= 128;
      cloud_x[9] <= 32; cloud_y[9] <= 192;
    end else begin
      case(state)
      0,2:begin 
      cloud_x[0] <= 128; cloud_y[0] <= 64; 
      cloud_x[1] <= 544; cloud_y[1] <= 128; 
      cloud_x[2] <= 224; cloud_y[2] <= 160; 
      cloud_x[3] <= 352; cloud_y[3] <= 224; 
      cloud_x[4] <= 544; cloud_y[4] <= 256; 
      cloud_x[5] <= 0; cloud_y[5] <= 288; 
      cloud_x[6] <= 224; cloud_y[6] <= 320; 
      cloud_x[7] <= 256; cloud_y[7] <= 0; 
      cloud_x[8] <= 416; cloud_y[8] <= 128;
      cloud_x[9] <= 32; cloud_y[9] <= 192;
      end

      1:begin
        for (i = 0; i < CLOUD_COUNT; i = i + 1) begin
          if (cloud_y[i]-480 >= 0) begin
            // 如果雲完全移出屏幕，將其重置到屏幕頂部
            cloud_y[i] <= -32;  // 假設屏幕高度為 480
          end else begin
            // 雲向上移動
            cloud_y[i] <= cloud_y[i] + 1;
          end
        end
      end
      endcase
    end
  end

  /***character1***/
  integer j;
  always @(posedge clk_ori or posedge rst) begin
    if(rst)begin
      character_dead<=0;
    end else begin
      case(state)
      0,2:begin
        character_dead<=0;
       end
      1:begin
        character_dead<=0;
        for(j=0;j<CLOUD_COUNT;j=j+1)begin
          if(character_x>cloud_x[j]-30 && character_x<cloud_x[j]+30 && character_y>cloud_y[j]-30 && character_y<cloud_y[j]+30)begin
            pass3<=1; character_dead<=1;
        end
        end
      end
      endcase
    end
  end
 /***character 2***/
 integer l;
  always @(posedge clk_ori or posedge rst) begin
    if(rst)begin
       character2_dead<=0;
    end else begin
      case(state)
      0,2:begin
        character2_dead<=0;
       end
      1:begin
        character2_dead<=0;
        for(l=0;l<CLOUD_COUNT;l=l+1)begin
          if(character2_x>cloud_x[l]-30 && character2_x<cloud_x[l]+30 && character2_y>cloud_y[l]-30 && character2_y<cloud_y[l]+30)begin
          character2_dead<=1;
        end
        end
      end
      endcase
    end
  end
   
  always @(*) begin
    cloud_valid=0;
    bomb_valid=0;
    if (h_cnt >= cloud_x[0] && h_cnt < cloud_x[0]+32 && v_cnt >= cloud_y[0]  && v_cnt < cloud_y[0]+32) begin
      cloud_valid=1; cloud_block_x=cloud_x[0];  cloud_block_y=cloud_y[0]; end
    else if(h_cnt >= cloud_x[1] && h_cnt < cloud_x[1]+32 && v_cnt >= cloud_y[1]  && v_cnt < cloud_y[1]+32)begin
      bomb_valid=1; cloud_block_x=cloud_x[1]; cloud_block_y=cloud_y[1]; end
    else if(h_cnt >= cloud_x[2] && h_cnt < cloud_x[2]+32 && v_cnt >= cloud_y[2]  && v_cnt < cloud_y[2]+32)begin
      cloud_valid=1; cloud_block_x=cloud_x[2]; cloud_block_y=cloud_y[2]; end 
    else if(h_cnt >= cloud_x[3] && h_cnt < cloud_x[3]+32 && v_cnt >= cloud_y[3]  && v_cnt < cloud_y[3]+32)begin
      cloud_valid=1; cloud_block_x=cloud_x[3]; cloud_block_y=cloud_y[3]; end 
    else if(h_cnt >= cloud_x[4] && h_cnt < cloud_x[4]+32 && v_cnt >= cloud_y[4]  && v_cnt < cloud_y[4]+32)begin
      bomb_valid=1; cloud_block_x=cloud_x[4]; cloud_block_y=cloud_y[4]; end 
    else if(h_cnt >= cloud_x[5] && h_cnt < cloud_x[5]+32 && v_cnt >= cloud_y[5]  && v_cnt < cloud_y[5]+32)begin
      cloud_valid=1; cloud_block_x=cloud_x[5]; cloud_block_y=cloud_y[5]; end 
    else if(h_cnt >= cloud_x[6] && h_cnt < cloud_x[6]+32 && v_cnt >= cloud_y[6]  && v_cnt < cloud_y[6]+32)begin
      cloud_valid=1; cloud_block_x=cloud_x[6]; cloud_block_y=cloud_y[6]; end 
    else if(h_cnt >= cloud_x[7] && h_cnt < cloud_x[7]+32 && v_cnt >= cloud_y[7]  && v_cnt < cloud_y[7]+32)begin
      cloud_valid=1; cloud_block_x=cloud_x[7]; cloud_block_y=cloud_y[7]; end
    else if(h_cnt >= cloud_x[8] && h_cnt < cloud_x[8]+32 && v_cnt >= cloud_y[8]  && v_cnt < cloud_y[8]+32)begin
      bomb_valid=1; cloud_block_x=cloud_x[8]; cloud_block_y=cloud_y[8]; end 
    else if(h_cnt >= cloud_x[9] && h_cnt < cloud_x[9]+32 && v_cnt >= cloud_y[9]  && v_cnt < cloud_y[9]+32)begin
      bomb_valid=1; cloud_block_x=cloud_x[9]; cloud_block_y=cloud_y[9]; end 
    else begin
      cloud_valid=0;
      bomb_valid=0;
      cloud_block_x=0;
      cloud_block_y=0;
    end
  end

 
  reg [28:0] cnt;
  always @(posedge clk_ori or posedge rst) begin
    if (rst) begin
      counter <= 30;  // 初始化為 30 秒
      cnt<=0;
    end else begin
      if(start_game) counter <= 30;
      else begin
        if(cnt<28'd100_000_000) cnt<=cnt+1;
        else begin
          if (counter>=1) begin
            counter <= counter - 1;
            cnt<=0;
          end
          else counter <= counter;
        end
      end
    end
  end

  always @(*) begin
    time_tens = counter / 10;  // 十位
    time_ones = counter % 10; // 一位

    if ((h_cnt >= 0 && h_cnt <= 51) && (v_cnt >= 0 && v_cnt < 32)) begin
      time_valid = 1;
    end else begin
      time_valid = 0;
    end
  end
endmodule