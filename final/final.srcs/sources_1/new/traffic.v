`timescale 1s/1s

module TL_DIV(
    input clk,reset,
    output [2:0] lightA,lightB,
    output [7:0] rowA,rowB,
    output [7:0] columnA, columnB
);
wire clk_div;
//wire clk_div1k;
traffic_div inst1(.clk(clk), .reset(reset), .clk_1hz(clk_div));
traffic     inst2(.clk(clk_div), .reset(reset), .lightA(lightA), .lightB(lightB));

//traffic_div1k inst3(.clk(clk), .reset(reset), .clk_1khz(clk_div1k));
//traffic_person inst4(.clk(clk_div), .reset(reset), .rowA(rowA), .rowB(rowB), .columnA(columnA), .columnB(columnB));
endmodule


//小綠人程式碼
/*module traffic_person(
    input clk,reset,
    output reg [7:0] rowA,rowB, 
    output reg [7:0] columnA, columnB 
);

wire [7:0] row1,column1;  //slow
wire [7:0] row2,column2;  //fast
wire [7:0] row3,column3;  //stop

green_person_slow inst5(
    .clk(clk),
    .reset(reset),
    .row_s(row1),
    .column_s(column1)
);
green_person_fast inst6(
    .clk(clk),
    .reset(reset),
    .row_f(row2),
    .column_f(column2)
);
green_person_stop inst7(
    .clk(clk),
    .reset(reset),
    .row_p(row3),
    .column_p(column3)
);

reg [1:0] next_state, current_state; //總共四種狀態
reg [3:0] next_count = 4'd1; 
reg [3:0] current_count = 4'd1 ; //路口秒數計時器，會數到8，故需3bits


//next state combinational logic
 always@(*)
 begin
    case(current_state)
        2'b00:
        begin
            //當狀態S0時，A路口綠燈，B路口紅燈，共歷時8秒
            next_count = (current_count < 4'd8) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd8) ? 2'b00 : 2'b01;
        end
        
        2'b01:
        begin
            //當狀態S1時，A路口黃燈，B路口紅燈，共歷時5秒
            next_count = (current_count < 4'd5) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd5) ? 2'b01 : 2'b10;
        end

        2'b10:
        begin
            //當狀態S2時，A路口紅燈，B路口綠燈，共歷時8秒
            next_count = (current_count < 4'd8) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd8) ? 2'b10 : 2'b11;
        end
        
        2'b11:
        begin
            //當狀態S3時，A路口紅燈，B路口黃燈，共歷時5秒
            next_count = (current_count < 4'd5) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd5) ? 2'b11 : 2'b00;
        end        
    endcase
 end

 //state register
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        current_count <= 4'd1;
        current_state <= 2'b00;
    end
    else
    begin
        current_count <= next_count;
        current_state <= next_state;
    end
end

//output combinational logic
always@(*)
begin
    case(current_state)
        2'b00: //A綠燈 B紅燈
        begin
            rowA = row1 ;
            columnA = column1;
            rowB = row3 ;
            columnB = column3;
        end
        
        2'b01:
        begin
            rowA = row2 ;
            columnA = column2;
            rowB = row3 ;
            columnB = column3;
        end
        
        2'b10:
        begin
            rowA = row3 ;
            columnA = column3;
            rowB = row1 ;
            columnB = column1;
        end
        
        2'b11:
        begin
            rowA = row3 ;
            columnA = column3;
            rowB = row2 ;
            columnB = column2;
        end
    endcase
end
endmodule*/


//紅綠燈程式碼
module traffic(
    input clk,reset,
    output reg [2:0] lightA, 
    output reg [2:0] lightB
);

reg [1:0] next_state, current_state; //總共四種狀態
reg [3:0] next_count = 4'd1; 
reg [3:0] current_count = 4'd1 ; //路口秒數計時器，會數到8，故需3bits

parameter green = 3'b001;
parameter yellow = 3'b010;
parameter red = 3'b100;

//next state combinational logic
 always@(*)
 begin
    case(current_state)
        2'b00:
        begin
            //當狀態S0時，A路口綠燈，B路口紅燈，共歷時8秒
            next_count = (current_count < 4'd8) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd8) ? 2'b00 : 2'b01;
        end
        
        2'b01:
        begin
            //當狀態S1時，A路口黃燈，B路口紅燈，共歷時5秒
            next_count = (current_count < 4'd5) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd5) ? 2'b01 : 2'b10;
        end

        2'b10:
        begin
            //當狀態S2時，A路口紅燈，B路口綠燈，共歷時8秒
            next_count = (current_count < 4'd8) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd8) ? 2'b10 : 2'b11;
        end
        
        2'b11:
        begin
            //當狀態S3時，A路口紅燈，B路口黃燈，共歷時5秒
            next_count = (current_count < 4'd5) ? current_count + 4'd1 : 4'd1;
            next_state = (current_count < 4'd5) ? 2'b11 : 2'b00;
        end        
    endcase
 end

 //state register
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        current_count <= 4'd1;
        current_state <= 2'b00;
    end
    else
    begin
        current_count <= next_count;
        current_state <= next_state;
    end
end

//output combinational logic
always@(*)
begin
    case(current_state)
        2'b00: //A綠燈 B紅燈
        begin
            lightA = green;
            lightB = red;
        end
        
        2'b01:
        begin
            lightA = yellow;
            lightB = red;
        end
        
        2'b10:
        begin
            lightA = red;
            lightB = green;
        end
        
        2'b11:
        begin
            lightA = red;
            lightB = yellow;
        end
    endcase
end
endmodule

// 1Hz除頻器
module traffic_div(
input clk,
input reset,
output reg clk_1hz
);

reg [25:0] cnt=0;

always@(posedge clk or posedge reset) 
begin
	if (reset) 
		cnt<=26'd0;
	else if(cnt==62500000-1)
		cnt<=26'd0;
	else	
		cnt <= cnt + 26'd1;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		clk_1hz<=1'b0;
	else if(cnt==31250000-1)
		clk_1hz <= ~clk_1hz;
end
endmodule



//1kHz除頻器
/*module traffic_div1k(
input clk,
input reset,
output reg clk_1khz
);

reg [16:0] cnt=0;

always@(posedge clk or posedge reset) 
begin
	if (reset) 
		cnt<=17'd0;
	else if(cnt==62500-1)
		cnt<=17'd0;
	else	
		cnt <= cnt + 17'd1;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		clk_1khz<=1'b0;
	else if(cnt==31250-1)
		clk_1khz <= ~clk_1khz;
end
endmodule*/



//小綠人慢跑
/*module green_person_slow(
    input clk,reset,
    output reg [7:0] row_s,
    output reg [7:0] column_s
);


reg [2:0] row_count;
reg [2:0] picture_count; //控制圖片切換
reg [23:0] picture_timer; //控制圖片的切換速度 

//慢跑動畫共7張圖片，每張大小8*8
reg [7:0]slow [6:0][7:0];   //[7:0]:8bits寬，[6:0]:有七種圖片，[7:0]:row

initial
begin
        slow[0][0] = 8'b00110000;   //picture 1
        slow[0][1] = 8'b00110000;
        slow[0][2] = 8'b00011110;
        slow[0][3] = 8'b00111001;
        slow[0][4] = 8'b01001000;
        slow[0][5] = 8'b00010100;
        slow[0][6] = 8'b00100010;
        slow[0][7] = 8'b01100001;
        
        slow[1][0] = 8'b00110000;   //picture 2
        slow[1][1] = 8'b00110000;
        slow[1][2] = 8'b00011110;
        slow[1][3] = 8'b00111011;
        slow[1][4] = 8'b01101000;
        slow[1][5] = 8'b00010100;
        slow[1][6] = 8'b00100100;
        slow[1][7] = 8'b00100010;
        
        slow[2][0] = 8'b00110000;   //picture 3
        slow[2][1] = 8'b00110000;
        slow[2][2] = 8'b00011100;
        slow[2][3] = 8'b00011010;
        slow[2][4] = 8'b00101000;
        slow[2][5] = 8'b00010100;
        slow[2][6] = 8'b00100100;
        slow[2][7] = 8'b00100010;
        
        slow[3][0] = 8'b00110000;   //picture 4
        slow[3][1] = 8'b00110000;
        slow[3][2] = 8'b00011000;
        slow[3][3] = 8'b00011100;
        slow[3][4] = 8'b00011000;
        slow[3][5] = 8'b00001100;
        slow[3][6] = 8'b00010100;
        slow[3][7] = 8'b00100100;
        
        slow[4][0] = 8'b00110000;   //picture 5
        slow[4][1] = 8'b00110000;
        slow[4][2] = 8'b00011000;
        slow[4][3] = 8'b00011000;
        slow[4][4] = 8'b00011000;
        slow[4][5] = 8'b00001100;
        slow[4][6] = 8'b00001100;
        slow[4][7] = 8'b00000100;
        
        slow[5][0] = 8'b00110000;   //picture 6
        slow[5][1] = 8'b00110000;
        slow[5][2] = 8'b00011100;
        slow[5][3] = 8'b00011000;
        slow[5][4] = 8'b00111000;
        slow[5][5] = 8'b00001100;
        slow[5][6] = 8'b00010100;
        slow[5][7] = 8'b00010010;
        
        slow[6][0] = 8'b00110000;   //picture 7
        slow[6][1] = 8'b00110000;
        slow[6][2] = 8'b00011100;
        slow[6][3] = 8'b00111010;
        slow[6][4] = 8'b01011000;
        slow[6][5] = 8'b00001000;
        slow[6][6] = 8'b00010100;
        slow[6][7] = 8'b00100010;
end

always@(posedge clk or posedge reset)
begin
    if(reset) row_count <= 0;
    else row_count <= row_count + 1;
end

always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        picture_timer <= 0;
        picture_count <= 0;
    end
    else
    begin
        picture_timer <= picture_timer + 1;
        if(picture_timer == 24'd1000000)
        begin
            picture_timer <= 0;
            picture_count <= picture_count + 1;
        end
        if(picture_count == 6)
        begin
            picture_count <= 0;
        end
    end    
end

always@(*)
begin
    row_s = (row_count < 8)? (8'b00000001 << row_count) : 8'b00000000;
    column_s = (row_count < 8)? (~slow[picture_count][row_count]) : 8'b11111111;
end
endmodule


//小綠人快跑
module green_person_fast(
    input clk,reset,
    output reg [7:0] row_f,
    output reg [7:0] column_f
);

reg [2:0] row_count;
reg [2:0] picture_count;
reg [23:0] picture_timer;
reg [7:0] fast [7:0][7:0]; //[7:0]：8bits  [7:0]：7張照片  [7:0]：8個row

initial
begin
    fast[0][0]=8'b01110000; //picture1
    fast[0][1]=8'b01100000;
    fast[0][2]=8'b00110000;
    fast[0][3]=8'b01111000;
    fast[0][4]=8'b00011000;
    fast[0][5]=8'b00110100;
    fast[0][6]=8'b00100010;
    fast[0][7]=8'b01100110;
 
    fast[1][0]=8'b01110000; //picture2
    fast[1][1]=8'b01100000;
    fast[1][2]=8'b00110000;
    fast[1][3]=8'b01111100;
    fast[1][4]=8'b01011010;
    fast[1][5]=8'b00110100;
    fast[1][6]=8'b01100010;
    fast[1][7]=8'b01000010;
    
    fast[2][0]=8'b01110000; //picture3
    fast[2][1]=8'b01100000;
    fast[2][2]=8'b00110000;
    fast[2][3]=8'b01111100;
    fast[2][4]=8'b10110010;
    fast[2][5]=8'b00011000;
    fast[2][6]=8'b01100110;
    fast[2][7]=8'b00000010;
    
    fast[3][0]=8'b11100000; //picture4
    fast[3][1]=8'b11000000;
    fast[3][2]=8'b01111000;
    fast[3][3]=8'b01100100;
    fast[3][4]=8'b10110000;
    fast[3][5]=8'b00101000;
    fast[3][6]=8'b11000110;
    fast[3][7]=8'b00000010;
    
    fast[4][0]=8'b11100000; //picture5
    fast[4][1]=8'b11000000;
    fast[4][2]=8'b01100000;
    fast[4][3]=8'b01111000;
    fast[4][4]=8'b10110100;
    fast[4][5]=8'b00111010;
    fast[4][6]=8'b00100110;
    fast[4][7]=8'b11100010;
    
    fast[5][0]=8'b11100000; //picture6
    fast[5][1]=8'b11000000;
    fast[5][2]=8'b01100000;
    fast[5][3]=8'b01111000;
    fast[5][4]=8'b10110100;
    fast[5][5]=8'b00110010;
    fast[5][6]=8'b01001100;
    fast[5][7]=8'b11000100;
    
    fast[6][0]=8'b11100000; //picture7
    fast[6][1]=8'b11000000;
    fast[6][2]=8'b01100000;
    fast[6][3]=8'b01111000;
    fast[6][4]=8'b01110100;
    fast[6][5]=8'b00110000;
    fast[6][6]=8'b01011000;
    fast[6][7]=8'b00101000;
    
    fast[7][0]=8'b01110000; //picture8
    fast[7][1]=8'b01100000;
    fast[7][2]=8'b00110000;
    fast[7][3]=8'b00111000;
    fast[7][4]=8'b00011000;
    fast[7][5]=8'b00010100;
    fast[7][6]=8'b00011100;
    fast[7][7]=8'b00000100;
end

always@(posedge clk or posedge reset)
begin
    if(reset)   row_count <= 0;
    else        row_count <= row_count + 1; 
end

always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        picture_timer <= 0;
        picture_count <= 0;
    end
    else
    begin
        picture_timer <= picture_timer + 1;
        if(picture_timer == 24'd10000000)
        begin
            picture_timer <= 0;
            picture_count <= picture_count + 1;
        end
        if(picture_count == 7)  picture_count <= 0;
    end
end

always@(*)
begin
    row_f = (row_count < 8) ? (8'b00000001 << row_count) : 8'b00000000;
    column_f = (row_count < 8) ? (~fast[picture_count][row_count]) : 8'b11111111;
end
endmodule



//小路人停止
module green_person_stop(
    input clk,reset,
    output reg [7:0] row_p,
    output reg [7:0] column_p
);

reg [2:0] row_count;
reg [7:0] stop [7:0]; //一張8*8的照片

initial
begin
    stop[0] = 8'b00011000;
    stop[1] = 8'b00011000;
    stop[2] = 8'b00111100;
    stop[3] = 8'b01011010;
    stop[4] = 8'b01011010;
    stop[5] = 8'b00011000;
    stop[6] = 8'b00100100;
    stop[7] = 8'b11000011;
end

always@(posedge clk or posedge reset)
begin
    if(reset)   row_count <= 0;
    else        row_count <= row_count + 1;
end

always@(*)
begin
    row_p = (row_count < 8) ? (8'b00000001 << row_count) : 8'b00000000;
    column_p = (row_count < 8) ? (~stop[row_count]) : 8'b11111111;
end
endmodule*/
