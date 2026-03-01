module final (
  input wire clk,
  input wire rst,
  input wire start,
  input wire hint,
  inout wire PS2_CLK,
  inout wire PS2_DATA,
  input wire KEY_RIGHT_MASTER,
  input wire KEY_LEFT_MASTER,
  input wire KEY_RIGHT_SLAVE,
  input wire KEY_LEFT_SLAVE,
  output [3:0] DIGIT,
  output [6:0] DISPLAY,
  output wire audio_mclk, // master clock
  output wire audio_lrck, // left-right clock
  output wire audio_sck,  // serial clock
  output wire audio_sdin, // serial audio data input
  output reg [3:0] vgaRed,
  output reg [3:0] vgaGreen,
  output reg [3:0] vgaBlue,
  output wire hsync,
  output wire vsync,
  output wire state_valid,
  output wire pass,
  output wire pass2,
  output wire pass3,
  output wire pass4
);


// add your design here

/*****for keyboard*****/
	// wire [511:0] key_down;
	// wire [8:0] last_change;
	// wire been_ready;
	// KeyboardDecoder key_de (
	// 	.key_down(key_down),
	// 	.last_change(last_change),
	// 	.key_valid(been_ready),
	// 	.PS2_DATA(PS2_DATA),
	// 	.PS2_CLK(PS2_CLK),
	// 	.rst(rst),
	// 	.clk(clk)
	// );
/****up is for keyboard****/
/*****for mouse*****/
  wire [9:0] h_cnt; //640
  wire [9:0] v_cnt;  //480
  wire [9 : 0] MOUSE_X_POS , MOUSE_Y_POS;
  wire MOUSE_LEFT , MOUSE_MIDDLE , MOUSE_RIGHT , MOUSE_NEW_EVENT;
  wire [3 : 0] mouse_cursor_red , mouse_cursor_green , mouse_cursor_blue;
  wire enable_mouse_display;
  wire isX, flip;
  reg start_game=0;
  assign isX = (MOUSE_X_POS>296 && MOUSE_X_POS<351 && MOUSE_Y_POS>325 && MOUSE_Y_POS<342)? 1:0;

  wire [11:0] mouse_pixel = {mouse_cursor_red, mouse_cursor_green, mouse_cursor_blue};
    mouse mouse_ctrl_inst(
        .clk(clk),
        .h_cntr_reg(h_cnt),
        .v_cntr_reg(v_cnt),
        .enable_mouse_display(enable_mouse_display),
        .MOUSE_X_POS(MOUSE_X_POS),
        .MOUSE_Y_POS(MOUSE_Y_POS),
        .MOUSE_LEFT(MOUSE_LEFT),
        .MOUSE_MIDDLE(MOUSE_MIDDLE),
        .MOUSE_RIGHT(MOUSE_RIGHT),
        .MOUSE_NEW_EVENT(MOUSE_NEW_EVENT),
        .mouse_cursor_red(mouse_cursor_red),
        .mouse_cursor_green(mouse_cursor_green),
        .mouse_cursor_blue(mouse_cursor_blue),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA)
    );
  /*****up for mouse*****/

    wire [11:0] data;
    wire clk_25MHz;
    wire clk_22;
    wire clk_20;
    wire clk_18;
    wire clk_24;
    wire [16:0] pixel_addr_0, pixel_addr_1, pixel_addr_2, pixel_addr_3, pixel_addr_4;
    wire [11:0] pixel_0, pixel_1, pixel_2, pixel_3, pixel_4;
    wire valid;
    wire santa_valid;

    reg show;
    wire cloud_valid, bomb_valid, money_valid, character_valid, character2_valid, time_valid;
    wire signed [10:0] cloud_block_x;
    wire signed [10:0] cloud_block_y;
    wire signed [10:0] money_block_x;
    wire signed [10:0] money_block_y;
    wire signed [10:0] character_block_x,character2_block_x;
    wire signed [10:0] character_block_y,character2_block_y;

    wire signed [10:0] character_x,character_y;
    wire [10:0]character_score;
    wire signed [10:0] character2_x,character2_y;
    wire [10:0] character2_score;
    wire character_dead,character2_dead;
    wire coin_valid;
    wire [4:0] time_ones, time_tens;
    wire [5:0] counter;

    parameter INITIAL = 0;
    parameter GAME = 1;
    parameter FINAL = 2;

    reg [1:0]state;
    reg [1:0]next_state=0;
    assign state_valid=(state==0 || state==2)?1:0;

    
