module audio_play (
    input wire clk,
    input wire rst,
    input wire coin_valid,
    input wire santa_valid,
    input wire [1:0] state,
    output wire audio_mclk, // master clock
    output wire audio_lrck, // left-right clock
    output wire audio_sck,  // serial clock
    output wire audio_sdin  // serial audio data input
    
);

    wire [15:0] audio_data;
    
    // Clock divider for 25 kHz sample clock
    reg [15:0] sample_clk_div;
    reg sample_clk;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sample_clk_div <= 0;
            sample_clk <= 0;
        end else if (sample_clk_div == 500 - 1) begin // 100 MHz / 25 kHz = 4000
            sample_clk_div <= 0;
            sample_clk <= ~sample_clk; // Flip the clock
        end else begin
            sample_clk_div <= sample_clk_div + 1;
        end
    end

   



    // ROM Module
    audio_rom audio_rom_inst (
        .clk(sample_clk),
        .coin_valid(coin_valid),
        .santa_valid(santa_valid),
        .state(state),
        .rst(rst),
        .audio_out(audio_data)
    );

    // Speaker control module (connects audio data to output interface)
    speaker_control speaker_ctrl (
        .clk(clk),
        .rst(rst),
        .audio_in_left(audio_data),  // Mono audio to both left and right
        .audio_in_right(audio_data),
        .audio_mclk(audio_mclk),
        .audio_lrck(audio_lrck),
        .audio_sck(audio_sck),
        .audio_sdin(audio_sdin)
    );

endmodule

module audio_rom (
    input wire clk,
    input wire rst,
    input wire coin_valid,
    input wire santa_valid,
    input wire [1:0] state,
    output reg [15:0] audio_out
);

    reg [15:0] rom [0:25000-1]; // Assuming 1 second of audio at 44.1kHz
    reg [15:0] rom_santa [0:34704-1];
    reg [31:0] rom_addr;
    reg playing;
    integer volume=3;

    initial begin
        $readmemh("audio_data.mem", rom); // Load audio data from memory file
         $readmemh("audio_santa3.mem", rom_santa);
    end

    reg santa_valid_cur;
    reg kk;
   reg coin_valid_cur;
   reg hh;
   reg now_santa,now_coin;

   always@(*)begin
    if(coin_valid && !hh)begin
        coin_valid_cur=1;
    end else if(hh) coin_valid_cur=0;
   end

   always@(*)begin
    if(santa_valid && !kk)begin
        santa_valid_cur=1;
    end else if(kk) santa_valid_cur=0;
   end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            playing<=0;
            rom_addr<= 0;
            hh<=0;
        end else begin
            case(state)
            0:begin 
                // audio_out <= rom_santa[rom_addr_santa]*volume;
                // rom_addr_santa <= (rom_addr_santa==27500-1)?0:rom_addr_santa + 1; 
            end
            1:begin
                if(santa_valid_cur && !playing)begin
                    kk<=1;
                    playing <= 1;
                    rom_addr <= 0;
                    now_santa<=1;now_coin<=0;
                end else if (coin_valid_cur && !playing) begin
                    // 开始播放
                    hh<=1;
                    playing <= 1;
                    rom_addr <= 0;
                    now_coin<=1; now_santa<=0;
                end else if (playing) begin
                    // 播放过程中
                    if(now_coin)begin
                        hh<=0;
                        audio_out <= rom[rom_addr]*volume;
                        rom_addr <= rom_addr + 1; // 更新地址
                        if (rom_addr == 25001 - 1) begin
                            // 播放结束
                            playing <= 0;
                        end
                    end else begin
                        kk<=0;
                        audio_out <= rom_santa[rom_addr]*volume;
                        rom_addr <= rom_addr + 1; // 更新地址
                        if (rom_addr == 34704 - 1) begin
                            // 播放结束
                            playing <= 0;
                        end
                    end
                end
            end 
            2:begin
            end
            endcase
        end
end


endmodule

module speaker_control(
    input clk,  // clock from the crystal
    input rst,  // active high reset
    input [15:0] audio_in_left, // left channel audio data input
    input [15:0] audio_in_right, // right channel audio data input
    output audio_mclk, // master clock
    output audio_lrck, // left-right clock, Word Select clock, or sample rate clock
    output audio_sck, // serial clock
    output reg audio_sdin // serial audio data input
    ); 

    // Declare internal signal nodes 
    wire [8:0] clk_cnt_next;
    reg [8:0] clk_cnt;
    reg [15:0] audio_left, audio_right;

    // Counter for the clock divider
    assign clk_cnt_next = clk_cnt + 1'b1;

    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            clk_cnt <= 9'd0;
        else
            clk_cnt <= clk_cnt_next;

    // Assign divided clock output
    assign audio_mclk = clk_cnt[1];
    assign audio_lrck = clk_cnt[8];
    assign audio_sck = 1'b1; // use internal serial clock mode

    // audio input data buffer
    always @(posedge clk_cnt[8] or posedge rst)
        if (rst == 1'b1)
            begin
                audio_left <= 16'd0;
                audio_right <= 16'd0;
            end
        else
            begin
                audio_left <= audio_in_left;
                audio_right <= audio_in_right;
            end

    always @*
        case (clk_cnt[8:4])
            5'b00000: audio_sdin = audio_right[0];
            5'b00001: audio_sdin = audio_left[15];
            5'b00010: audio_sdin = audio_left[14];
            5'b00011: audio_sdin = audio_left[13];
            5'b00100: audio_sdin = audio_left[12];
            5'b00101: audio_sdin = audio_left[11];
            5'b00110: audio_sdin = audio_left[10];
            5'b00111: audio_sdin = audio_left[9];
            5'b01000: audio_sdin = audio_left[8];
            5'b01001: audio_sdin = audio_left[7];
            5'b01010: audio_sdin = audio_left[6];
            5'b01011: audio_sdin = audio_left[5];
            5'b01100: audio_sdin = audio_left[4];
            5'b01101: audio_sdin = audio_left[3];
            5'b01110: audio_sdin = audio_left[2];
            5'b01111: audio_sdin = audio_left[1];
            5'b10000: audio_sdin = audio_left[0];
            5'b10001: audio_sdin = audio_right[15];
            5'b10010: audio_sdin = audio_right[14];
            5'b10011: audio_sdin = audio_right[13];
            5'b10100: audio_sdin = audio_right[12];
            5'b10101: audio_sdin = audio_right[11];
            5'b10110: audio_sdin = audio_right[10];
            5'b10111: audio_sdin = audio_right[9];
            5'b11000: audio_sdin = audio_right[8];
            5'b11001: audio_sdin = audio_right[7];
            5'b11010: audio_sdin = audio_right[6];
            5'b11011: audio_sdin = audio_right[5];
            5'b11100: audio_sdin = audio_right[4];
            5'b11101: audio_sdin = audio_right[3];
            5'b11110: audio_sdin = audio_right[2];
            5'b11111: audio_sdin = audio_right[1];
            default: audio_sdin = 1'b0;
        endcase

endmodule