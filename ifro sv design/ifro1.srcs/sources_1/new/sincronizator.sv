module sincronizator(
    input logic clk_i, rstn_i, data_in, sel,
    output logic data_sinc_out
    );
    logic sinc1_out, sinc2_out, R1, R2;
    always_ff@(posedge clk_i or negedge rstn_i) begin
        if(rstn_i==0) begin 
        R1<=0;
        sinc1_out<=0;
        end
        else begin
        R1<=data_in;
        sinc1_out<=R1;
        end
    end 
    
    logic rstn_new;
    assign rstn_new=(rstn_i && data_in);
    
    always_ff@(posedge clk_i or negedge rstn_new) begin
        if(rstn_new==0) begin 
        R2<=0;
        sinc2_out<=R2;
        end
        else begin
        R2<=data_in;
        sinc2_out<=R2;
        end
    end 
    always_comb begin
        if(sel==0)
            data_sinc_out=sinc2_out;
            else 
            data_sinc_out=sinc1_out; 
    end
endmodule
