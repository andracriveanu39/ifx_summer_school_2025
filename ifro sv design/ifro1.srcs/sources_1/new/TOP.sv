module TOP
#(parameter N=8)
(
    input logic clk_i, rstn_i, acc_en_i, wr_en_i,
    input logic [$clog2(N+N/8)-1:0] addr_i, 
    input logic [7:0] wdata_i,
    output logic [7:0] rdata_o,
    input logic [N-1:0] data_in, 
    output logic [N-1:0] data_out,
    output logic int_pulse_out
    );
    
    logic [N-1:0] sel, sync_data_out;
    logic [2*N-1:0] filter_type;
    logic [4*N-1:0] window_size;
    logic [N-1:0] int_en;
    logic [N-1:0] interrupt_status;
    genvar i;
    
    generate 
    
    for(i=0; i<N; i=i+1) begin
    sincronizator u0(clk_i, rstn_i, data_in[i], sel[i], sync_data_out[i]);
    end
    
    endgenerate
    
    register_block
#(.N(N)
) rb0 (
   .clk_i(clk_i), 
   .rstn_i(rstn_i), 
   .acc_en_i(acc_en_i),
   .wr_en_i(wr_en_i), 
   .addr_i(addr_i), 
   .wdata_i(wdata_i),
   .rdata_o(rdata_o),
   .filter_type(filter_type),
   .window_size(window_size),
   .int_en(int_en),
   .wd_rst(sel), 
   .status(interrupt_status) 
    );
    
    genvar j;
    
    generate 
    
    for(j=0; j<N; j=j+1) begin
    Filter f0(clk_i, rstn_i, filter_type[2*j+1:2*j], window_size[4*j+3:4*j], int_en[j], sync_data_out[j], data_out[j], interrupt_status[j]);
    end
    
    endgenerate
   assign int_pulse_out=|interrupt_status;
endmodule
