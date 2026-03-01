module money_gen(
  input wire [1:0] state,
  input clk,
  input clk_ori,
  input rst,
  input [9:0] h_cnt,
  input [9:0] v_cnt,
  input signed [10:0] character_x,
  input signed [10:0] character_y,
  input signed [10:0] character2_x,
  input signed [10:0] character2_y,
  output reg money_valid,
  output reg signed [10:0] money_block_x,  // 水平方向的塊位置
  output reg signed [10:0] money_block_y,   // 垂直方向的塊位置
  output reg [15:0] character_score,
  output reg [15:0] character2_score,
  output reg coin_valid
  //output reg money_eat
);

  // 定義多個雲的位置與大小
  parameter money_COUNT = 52;
  reg signed [10:0] money_x [0:money_COUNT-1];
  reg signed [10:0] money_y [0:money_COUNT-1];
  reg [money_COUNT-1:0]money_eat;

 
  parameter MOVE_SPEED = 1;
  integer i;
  //捲動
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      money_x[0] <= 352; money_y[0] <= 0; 
      money_x[1] <= 384; money_y[1] <= 0; 
      money_x[2] <= 192; money_y[2] <= 32; 
      money_x[3] <= 224; money_y[3] <= 32; 
      money_x[4] <= 256; money_y[4] <= 32; 
      money_x[5] <= 96; money_y[5] <= 96; 
      money_x[6] <= 128; money_y[6] <= 96; 
      money_x[7] <= 160; money_y[7] <= 96; 
      money_x[8] <= 192; money_y[8] <= 96; 
      money_x[9] <= 320; money_y[9] <= 96; 
      money_x[10] <= 352; money_y[10] <= 96; 
      money_x[11] <= 512; money_y[11] <= 96; 
      money_x[12] <= 0; money_y[12] <= 128; 
      money_x[13] <= 512; money_y[13] <= 160; 
      money_x[14] <= 544; money_y[14] <= 160; 
      money_x[15] <= 576; money_y[15] <= 160; 
      money_x[16] <= 192; money_y[16] <= 192; 
      money_x[17] <= 224; money_y[17] <= 192; 
      money_x[18] <= 320; money_y[18] <= 192; 
      money_x[19] <= 0; money_y[19] <= 224; 
      money_x[20] <= 416; money_y[20] <= 224; 
      money_x[21] <= 448; money_y[21] <= 224; 
      money_x[22] <= 480; money_y[22] <= 224; 
      money_x[23] <= 512; money_y[23] <= 224; 
      money_x[24] <= 128; money_y[24] <= 256; 
      money_x[25] <= 192; money_y[25] <= 256; 
      money_x[26] <= 352; money_y[26] <= 256; 
      money_x[27] <= 288; money_y[27] <= 288; 
      money_x[28] <= 512; money_y[28] <= 288; 
      money_x[29] <= 544; money_y[29] <= 288; 
      money_x[30] <= 576; money_y[30] <= 288; 
      money_x[31] <= 608; money_y[31] <= 288; 
      money_x[32] <= 0; money_y[32] <= 320; 
      money_x[33] <= 32; money_y[33] <= 320; 
      money_x[34] <= 64; money_y[34] <= 320; 
      money_x[35] <= 448; money_y[35] <= 320; 
      money_x[36] <= 192; money_y[36] <= 352; 
      money_x[37] <= 224; money_y[37] <= 352; 
      money_x[38] <= 256; money_y[38] <= 352; 
      money_x[39] <= 288; money_y[39] <= 352; 
      money_x[40] <= 64; money_y[40] <= 384;
      money_x[41] <= 96; money_y[41] <= 384; 
      money_x[42] <= 384; money_y[42] <= 384; 
      money_x[43] <= 416; money_y[43] <= 384; 
      money_x[44] <= 480; money_y[44] <= 384; 
      money_x[45] <= 608; money_y[45] <= 384; 
      money_x[46] <= 160; money_y[46] <= 448; 
      money_x[47] <= 192; money_y[47] <= 448; 
      money_x[48] <= 224; money_y[48] <= 448; 
      money_x[49] <= 416; money_y[49] <= 448; 
      money_x[50] <= 448; money_y[50] <= 448; 
      money_x[51] <= 480; money_y[51] <= 448; 
    end else begin
      case(state)
      0:begin 
      money_x[0] <= 352; money_y[0] <= 0; 
      money_x[1] <= 384; money_y[1] <= 0; 
      money_x[2] <= 192; money_y[2] <= 32; 
      money_x[3] <= 224; money_y[3] <= 32; 
      money_x[4] <= 256; money_y[4] <= 32; 
      money_x[5] <= 96; money_y[5] <= 96; 
      money_x[6] <= 128; money_y[6] <= 96; 
      money_x[7] <= 160; money_y[7] <= 96; 
      money_x[8] <= 192; money_y[8] <= 96; 
      money_x[9] <= 320; money_y[9] <= 96; 
      money_x[10] <= 352; money_y[10] <= 96; 
      money_x[11] <= 512; money_y[11] <= 96; 
      money_x[12] <= 0; money_y[12] <= 128; 
      money_x[13] <= 512; money_y[13] <= 160; 
      money_x[14] <= 544; money_y[14] <= 160; 
      money_x[15] <= 576; money_y[15] <= 160; 
      money_x[16] <= 192; money_y[16] <= 192; 
      money_x[17] <= 224; money_y[17] <= 192; 
      money_x[18] <= 320; money_y[18] <= 192; 
      money_x[19] <= 0; money_y[19] <= 224; 
      money_x[20] <= 416; money_y[20] <= 224; 
      money_x[21] <= 448; money_y[21] <= 224; 
      money_x[22] <= 480; money_y[22] <= 224; 
      money_x[23] <= 512; money_y[23] <= 224; 
      money_x[24] <= 128; money_y[24] <= 256; 
      money_x[25] <= 192; money_y[25] <= 256; 
      money_x[26] <= 352; money_y[26] <= 256; 
      money_x[27] <= 288; money_y[27] <= 288; 
      money_x[28] <= 512; money_y[28] <= 288; 
      money_x[29] <= 544; money_y[29] <= 288; 
      money_x[30] <= 576; money_y[30] <= 288; 
      money_x[31] <= 608; money_y[31] <= 288; 
      money_x[32] <= 0; money_y[32] <= 320; 
      money_x[33] <= 32; money_y[33] <= 320; 
      money_x[34] <= 64; money_y[34] <= 320; 
      money_x[35] <= 448; money_y[35] <= 320; 
      money_x[36] <= 192; money_y[36] <= 352; 
      money_x[37] <= 224; money_y[37] <= 352; 
      money_x[38] <= 256; money_y[38] <= 352; 
      money_x[39] <= 288; money_y[39] <= 352; 
      money_x[40] <= 64; money_y[40] <= 384;
      money_x[41] <= 96; money_y[41] <= 384; 
      money_x[42] <= 384; money_y[42] <= 384; 
      money_x[43] <= 416; money_y[43] <= 384; 
      money_x[44] <= 480; money_y[44] <= 384; 
      money_x[45] <= 608; money_y[45] <= 384; 
      money_x[46] <= 160; money_y[46] <= 448; 
      money_x[47] <= 192; money_y[47] <= 448; 
      money_x[48] <= 224; money_y[48] <= 448; 
      money_x[49] <= 416; money_y[49] <= 448; 
      money_x[50] <= 448; money_y[50] <= 448; 
      money_x[51] <= 480; money_y[51] <= 448; 
      end
      1:begin
        for (i = 0; i < money_COUNT; i = i + 1) begin
          if (money_y[i] >= 480) begin
            //money_eat[i]<=0;
            money_y[i] <= -32;  
          end else begin
            money_y[i] <= money_y[i] + MOVE_SPEED;
          end
          
        end
      end
      2:begin

      end
      endcase
    end
  end
  reg is_ok;
  always @(posedge clk_ori or posedge rst) begin
    if(rst)begin
      character_score<=0;
      character2_score<=0;
    end else begin
      case(state)
      0:begin 
        character_score<=0;
        character2_score<=0;
      end
      1:begin 
        coin_valid<=0;
        for (i = 0; i < money_COUNT; i = i + 1) begin
          if (money_y[i] == -32) begin
              money_eat[i]<=0;
          end
          
            if ((character_x>money_x[i]-20 && character_x<money_x[i]+20 && character_y>money_y[i]-20 && character_y<money_y[i]+20)||(character2_x>money_x[i]-20 && character2_x<money_x[i]+20 && character2_y>money_y[i]-20 && character2_y<money_y[i]+20))begin
              if(money_eat[i] == 0)begin
                coin_valid<=1;
                money_eat[i] <= 1;
                if(character2_x>money_x[i]-20 && character2_x<money_x[i]+20 && character2_y>money_y[i]-20 && character2_y<money_y[i]+20)begin
                    character2_score<=character2_score+1;
                end else begin
                    character_score<=character_score+1;
                end
              end else begin
                money_eat[i] <= 1;
              end
            end
        end
      end
      2:begin
      end
      endcase
    end
  end
  


  always @(*) begin
    if (h_cnt >= money_x[0] && h_cnt < money_x[0]+32 && v_cnt >= money_y[0]  && v_cnt < money_y[0]+32 && money_eat[0]!=1) begin
      money_valid=1; money_block_x=money_x[0];  money_block_y=money_y[0]; end
    else if (h_cnt >= money_x[1] && h_cnt < money_x[1]+32 && v_cnt >= money_y[1]  && v_cnt < money_y[1]+32 && money_eat[1]!=1) begin
      money_valid=1; money_block_x=money_x[1];  money_block_y=money_y[1]; end
    else if (h_cnt >= money_x[2] && h_cnt < money_x[2]+32 && v_cnt >= money_y[2]  && v_cnt < money_y[2]+32 && money_eat[2]!=1) begin
      money_valid=1; money_block_x=money_x[2];  money_block_y=money_y[2]; end
    else if (h_cnt >= money_x[3] && h_cnt < money_x[3]+32 && v_cnt >= money_y[3]  && v_cnt < money_y[3]+32 && money_eat[3]!=1) begin
      money_valid=1; money_block_x=money_x[3];  money_block_y=money_y[3]; end
    else if (h_cnt >= money_x[4] && h_cnt < money_x[4]+32 && v_cnt >= money_y[4]  && v_cnt < money_y[4]+32 && money_eat[4]!=1) begin
      money_valid=1; money_block_x=money_x[4];  money_block_y=money_y[4]; end
    else if (h_cnt >= money_x[5] && h_cnt < money_x[5]+32 && v_cnt >= money_y[5]  && v_cnt < money_y[5]+32 && money_eat[5]!=1) begin
      money_valid=1; money_block_x=money_x[5];  money_block_y=money_y[5]; end
    else if (h_cnt >= money_x[6] && h_cnt < money_x[6]+32 && v_cnt >= money_y[6]  && v_cnt < money_y[6]+32 && money_eat[6]!=1) begin
      money_valid=1; money_block_x=money_x[6];  money_block_y=money_y[6]; end
    else if (h_cnt >= money_x[7] && h_cnt < money_x[7]+32 && v_cnt >= money_y[7]  && v_cnt < money_y[7]+32 && money_eat[7]!=1) begin
      money_valid=1; money_block_x=money_x[7];  money_block_y=money_y[7]; end
    else if (h_cnt >= money_x[8] && h_cnt < money_x[8]+32 && v_cnt >= money_y[8]  && v_cnt < money_y[8]+32 && money_eat[8]!=1) begin
      money_valid=1; money_block_x=money_x[8];  money_block_y=money_y[8]; end
    else if (h_cnt >= money_x[9] && h_cnt < money_x[9]+32 && v_cnt >= money_y[9]  && v_cnt < money_y[9]+32 && money_eat[9]!=1) begin
      money_valid=1; money_block_x=money_x[9];  money_block_y=money_y[9]; end
    else if (h_cnt >= money_x[10] && h_cnt < money_x[10]+32 && v_cnt >= money_y[10]  && v_cnt < money_y[10]+32 && money_eat[10]!=1) begin
      money_valid=1; money_block_x=money_x[10];  money_block_y=money_y[10]; end
    else if (h_cnt >= money_x[11] && h_cnt < money_x[11]+32 && v_cnt >= money_y[11]  && v_cnt < money_y[11]+32 && money_eat[11]!=1) begin
      money_valid=1; money_block_x=money_x[11];  money_block_y=money_y[11]; end
    else if (h_cnt >= money_x[12] && h_cnt < money_x[12]+32 && v_cnt >= money_y[12]  && v_cnt < money_y[12]+32 && money_eat[12]!=1) begin
      money_valid=1; money_block_x=money_x[12];  money_block_y=money_y[12]; end
    else if (h_cnt >= money_x[13] && h_cnt < money_x[13]+32 && v_cnt >= money_y[13]  && v_cnt < money_y[13]+32 && money_eat[13]!=1) begin
      money_valid=1; money_block_x=money_x[13];  money_block_y=money_y[13]; end
    else if (h_cnt >= money_x[14] && h_cnt < money_x[14]+32 && v_cnt >= money_y[14]  && v_cnt < money_y[14]+32 && money_eat[14]!=1) begin
      money_valid=1; money_block_x=money_x[14];  money_block_y=money_y[14]; end
    else if (h_cnt >= money_x[15] && h_cnt < money_x[15]+32 && v_cnt >= money_y[15]  && v_cnt < money_y[15]+32 && money_eat[15]!=1) begin
      money_valid=1; money_block_x=money_x[15];  money_block_y=money_y[15]; end
    else if (h_cnt >= money_x[16] && h_cnt < money_x[16]+32 && v_cnt >= money_y[16]  && v_cnt < money_y[16]+32 && money_eat[16]!=1) begin
      money_valid=1; money_block_x=money_x[16];  money_block_y=money_y[16]; end
    else if (h_cnt >= money_x[17] && h_cnt < money_x[17]+32 && v_cnt >= money_y[17]  && v_cnt < money_y[17]+32 && money_eat[17]!=1) begin
      money_valid=1; money_block_x=money_x[17];  money_block_y=money_y[17]; end
    else if (h_cnt >= money_x[18] && h_cnt < money_x[18]+32 && v_cnt >= money_y[18]  && v_cnt < money_y[18]+32 && money_eat[18]!=1) begin
      money_valid=1; money_block_x=money_x[18];  money_block_y=money_y[18]; end
    else if (h_cnt >= money_x[19] && h_cnt < money_x[19]+32 && v_cnt >= money_y[19]  && v_cnt < money_y[19]+32 && money_eat[19]!=1) begin
      money_valid=1; money_block_x=money_x[19];  money_block_y=money_y[19]; end
    else if (h_cnt >= money_x[20] && h_cnt < money_x[20]+32 && v_cnt >= money_y[20]  && v_cnt < money_y[20]+32 && money_eat[20]!=1) begin
      money_valid=1; money_block_x=money_x[20];  money_block_y=money_y[20]; end
    else if (h_cnt >= money_x[21] && h_cnt < money_x[21]+32 && v_cnt >= money_y[21]  && v_cnt < money_y[21]+32 && money_eat[21]!=1) begin
      money_valid=1; money_block_x=money_x[21];  money_block_y=money_y[21]; end
    else if (h_cnt >= money_x[22] && h_cnt < money_x[22]+32 && v_cnt >= money_y[22]  && v_cnt < money_y[22]+32 && money_eat[22]!=1) begin
      money_valid=1; money_block_x=money_x[22];  money_block_y=money_y[22]; end
    else if (h_cnt >= money_x[23] && h_cnt < money_x[23]+32 && v_cnt >= money_y[23]  && v_cnt < money_y[23]+32 && money_eat[23]!=1) begin
      money_valid=1; money_block_x=money_x[23];  money_block_y=money_y[23]; end
    else if (h_cnt >= money_x[24] && h_cnt < money_x[24]+32 && v_cnt >= money_y[24]  && v_cnt < money_y[24]+32 && money_eat[24]!=1) begin
      money_valid=1; money_block_x=money_x[24];  money_block_y=money_y[24]; end
    else if (h_cnt >= money_x[25] && h_cnt < money_x[25]+32 && v_cnt >= money_y[25]  && v_cnt < money_y[25]+32 && money_eat[25]!=1) begin
      money_valid=1; money_block_x=money_x[25];  money_block_y=money_y[25]; end
    else if (h_cnt >= money_x[26] && h_cnt < money_x[26]+32 && v_cnt >= money_y[26]  && v_cnt < money_y[26]+32 && money_eat[26]!=1) begin
      money_valid=1; money_block_x=money_x[26];  money_block_y=money_y[26]; end
    else if (h_cnt >= money_x[27] && h_cnt < money_x[27]+32 && v_cnt >= money_y[27]  && v_cnt < money_y[27]+32 && money_eat[27]!=1) begin
      money_valid=1; money_block_x=money_x[27];  money_block_y=money_y[27]; end
    else if (h_cnt >= money_x[28] && h_cnt < money_x[28]+32 && v_cnt >= money_y[28]  && v_cnt < money_y[28]+32 && money_eat[28]!=1) begin
      money_valid=1; money_block_x=money_x[28];  money_block_y=money_y[28]; end
    else if (h_cnt >= money_x[29] && h_cnt < money_x[29]+32 && v_cnt >= money_y[29]  && v_cnt < money_y[29]+32 && money_eat[29]!=1) begin
      money_valid=1; money_block_x=money_x[29];  money_block_y=money_y[29]; end
    else if (h_cnt >= money_x[30] && h_cnt < money_x[30]+32 && v_cnt >= money_y[30]  && v_cnt < money_y[30]+32 && money_eat[30]!=1) begin
      money_valid=1; money_block_x=money_x[30];  money_block_y=money_y[30]; end
    else if (h_cnt >= money_x[31] && h_cnt < money_x[31]+32 && v_cnt >= money_y[31]  && v_cnt < money_y[31]+32 && money_eat[31]!=1) begin
      money_valid=1; money_block_x=money_x[31];  money_block_y=money_y[31]; end
    else if (h_cnt >= money_x[32] && h_cnt < money_x[32]+32 && v_cnt >= money_y[32]  && v_cnt < money_y[32]+32 && money_eat[32]!=1) begin
      money_valid=1; money_block_x=money_x[32];  money_block_y=money_y[32]; end
    else if (h_cnt >= money_x[33] && h_cnt < money_x[33]+32 && v_cnt >= money_y[33]  && v_cnt < money_y[33]+32 && money_eat[33]!=1) begin
      money_valid=1; money_block_x=money_x[33];  money_block_y=money_y[33]; end
    else if (h_cnt >= money_x[34] && h_cnt < money_x[34]+32 && v_cnt >= money_y[34]  && v_cnt < money_y[34]+32 && money_eat[34]!=1) begin
      money_valid=1; money_block_x=money_x[34];  money_block_y=money_y[34]; end
    else if (h_cnt >= money_x[35] && h_cnt < money_x[35]+32 && v_cnt >= money_y[35]  && v_cnt < money_y[35]+32 && money_eat[35]!=1) begin
      money_valid=1; money_block_x=money_x[35];  money_block_y=money_y[35]; end
    else if (h_cnt >= money_x[36] && h_cnt < money_x[36]+32 && v_cnt >= money_y[36]  && v_cnt < money_y[36]+32 && money_eat[36]!=1) begin
      money_valid=1; money_block_x=money_x[36];  money_block_y=money_y[36]; end
    else if (h_cnt >= money_x[37] && h_cnt < money_x[37]+32 && v_cnt >= money_y[37]  && v_cnt < money_y[37]+32 && money_eat[37]!=1) begin
      money_valid=1; money_block_x=money_x[37];  money_block_y=money_y[37]; end
    else if (h_cnt >= money_x[38] && h_cnt < money_x[38]+32 && v_cnt >= money_y[38]  && v_cnt < money_y[38]+32 && money_eat[38]!=1) begin
      money_valid=1; money_block_x=money_x[38];  money_block_y=money_y[38]; end
    else if (h_cnt >= money_x[39] && h_cnt < money_x[39]+32 && v_cnt >= money_y[39]  && v_cnt < money_y[39]+32 && money_eat[39]!=1) begin
      money_valid=1; money_block_x=money_x[39];  money_block_y=money_y[39]; end
    else if (h_cnt >= money_x[40] && h_cnt < money_x[40]+32 && v_cnt >= money_y[40]  && v_cnt < money_y[40]+32 && money_eat[40]!=1) begin
      money_valid=1; money_block_x=money_x[40];  money_block_y=money_y[40]; end
    else if (h_cnt >= money_x[41] && h_cnt < money_x[41]+32 && v_cnt >= money_y[41]  && v_cnt < money_y[41]+32 && money_eat[41]!=1) begin
      money_valid=1; money_block_x=money_x[41];  money_block_y=money_y[41]; end
    else if (h_cnt >= money_x[42] && h_cnt < money_x[42]+32 && v_cnt >= money_y[42]  && v_cnt < money_y[42]+32 && money_eat[42]!=1) begin
      money_valid=1; money_block_x=money_x[42];  money_block_y=money_y[42]; end
    else if (h_cnt >= money_x[43] && h_cnt < money_x[43]+32 && v_cnt >= money_y[43]  && v_cnt < money_y[43]+32 && money_eat[43]!=1) begin
      money_valid=1; money_block_x=money_x[43];  money_block_y=money_y[43]; end
    else if (h_cnt >= money_x[44] && h_cnt < money_x[44]+32 && v_cnt >= money_y[44]  && v_cnt < money_y[44]+32 && money_eat[44]!=1) begin
      money_valid=1; money_block_x=money_x[44];  money_block_y=money_y[44]; end
    else if (h_cnt >= money_x[45] && h_cnt < money_x[45]+32 && v_cnt >= money_y[45]  && v_cnt < money_y[45]+32 && money_eat[45]!=1) begin
      money_valid=1; money_block_x=money_x[45];  money_block_y=money_y[45]; end
    else if (h_cnt >= money_x[46] && h_cnt < money_x[46]+32 && v_cnt >= money_y[46]  && v_cnt < money_y[46]+32 && money_eat[46]!=1) begin
      money_valid=1; money_block_x=money_x[46];  money_block_y=money_y[46]; end
    else if (h_cnt >= money_x[47] && h_cnt < money_x[47]+32 && v_cnt >= money_y[47]  && v_cnt < money_y[47]+32 && money_eat[47]!=1) begin
      money_valid=1; money_block_x=money_x[47];  money_block_y=money_y[47]; end
    else if (h_cnt >= money_x[48] && h_cnt < money_x[48]+32 && v_cnt >= money_y[48]  && v_cnt < money_y[48]+32 && money_eat[48]!=1) begin
      money_valid=1; money_block_x=money_x[48];  money_block_y=money_y[48]; end
    else if (h_cnt >= money_x[49] && h_cnt < money_x[49]+32 && v_cnt >= money_y[49]  && v_cnt < money_y[49]+32 && money_eat[49]!=1) begin
      money_valid=1; money_block_x=money_x[49];  money_block_y=money_y[49]; end
    else  if (h_cnt >= money_x[50] && h_cnt < money_x[50]+32 && v_cnt >= money_y[50]  && v_cnt < money_y[50]+32 && money_eat[50]!=1) begin
      money_valid=1; money_block_x=money_x[50];  money_block_y=money_y[50]; end
    else if (h_cnt >= money_x[51] && h_cnt < money_x[51]+32 && v_cnt >= money_y[51]  && v_cnt < money_y[51]+32 && money_eat[51]!=1) begin
      money_valid=1; money_block_x=money_x[51];  money_block_y=money_y[51]; end
    else begin
      money_valid=0;
      money_block_x=0;
      money_block_y=0;
    end
  end
endmodule