/*assign {vgaRed, vgaGreen, vgaBlue} = 
    (top_image == 12'b0000_1111_1111) ? bottom_image : top_image;
*/

  always@(*)begin
    if(valid)begin
      case(state)
        INITIAL:begin
          if(enable_mouse_display) begin
            {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
          end
          else if((h_cnt>=293 && h_cnt<352 && v_cnt>=208 && v_cnt<272) || (h_cnt>=293 && h_cnt<352 && v_cnt>=320 && v_cnt<352)) begin
            if(pixel_2==12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} = 12'b0;
            else {vgaRed, vgaGreen, vgaBlue} = pixel_2;
          end
          else {vgaRed, vgaGreen, vgaBlue} = 12'b0;
        end
        GAME:begin
          if(pixel_4 == 12'b0)begin
            if(time_valid && pixel_2!=12'b0) {vgaRed, vgaGreen, vgaBlue} =pixel_2;
            else if((character_valid||character2_valid) && pixel_0!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_0;
            else if((bomb_valid||cloud_valid) && pixel_1!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_1;
            else if(money_valid && pixel_3!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_3;
            else {vgaRed, vgaGreen, vgaBlue} = 12'b0000_0010_0110;
          end
          else {vgaRed, vgaGreen, vgaBlue} = 12'b1110_1110_1110;
          // if(time_valid)begin
          //   if (pixel_2==12'b0) begin
          //     if((character_valid||character2_valid) && pixel_0!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_0;
          //     else if((bomb_valid||cloud_valid) && pixel_1!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_1;
          //     else if(money_valid && pixel_3!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_3;
          //     else {vgaRed, vgaGreen, vgaBlue} = 12'b0000_0010_0110;
          //   end
          //   else {vgaRed, vgaGreen, vgaBlue} = pixel_2;
          // end
          // else if(character_valid||character2_valid)begin
          //   if (pixel_0==12'b0000_1111_1111) begin
          //     if((bomb_valid||cloud_valid) && pixel_1!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_1;
          //     else if(money_valid && pixel_3!=12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} =  pixel_3;
          //     else {vgaRed, vgaGreen, vgaBlue} = 12'b0000_0010_0110;
          //   end
          //   else {vgaRed, vgaGreen, vgaBlue} = pixel_0;
          // end
          // else if(bomb_valid||cloud_valid)begin
          //   if (pixel_1==12'b0000_1111_1111) begin
          //     if(money_valid && pixel_3!=12'b0000_1111_1111){vgaRed, vgaGreen, vgaBlue} =  pixel_3;
          //     else {vgaRed, vgaGreen, vgaBlue} = 12'b0000_0010_0110;
          //   end
          //   else {vgaRed, vgaGreen, vgaBlue} = pixel_1;
          // end
          // else if(money_valid)begin
          //   if (pixel_3==12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} = 12'b0000_0010_0110;
          //   else {vgaRed, vgaGreen, vgaBlue} = pixel_3;
          // end
          // else begin
          //   {vgaRed, vgaGreen, vgaBlue} = 12'b0000_0010_0110;
          // end
        end
        FINAL:begin
          if(enable_mouse_display) begin
            {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
          end
           else if((h_cnt>=261 && h_cnt<384 && v_cnt>=150 && v_cnt<182) || (h_cnt>=293 && h_cnt<352 && v_cnt>=208 && v_cnt<272) || (h_cnt>=293 && h_cnt<352 && v_cnt>=320 && v_cnt<352)) begin
              if(pixel_2==12'b0000_1111_1111) {vgaRed, vgaGreen, vgaBlue} = 12'b0;
              else {vgaRed, vgaGreen, vgaBlue} = pixel_2;
            end
          else {vgaRed, vgaGreen, vgaBlue} = 12'b0;
        end
      endcase
    end
    else {vgaRed, vgaGreen, vgaBlue} = 12'b0;
    
    
      
    
  end

    clock_divider #(.n(2)) clk_wiz_0_inst(.clk(clk), .clk_div(clk_25MHz));
    clock_divider #(.n(22)) clk22(.clk(clk), .clk_div(clk_22));
    clock_divider #(.n(20)) clk20(.clk(clk), .clk_div(clk_20));
    clock_divider #(.n(24)) clk24(.clk(clk), .clk_div(clk_24));
    clock_divider #(.n(18)) clk18(.clk(clk), .clk_div(clk_18));

    mem_addr_gen mem_addr_gen_inst(
    .clk(clk_22),
    .rst(rst),
    .start(start),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .state(state),
    .cloud_valid(cloud_valid),
    .bomb_valid(bomb_valid),
    .cloud_block_x(cloud_block_x),
    .cloud_block_y(cloud_block_y),
    .money_valid(money_valid),
    .money_block_x(money_block_x),
    .money_block_y(money_block_y),
    .character_valid(character_valid),
    .character2_valid(character2_valid),
    .character_block_x(character_block_x),
    .character_block_y(character_block_y),
    .character2_block_x(character2_block_x),
    .character2_block_y(character2_block_y),
    .character_dead(character_dead),
    .character2_dead(character2_dead),
    .time_valid(time_valid),
    .time_tens(time_tens),
    .time_ones(time_ones),
    .isX(isX),
    .character_score(character_score),
    .character2_score(character2_score),
    .pixel_addr_0(pixel_addr_0),
    .pixel_addr_1(pixel_addr_1),
    .pixel_addr_2(pixel_addr_2), 
    .pixel_addr_3(pixel_addr_3),
    .pixel_addr_4(pixel_addr_4)
    );
     
 
    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_0),
      .dina(data[11:0]),
      .douta(pixel_0)
    ); 
    blk_mem_gen_1 blk_mem_gen_1_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_1),
      .dina(data[11:0]),
      .douta(pixel_1)
    ); 
    blk_mem_gen_2 blk_mem_gen_2_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_2),
      .dina(data[11:0]),
      .douta(pixel_2)
    ); 

    blk_mem_gen_3 blk_mem_gen_3_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_3),
      .dina(data[11:0]),
      .douta(pixel_3)
    ); 

    blk_mem_gen_4 blk_mem_gen_4_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_4),
      .dina(data[11:0]),
      .douta(pixel_4)
    ); 

    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );

  background_gen   background(
    .state(state),
    .clk(clk_20),
    .clk_ori(clk),
    .rst(rst),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .start_game(start_game),
    .character_x(character_x),//for stand on the cloud ,input from character_gen
    .character_y(character_y),//for stand on the clud ,input from character_gen
    .character2_x(character2_x),//for stand on the cloud ,input from character_gen
    .character2_y(character2_y),//for stand on the clud ,input from character_gen
    .cloud_valid(cloud_valid),
    .bomb_valid(bomb_valid),
    .cloud_block_x(cloud_block_x),
    .cloud_block_y(cloud_block_y),
    .character_dead(character_dead),
    .character2_dead(character2_dead),
    .time_valid(time_valid),
    .time_tens(time_tens),
    .time_ones(time_ones), 
    .counter(counter),
    .santa_valid(santa_valid),
    .pass3(pass3)
  );

  
  money_gen   money(
    .state(state),
    .clk(clk_22),
    .clk_ori(clk),
    .rst(rst),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .character_x(character_x),
    .character_y(character_y),
    .character2_x(character2_x),
    .character2_y(character2_y),
    .money_valid(money_valid),
    .coin_valid(coin_valid),
    .money_block_x(money_block_x),
    .money_block_y(money_block_y),
    .character_score(character_score),
    .character2_score(character2_score)
  );

  character_gen character(
    .state(state),
    .clk(clk_22),
    .clk_18(clk_18),
    .rst(rst),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .KEY_RIGHT_MASTER(KEY_RIGHT_MASTER),
    .KEY_LEFT_MASTER(KEY_LEFT_MASTER),
    .character_dead(character_dead),
    .character_valid(character_valid),
    .character_block_x(character_block_x),
    .character_block_y(character_block_y),
    .character_x(character_x),//for satnd on the cloud ,input to the background_gen
    .character_y(character_y),//for stand on the cloud, input to the backgrouud_gen
    .pass4(pass4)
  );

  character2_gen character2(
    .state(state),
    .clk(clk_22),
    .clk_18(clk_18),
    .rst(rst),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
		.KEY_RIGHT(KEY_RIGHT_SLAVE),
    .KEY_LEFT(KEY_LEFT_SLAVE),
    .character2_dead(character2_dead),
    .character2_valid(character2_valid),
    .character2_block_x(character2_block_x),
    .character2_block_y(character2_block_y),
    .character2_x(character2_x),//for satnd on the cloud ,input to the background_gen
    .character2_y(character2_y),//for stand on the cloud, input to the backgrouud_gen
    .pass(pass),
    .pass2(pass2)
);

  wire [15:0] nums;
  assign nums[3:0]=character_score%10;
  assign nums[7:4]=(character_score/10)%10;
  assign nums[11:8]=character2_score%10;
  assign nums[15:12]=(character2_score/10)%10;
  SevenSegment score(
    .display(DISPLAY),
	  .digit(DIGIT), 
	  .nums(nums),
	  .rst(rst),
	  .clk(clk)  
  );
  audio_play audio(
    .clk(clk),
    .rst(rst),
    .coin_valid(coin_valid),
    .santa_valid(santa_valid),
    .state(state),
    .audio_mclk(audio_mclk), // master clock
    .audio_lrck(audio_lrck), // left-right clock
    .audio_sck(audio_sck),  // serial clock
    .audio_sdin(audio_sdin)  // serial audio data input
  
);

  
  
  always@(posedge clk, posedge rst)begin
    if(rst)begin
        state<=INITIAL;
    end
    else begin
        state<=next_state;
    end
  end
