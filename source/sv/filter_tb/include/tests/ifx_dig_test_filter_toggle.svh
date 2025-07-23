/******************************************************************************
 * (C) Copyright 2025 All Rights Reserved
 *
 * MODULE:
 * DEVICE:
 * PROJECT: SUMMER_SCHOOL_2025
 * AUTHOR:
 * DATE:
 * FILE:
 * REVISION:
 *
 * FILE DESCRIPTION:
 *
 *******************************************************************************/

class ifx_dig_test_filter_toggle extends ifx_dig_testbase;

    `uvm_component_utils(ifx_dig_test_filter_toggle)


    // Test variables
    int filter_list[$]; // contains the indexes of the filters to be tested
                        // lista se randomizeaza pentru testare aleatoare

    rand filt_type_t filter_type;
    rand filt_reset_t filter_reset;
    rand bit [3:0] window_size;

    function new(string name = "ifx_dig_test_filter_toggle", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        `TEST_INFO("Run phase started")
    endtask

    task main_phase(uvm_phase phase);
        phase.raise_objection(this);

        super.main_phase(phase); // call default main phase, contains reset

        `TEST_INFO("Main phase started")

        // create a random order of the filters to be tested
        for(int ifilt = 1; ifilt <= `FILT_NB; ifilt++) begin
            filter_list.push_back(ifilt);
        end
        filter_list.shuffle();

        repeat(5) begin
        // TODO: go through the filters and test them as described in requirement
       foreach(filter_list[idx]) begin

            `TEST_INFO($sformatf("Test filter %0d", filter_list[idx])) //vreau indexul filtrului, dar fiind randomizat nu coincide cu idx declarat de mine, deci nu folosesc idx ci lista[idx]
            configure_filter( //folosesc configure_filter din testbase
                .filt_idx(filter_list[idx]),
                .int_en(0) //avem valori random pentru toti bitii in afara de int_en care se cere sa fie 0
            );

            /* // Second option: configure the filter with random parameters
            this.randomize(); //this=pointer la obiectul curent, se randomizeaza variabilele declarate rand
            write_reg_fields(
                .reg_name($sformatf("FILTER_CTRL%0d", filter_list[idx])),
                .fields_names({"WD_RST", "WINDOW_SIZE", "FILTER_TYPE"}),
                .fields_values({filter_reset, window_size, filter_type})
            );

            */

            `TEST_INFO($sformatf("Driving a valid pulse on filter %0d", filter_list[idx]))
            pin_filter_valid_pulse_seq.start(dig_env.v_seqr.p_pin_filter_uvc_seqr[filter_list[idx] - 1]); // -1 pentru ca filtrul 1 e pe pozitia 0

            read_filter_status(0); //citim toate registrele de status pentru a ne asigura ca toate sunt ok
            `WAIT_NS(100)
        end
        end
        `TEST_INFO($sformatf("\ncg_filtering_type coverage is = %f\n", dig_env.scoreboard.cg_filtering_type.get_coverage()))
        phase.drop_objection(this);
    endtask

endclass
        
