`timescale 1s/1s

module traffic_tb;

reg clk;
reg reset;
wire [2:0] lightA;
wire [2:0] lightB;
/*wire [7:0] rowA;
wire [7:0] columnA;
wire [7:0] rowB;
wire [7:0] columnB;*/



TL_DIV aaa(
    .clk(clk),
    .reset(reset),
    .lightA(lightA),
    .lightB(lightB)
/*    .rowA(rowA),
    .columnA(columnA),
    .rowB(rowB),
    .columnB(columnB)*/
);

initial begin
        clk = 0;
        forever #4 clk = ~clk; // 8ns週期的時鐘信號 (125MHz)
    end

// Reset logic
initial
begin
    reset = 1;
    #10; 
    reset = 0; //等10個時間週期後，開始跑程式 
    
    #625000; //運行50000個時間週期
    
    $stop; //停止模擬
end

// Monitor the outputs
initial
begin
    $monitor($time , "lightA = %3b, lightB: %3b", 
                     lightA,       lightB);
end

endmodule