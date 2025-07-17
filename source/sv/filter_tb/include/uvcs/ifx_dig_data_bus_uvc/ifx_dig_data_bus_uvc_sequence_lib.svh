/******************************************************************************
 * (C) Copyright 2020 All Rights Reserved
 *
 * MODULE:
 * DEVICE:
 * PROJECT:
 * AUTHOR:
 * DATE:
 * FILE:
 * REVISION:
 *
 * FILE DESCRIPTION:
 *
 *******************************************************************************/

/// very simple sequence - it generates only one transaction to the driver
class ifx_dig_data_bus_uvc_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);

  `uvm_object_utils(ifx_dig_data_bus_uvc_sequence)

  ifx_dig_data_bus_uvc_seq_item seq_item;

  bit[`DWIDTH-1:0] data;
  bit[`AWIDTH-1:0] address;
  access_type_t access_type;
  bit is_random_b;

  constraint read_mode_addr_constr{
    if (access_type == READ) {
      address >=0;
      address <= 2**`AWIDTH-1;
      }
  }

  //Constructor
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body ();

    `uvm_create(seq_item)// create the object
    if (is_random_b) begin
      void'(seq_item.randomize());
    end
    else begin
      seq_item.address     = address;
      seq_item.data        = data;
      seq_item.access_type = access_type;
    end

    `uvm_info(get_type_name(), $sformatf("Executing sequence with parameters access_type=%p address=%d data=%0d", seq_item.access_type, seq_item.address, seq_item.data), UVM_MEDIUM)

    `uvm_send(seq_item) // send the object to the sequencer

    `uvm_info(get_type_name()," Item finished ", UVM_MEDIUM)
  endtask

endclass


// TODO: Implement a sequence capable of sending a read request to a specified address.
class ifx_dig_data_bus_uvc_read_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);

  `uvm_object_utils(ifx_dig_data_bus_uvc_read_sequence)
  bit[`AWIDTH-1:0] address; // sequence nu stie adresa la care vreau eu sa fac operattia, trebuie sa o obtin extern
  ifx_dig_data_bus_uvc_seq_item seq_item;

  //Constructor
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body ();

    // HINT: create the sequence item object
    `uvm_create(seq_item); //cream un item, de data asta e necesar fata de pin_filter pt ca nu apelam o clasa care creeaza un item

    seq_item.address = address;
    seq_item.access_type = READ;

    `uvm_info(get_type_name(), $sformatf("Executing read sequence with parameters access_type=%p address=%d data=%0d", seq_item.access_type, seq_item.address, seq_item.data), UVM_MEDIUM)

     //HINT: send the sequence item object to the sequencer
     `uvm_send(seq_item); //send the object to the sequencer

    `uvm_info(get_type_name()," Item finished ", UVM_MEDIUM)
  endtask

endclass



class ifx_dig_data_bus_uvc_write_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);

  `uvm_object_utils(ifx_dig_data_bus_uvc_write_sequence)

  ifx_dig_data_bus_uvc_seq_item seq_item;

  bit[`AWIDTH-1:0] address;
  bit[`DWIDTH-1:0] data;
  bit is_random_b;

  //Constructor
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body ();

    `uvm_create(seq_item)// create the object
    if (is_random_b) begin
      void'(seq_item.randomize() with {
          seq_item.access_type == WRITE;
        });
    end
    else begin
      seq_item.access_type = WRITE;
      seq_item.address     = address;
      seq_item.data        = data;
    end

    `uvm_info(get_type_name(), $sformatf("Executing write sequence with parameters access_type=%p address=%d data=%0d", seq_item.access_type, seq_item.address, seq_item.data), UVM_MEDIUM)

    `uvm_send(seq_item) // send the object to the sequencer

    `uvm_info(get_type_name()," Item finished ", UVM_MEDIUM)
  endtask

endclass

// TODO: Implement general sequence capable of driving both read and write
class ifx_dig_data_bus_uvc_op_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);
    `uvm_object_utils(ifx_dig_data_bus_uvc_op_sequence)
    rand bit[`AWIDTH-1:0] address; //adaugam la toate rand pentru a nu fi nevoie sa setez eu valorile 
    rand bit[`DWIDTH-1:0] data;
    rand access_type_t access_type;

    constraint access_type_c { //o constrangere inseamna o limitare a randomizarii
        access_type inside {READ, WRITE}; //impun ca access_type sa fie fie READ sau WRITE 
    } 

    constraint data_for_read_c {
        if (access_type == READ) { //pot constrange in functie de alta valoare
            data == 0; //datele de input sa fie tot timpul 0 cand facem citire
        }
    }

    ifx_dig_data_bus_uvc_seq_item seq_item;

    function new(string name = get_type_name());
        super.new(name);
    endfunction

    virtual task body(); //in body se face implementarea
    `uvm_create(seq_item); //prima etapa:crearea seq_item

    seq_item.address=address; //a doua etapa:particularizarea seq_item
    seq_item.data=data;
    seq_item.access_type=access_type; //face read sau write

    `uvm_send(seq_item) //ultima etapa: trimiterea secventei catre sequencer
    endtask;

endclass
