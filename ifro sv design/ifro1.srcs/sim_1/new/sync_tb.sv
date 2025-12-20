`timescale 1ns / 1ps
module sync_tb(
    );
    logic clk_i_tb, rstn_i_tb, data_in_tb, sel_tb;
    logic  data_sinc_out_tb;
    
    initial begin 
    clk_i_tb=0;
    forever #1 clk_i_tb=~clk_i_tb;
    end
    
    initial begin 
    rstn_i_tb=0;
    sel_tb=0;
    data_in_tb=0;
    #2 rstn_i_tb=1;
    #2 data_in_tb=1;
    #3.4 data_in_tb=0;
    #0.2 data_in_tb=1;
    #5.4 data_in_tb=0;
    #7 $stop();
    end
    
    sincronizator sync0(
    .clk_i(clk_i_tb),
    .rstn_i(rstn_i_tb),
    .data_in(data_in_tb),
    .sel(sel_tb),
    .data_sinc_out(data_sinc_out_tb)
    );
    
endmodule
