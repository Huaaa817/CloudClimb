module final_slave(
  input wire clk,
  input wire rst,
  inout wire PS2_CLK,
  inout wire PS2_DATA,
  input wire state_valid,
  output wire audio_mclk, // master clock
  output wire audio_lrck, // left-right clock
  output wire audio_sck,  // serial clock
  output wire audio_sdin, // serial audio data input
  output reg KEY_RIGHT_MASTER,
  output reg KEY_LEFT_MASTER,
  output reg KEY_RIGHT,
  output reg KEY_LEFT,
  output reg pass,
  output reg pass2,
  output reg pass3,
  output pass4
);
    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
    


    
	parameter [8:0] HOME_CODES =9'b0_0110_1011;
    parameter [8:0] END_CODES  =9'b0_0111_0100;
    parameter [8:0] A_CODES = 9'b0_0001_1100;//1C
	parameter [8:0] D_CODES = 9'b0_0010_0011;//23
    
    reg key_pressed,key_pressed2;
	reg [8:0] now_last_change,now_last_change2;
    reg freeze;

    always @ (posedge clk, posedge rst) begin
		if (rst) begin
			key_pressed2<=1'b0;
            KEY_RIGHT_MASTER<=0;
            KEY_RIGHT_MASTER<=0;
		end else begin
            if(key_down[last_change] && !key_pressed2)begin
                now_last_change2<=last_change;
                
                case(last_change)
                    HOME_CODES:begin KEY_LEFT_MASTER<=1; pass<=1;key_pressed2<=1;end
                    END_CODES:begin KEY_RIGHT_MASTER<=1;pass2<=1; key_pressed2<=1;end 
                endcase 
            end else if(key_down[now_last_change2]==1'b0 && key_pressed2)begin
                
                case(now_last_change2)
                    HOME_CODES:begin KEY_LEFT_MASTER<=0;pass<=0;key_pressed2<=0;end
                    END_CODES:begin  KEY_RIGHT_MASTER<=0; pass2<=0;key_pressed2<=0;end 
                endcase 
            end
		end
	end
    always @ (posedge clk, posedge rst) begin
		if (rst) begin
			key_pressed<=1'b0;
            KEY_LEFT<=0;
            KEY_RIGHT<=0;
		end else begin
            if(key_down[last_change] && !key_pressed)begin
                now_last_change<=last_change;
                
                case(last_change)
                    A_CODES:begin KEY_LEFT<=1; key_pressed<=1;end
                    D_CODES:begin KEY_RIGHT<=1; key_pressed<=1;end
                endcase 
            end else if(key_down[now_last_change]==1'b0 && key_pressed)begin
                
                case(now_last_change)
                    A_CODES:begin KEY_LEFT<=0; key_pressed<=0;end
                    D_CODES:begin KEY_RIGHT<=0;key_pressed<=0;  end
                endcase 
            end
		end
	end



    audio_play audip_initfinal (
    .clk(clk),
    .rst(rst),
    .state_valid(state_valid),
    .audio_mclk(audio_mclk), // master clock
    .audio_lrck(audio_lrck), // left-right clock
    .audio_sck(audio_sck),  // serial clock
    .audio_sdin(audio_sdin)  // serial audio data input
);


endmodule