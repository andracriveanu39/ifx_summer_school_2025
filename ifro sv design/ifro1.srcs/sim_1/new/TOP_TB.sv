`timescale 1ns / 1ps
module TOP_TB(
    );
    parameter N_tb=8;
    logic clk_i_tb, rstn_i_tb, acc_en_i_tb, wr_en_i_tb;
    logic [$clog2(N_tb+N_tb/8)-1:0] addr_i_tb;
    logic [7:0] wdata_i_tb;
    logic [7:0] rdata_o_tb;
    logic [N_tb-1:0] data_in_tb;
    logic [N_tb-1:0] data_out_tb;
    logic int_pulse_out_tb;
    
    initial begin
    clk_i_tb=0;
    forever #1 clk_i_tb=~clk_i_tb;
    end
    
    initial begin 
    rstn_i_tb=0;
    wdata_i_tb=8'b01001101;
    addr_i_tb=0;
    #2 rstn_i_tb=1;
    wr_en_i_tb=1;
    acc_en_i_tb=1;
    #2 wdata_i_tb=8'b10011010;
    addr_i_tb=1;
    #2 wdata_i_tb=8'b10000010;
    addr_i_tb=2;
    #2 wdata_i_tb=8'b00000011;
    addr_i_tb=3;
    #2 wdata_i_tb=8'b01000111;
    addr_i_tb=4;
    #2 wdata_i_tb=8'b10000010;
    addr_i_tb=5;
    #2 wdata_i_tb=8'b01000101;
    addr_i_tb=6;
    #2 wdata_i_tb=8'b11000000;
    addr_i_tb=7;
    #2 wr_en_i_tb=0;
    acc_en_i_tb=1;
    #2 addr_i_tb=0;
    #2 addr_i_tb=1;
    #2 addr_i_tb=2;
    #2 addr_i_tb=3;
    #2 addr_i_tb=4;
    #2 addr_i_tb=5;
    #2 addr_i_tb=6;
    #2 addr_i_tb=7;
    
    end
    
    initial begin
    data_in_tb=3;
    #12 data_in_tb=2;
    #40 data_in_tb=0;
    #4 data_in_tb=2;
    #12 data_in_tb=3;
    #32 data_in_tb=1;
    #300 data_in_tb=0;
    #20 $stop();
    end
    TOP
#(.N(N_tb))
DUT(
    .clk_i(clk_i_tb), 
    .rstn_i(rstn_i_tb), 
    .acc_en_i(acc_en_i_tb), 
    .wr_en_i(wr_en_i_tb),
    .addr_i(addr_i_tb), 
    .wdata_i(wdata_i_tb),
    .rdata_o(rdata_o_tb),
    .data_in(data_in_tb), 
    .data_out(data_out_tb),
    .int_pulse_out(int_pulse_out_tb)
    );
endmodule
