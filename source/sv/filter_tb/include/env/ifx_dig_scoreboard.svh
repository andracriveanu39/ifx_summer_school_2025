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

class ifx_dig_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(ifx_dig_scoreboard)

    //=========================================================================
    // Pointers.
    //-------------------------------------------------------------------------
    //=========================================================================
    ifx_dig_env p_env;                 //-- pointer to the ENV
    ifx_dig_config p_env_cfg;          // pointer to the ENV config
    virtual ifx_dig_interface dig_vif; // pointer to the virtual interface

    //=========================================================================
    // Components.
    //-------------------------------------------------------------------------
    //=========================================================================

    ifx_dig_regblock regblock;

    //=========================================================================
    // Golden interface.
    //-------------------------------------------------------------------------
    //=========================================================================


    //=========================================================================
    // TLM imports
    //-------------------------------------------------------------------------
    //=========================================================================

    `uvm_analysis_imp_decl(_data_bus_uvc)                                                                // macro apeleaza fortat functia write"_data_bus_uvc" ca sa determine cosnumul imediat al itemului
    uvm_analysis_imp_data_bus_uvc #(ifx_dig_data_bus_uvc_seq_item, ifx_dig_scoreboard) data_bus_uvc_imp; // data bus UVC monitor connects here, e de consum imediat al itemului

    uvm_tlm_analysis_fifo #(ifx_dig_pin_filter_uvc_seq_item) pin_filter_uvcs_imp_fifo; // all exports from UVC filters are connected here, toate itemele care vin de la filtre se duc aici

    //=========================================================================
    // Signals, variables, methods PER FEATURE.
    //-------------------------------------------------------------------------
    //=========================================================================

    event reg_write_e;
    event reg_read_e;
    event regblock_reset_e; // sets when regblock is reset and GM or other components must update

    bit [`AWIDTH-1:0] latest_address; //last read or write address
    bit [`DWIDTH-1:0] latest_data; //am nevoie pt checker
    //=========================================================================
    // COVERAGE.
    //-------------------------------------------------------------------------
    //=========================================================================

    //=========================================================================
    // UVM PHASING.
    //-------------------------------------------------------------------------
    //=========================================================================

    extern function new(string name = "ifx_dig_scoreboard", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

//=========================================================================
// ENVIRONMENT SYNC and OTHER TASKS.
//-------------------------------------------------------------------------
//=========================================================================

`include "ifx_dig_golden_model.svh"
`include "ifx_dig_checkers.svh"
`include "ifx_dig_coverage.svh"

    /*
     * write function for the data bus UVC items - process items from the UVC
     */
    function void write_data_bus_uvc(input ifx_dig_data_bus_uvc_seq_item packet);
        begin
            `uvm_info("WRITE_DATA_BUS_UVC", $sformatf("Received packet from DATA_BUS_UVC monitor. \n Packet = %p\n", packet), UVM_LOW)
            // HINT --  pass here value for data_i global variable
            if(packet.access_type == WRITE) begin
                ifx_dig_reg reg_obj = regblock.get_reg_by_address(packet.address);
                if(reg_obj != null)
                    reg_obj.write_reg_value(packet.data);
                    latest_address=packet.address;
                    latest_data=packet.data; //le obtin inainte de eveniment ca in checker, la eveniment sa am datele
                ->reg_write_e; //se emite un eveniment, un puls, un trigger care apare in momentul ala de timp
            end else if(packet.access_type == READ) begin
                // check if the returned data by the DUT is matching the expected data
                check_read_data(packet.address, packet.data); //se face checkerul dupa read
                ->reg_read_e;
            end
        end
    endfunction: write_data_bus_uvc


endclass : ifx_dig_scoreboard


//=========================================================================
// Method implementation.
//-------------------------------------------------------------------------
//=========================================================================

function ifx_dig_scoreboard::new(string name = "ifx_dig_scoreboard", uvm_component parent);
    super.new(name, parent);

//=========================================================================
//  COVERAGE INITIALIZATION.
//-------------------------------------------------------------------------
//=========================================================================
    this.cg_filter_ctrl        = new();
    this.cg_int_status_read    = new(); //odata creat, covergroup trebuie instantiat
//=========================================================================
//  TLM IMPORT INITIALIZATION.
//-------------------------------------------------------------------------
//=========================================================================

    data_bus_uvc_imp         = new("data_bus_uvc_imp", this);
    pin_filter_uvcs_imp_fifo = new("pin_filter_uvcs_imp_fifo", this);

endfunction : new


function void ifx_dig_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);

    regblock = ifx_dig_regblock::type_id::create("regblock");
    regblock.build();

    //TODO: Get dig_vif pointer from uvm_config_db
    if (!uvm_config_db#(virtual ifx_dig_interface)::get(this, "", "dig_if", dig_vif))
        `uvm_fatal("TEST_BASE/NOVIF", "No virtual interface specified for SCOREBOARD") //fault handling
    uvm_config_db #(virtual ifx_dig_interface)::get(uvm_top, "*", "dig_if", dig_vif); //i am dat set in dig_top unde era creata acea interfaata, ii dam get in scoreboard pentru a o transmite mai departe
    //virtual inseamna ca e doar un pointer catre interfata respectiva, nu interfata
endfunction : build_phase

function void ifx_dig_scoreboard::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

endfunction : connect_phase

function void ifx_dig_scoreboard:: end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

endfunction : end_of_elaboration_phase

task ifx_dig_scoreboard::run_phase(uvm_phase phase);
    // TODO: Write code allowing for parallel execution of
    // collect_coverage(), golden_model(), do_checkers()

    fork
        collect_coverage();
        golden_model();
        do_checkers(); //vreau ca toate cele 3 taskuri sa se execute in paralel si sa se termine in acelasi timp
    join

endtask : run_phase

//=========================================================================
// Include EXTERNAL method implementation files.
//-------------------------------------------------------------------------
//=========================================================================
