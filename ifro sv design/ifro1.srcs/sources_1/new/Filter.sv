module Filter(
    input logic clk_i, 
    input logic rstn_i,
    input logic [1:0] filter_type,
    input logic [3:0] window_size,
    input logic int_en,
    input logic sync_data_in,
    output logic data_out,
    output logic int_pulse
    );
    logic data_sync_delay;
    logic [10:0] counter, load_value;
    logic rise, fall, both;
    
    always_ff@(posedge clk_i or negedge rstn_i) begin
        if(rstn_i==0) data_sync_delay<=0;
        else data_sync_delay<=sync_data_in;
    end
    
    assign rise=sync_data_in && (~data_sync_delay);
    assign fall=(~sync_data_in) && data_sync_delay;
    assign both=rise||fall;
    
    always_ff@(posedge clk_i or negedge rstn_i) begin
        if(rstn_i==0) counter<=0;
        else if(filter_type==2'b00) counter<=0;
        else if (filter_type==2'b01 && sync_data_in==0 || filter_type==2'b10 && sync_data_in==1) counter<=0;
        else if(filter_type==2'b01 && rise==1 || filter_type==2'b10 && fall==1 || filter_type==2'b11 && both==1) counter<=load_value;
        else if(filter_type==2'b01 && rise==0 && sync_data_in==1 && counter>0 || filter_type==2'b10 && fall==0 && sync_data_in==0 && counter>0 || filter_type==2'b11 && both==0 && data_out==~sync_data_in && counter>0) counter<=counter-1;
    end
    
    always_ff@(posedge clk_i or negedge rstn_i) begin 
    if(rstn_i==0) data_out<=0;
    else if(counter==1) data_out<=~data_out;
    else if(filter_type==2'b01 && sync_data_in==0) data_out<=0;
    else if(filter_type==2'b10 && sync_data_in==1) data_out<=1;
    end
    
    always_ff@(posedge clk_i or negedge rstn_i) begin  
    if(rstn_i==0) int_pulse<=0;
    else int_pulse<=(int_en==1 & counter==1);
    end
    
     always_comb begin
    case(window_size)
      4'd0: load_value = 12'd3;
      4'd1: load_value = 12'd7;
      4'd2: load_value = 12'd15;
      4'd3: load_value = 12'd31;
      4'd4: load_value = 12'd47;
      4'd5: load_value = 12'd63;
      4'd6: load_value = 12'd127;
      4'd7: load_value = 12'd255;
      4'd8: load_value = 12'd511;
      4'd9: load_value = 12'd639;
      4'd10: load_value =12'd767;
      4'd11: load_value =12'd895;
      4'd12: load_value =12'd1023;
      4'd13: load_value =12'd1279;
      4'd14: load_value =12'd1535;
      4'd15: load_value =12'd2047;
    endcase 
  end
endmodule