reg [27:0] cooldown_counter; // 假設冷卻時間為 15 個時鐘週期
wire cooldown_done = (cooldown_counter == 0);
  always@*begin
    next_state=state;
    case(state)
        INITIAL:begin
            if(MOUSE_LEFT && isX && cooldown_done) begin
              next_state=GAME;
              start_game=1;
            end
        end
        GAME:begin
          start_game=0;
            if(time_tens==0 && time_ones==0) next_state=FINAL;
        end
        FINAL:begin
          if(MOUSE_LEFT && isX) begin
            next_state = INITIAL;

          end
        end
    endcase
  end
  always @(posedge clk or posedge rst) begin
        if (rst) begin
            cooldown_counter <= 0;
        end else if (state == INITIAL && cooldown_counter > 0) begin
            cooldown_counter <= cooldown_counter - 1; // 冷卻計數
        end else if (state == FINAL && next_state == INITIAL) begin
            cooldown_counter <= 27'd100_000_000; // 設定冷卻時間
        end
    end


endmodule

module mem_addr_gen(
  input clk,
  input rst,
  input start,
  input [9:0] h_cnt,
  input [9:0] v_cnt,
  input [1:0]state,
  input signed [10:0] cloud_block_x,
  input signed [10:0] cloud_block_y,
  input signed [10:0] money_block_x,
  input signed [10:0] money_block_y,
  input signed [10:0] character_block_x,
  input signed [10:0] character_block_y,
  input signed [10:0] character2_block_x,
  input signed [10:0] character2_block_y,
  input cloud_valid,
  input bomb_valid,
  input money_valid,
  input character_valid,
  input character2_valid,
  input character_dead,
  input character2_dead,
  input time_valid,
  input [4:0]time_ones,
  input [4:0]time_tens,
  input isX,
  input [10:0] character_score,
  input [10:0] character2_score,
  output reg [16:0] pixel_addr_0,
  output reg [16:0] pixel_addr_1,
  output reg [16:0] pixel_addr_2,
  output reg [16:0] pixel_addr_3,
  output reg [16:0] pixel_addr_4
  );
  reg [6:0] position;
  reg [8:0]move;

  clock_divider #(.n(2)) clk_wiz_0_inst(.clk(clk), .clk_div(clk_25MHz));
  
  always @(posedge clk_25MHz) begin
    move<=(move+32)%128;
  end
  
  always @ (posedge clk or posedge rst) begin
      if(rst)
          position <= 119;
       else if(position > 0)
           position <= position - 1;
       else
           position <= 119;
   end
  always @(*) begin
    pixel_addr_0=0;
    pixel_addr_1=0;
    pixel_addr_2=0;
    pixel_addr_3=0;
    pixel_addr_4=0;
    case(state)
      0:begin
        if(h_cnt>=288 && h_cnt<352 && v_cnt>=208 && v_cnt<272)begin
          pixel_addr_2 = (h_cnt-288) + (v_cnt-48) *128; 
        end
        else if(h_cnt>=288 && h_cnt<352 && v_cnt>=320 && v_cnt<352)begin
          if(isX) pixel_addr_2 = (h_cnt-224) + (v_cnt-256) *128; 
          else pixel_addr_2 = (h_cnt-288) + (v_cnt-256) *128; 
        end
      end
      1:begin
        pixel_addr_4=((h_cnt>>2)+160*(v_cnt>>2)+ position*160 )% 19200;
        if (time_valid)begin
          if (h_cnt >= 0 && h_cnt < 26) begin
              case (time_tens)
                  0: pixel_addr_2 = (h_cnt) + (v_cnt) * 128;
                  1: pixel_addr_2 = (h_cnt + 26) + (v_cnt) * 128;
                  2: pixel_addr_2 = (h_cnt + 52) + (v_cnt) * 128;
                  3: pixel_addr_2 = (h_cnt + 78) + (v_cnt) * 128;
                  4: pixel_addr_2 = (h_cnt + 104) + (v_cnt) * 128;
                  5: pixel_addr_2 = (h_cnt) + (v_cnt) * 128+32*128;
                  6: pixel_addr_2 = (h_cnt + 26) + (v_cnt) * 128+32*128;
                  7: pixel_addr_2 = (h_cnt + 52) + (v_cnt) * 128+32*128;
                  8: pixel_addr_2 = (h_cnt + 78) + (v_cnt) * 128+32*128;
                  9: pixel_addr_2 = (h_cnt + 104) + (v_cnt) * 128+32*128;
                  default: pixel_addr_2 = (h_cnt) + (v_cnt) * 128;
              endcase
          end else if (h_cnt >= 26 && h_cnt <= 51) begin
            case (time_ones)
                0: pixel_addr_2 = (h_cnt - 26) + (v_cnt) * 128;
                1: pixel_addr_2 = (h_cnt - 26 + 26) + (v_cnt) * 128;
                2: pixel_addr_2 = (h_cnt - 26 + 52) + (v_cnt) * 128;
                3: pixel_addr_2 = (h_cnt - 26 + 78) + (v_cnt) * 128;
                4: pixel_addr_2 = (h_cnt - 26 + 104) + (v_cnt) * 128;
                5: pixel_addr_2 = (h_cnt - 26) + (v_cnt) * 128+32*128;
                6: pixel_addr_2 = (h_cnt - 26 + 26) + (v_cnt) * 128+32*128;
                7: pixel_addr_2 = (h_cnt - 26 + 52) + (v_cnt) * 128+32*128;
                8: pixel_addr_2 = (h_cnt - 26 + 78) + (v_cnt) * 128+32*128;
                9: pixel_addr_2 = (h_cnt - 26 + 104) + (v_cnt) * 128+32*128;
                default: pixel_addr_2 = (h_cnt - 26) + (v_cnt) * 128;
            endcase
          end
        end
        if (character_valid)begin
          if(!character_dead) pixel_addr_0=(h_cnt-character_block_x+move)+(v_cnt-character_block_y)*128;
          else pixel_addr_0=(h_cnt-character_block_x)+(v_cnt-character_block_y)*128;
        end else if (character2_valid)begin
          if(!character2_dead)  pixel_addr_0=(h_cnt-character2_block_x+move)+(v_cnt-character2_block_y+32)*128;
          else  pixel_addr_0=(h_cnt-character2_block_x)+(v_cnt-character2_block_y+32)*128;
        end 
        if (cloud_valid) begin
          pixel_addr_1=(h_cnt-cloud_block_x+move)+(v_cnt-cloud_block_y+32)*128;
        end else if (bomb_valid)begin
          pixel_addr_1=(h_cnt-cloud_block_x+move)+(v_cnt-cloud_block_y+32+32)*128;
        end 
        if(money_valid) begin
          pixel_addr_3=(h_cnt-money_block_x+move)+(v_cnt-money_block_y)*128;
        end 
        //else begin
            //pixel_addr_0 = h_cnt + v_cnt * 128;
        //end
      end
      2:begin
        if(h_cnt>=256 && h_cnt<384 && v_cnt>=150 && v_cnt<182)begin
          pixel_addr_2 = (h_cnt-256)+(v_cnt-22)*128;
        end
        else if(h_cnt>=288 && h_cnt<352 && v_cnt>=208 && v_cnt<272)begin
          if(character_score > character2_score) pixel_addr_2 = (h_cnt-288) + (v_cnt+16) *128; //
          else if(character_score < character2_score) pixel_addr_2 = (h_cnt-224) + (v_cnt+16) *128;
          else pixel_addr_2 = (h_cnt-224) + (v_cnt-48) *128;
        end
        else if(h_cnt>=288 && h_cnt<352 && v_cnt>=320 && v_cnt<352)begin
          if(isX) pixel_addr_2 = (h_cnt-224) + (v_cnt-224) *128; 
          else pixel_addr_2 = (h_cnt-288) + (v_cnt-224) *128; 
        end
      end
    endcase
    
  end
  
endmodule