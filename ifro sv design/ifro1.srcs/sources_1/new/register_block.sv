module register_block
#(parameter N=8)
(
    input logic clk_i, 
    input logic rstn_i, 
    input logic acc_en_i,
    input logic wr_en_i, 
    input logic [$clog2(N+N/8)-1:0] addr_i, 
    input logic [7:0] wdata_i,
    input logic [N-1:0] status,
    output logic [7:0] rdata_o,
    output logic [2*N-1:0] filter_type,
    output logic [4*N-1:0] window_size,
    output logic [N-1:0] int_en,
    output logic [N-1:0] wd_rst
    );
    
    logic [7:0] reg_c[0:N-1];
    logic [7:0] reg_s[0: N/8 -1];
   
    genvar i;
    generate 
    for(i=0; i<N; i=i+1) begin 
    always_ff@(posedge clk_i or negedge rstn_i) begin
        if(rstn_i==0) reg_c[i]<=0;
        else if(wr_en_i==1 && acc_en_i==1 && addr_i==i) reg_c[i]<=wdata_i;
    end 
    end
    endgenerate
    
    genvar j;
    generate
    for(j=0; j<N/8; j=j+1) begin 
    always_ff@(posedge clk_i or negedge rstn_i) begin 
        if(rstn_i == 0) reg_s[j]<=0;
        else if(acc_en_i==1 && wr_en_i==0 && addr_i==N+j) reg_s[j]<=0;
        else reg_s[j]<=reg_s[j]|status[j];
    end
    end
    endgenerate
    
    genvar k;
    generate 
    for(k=0; k<N; k=k+1) begin
    assign filter_type[2*k+1:2*k] = reg_c[k][1:0];
    assign window_size[4*k+3:4*k] = reg_c[k][5:2];
    assign int_en[k]=reg_c[k][6];
    assign wd_rst[k]=reg_c[k][7];
    end
    endgenerate
    
    always_comb begin 
    if(addr_i<N && wr_en_i==0 && acc_en_i==1) rdata_o=reg_c[addr_i];
    else if(addr_i>=N && wr_en_i==0 && acc_en_i==1) rdata_o=reg_s[addr_i-N];
    else rdata_o=0;
    end
endmodule
