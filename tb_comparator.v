`timescale 1ns/1ps
module tb_comparator;
    reg a, b;
    reg button_a, button_b;
    wire lt, eq, gt;
    wire [2:0] led_pins_ll, led_pins_hh, led_pins_lh, led_pins_hl;
    integer i, failures, csv;
    reg [2:0] expected;
    comparator_1bit dut (.a(a), .b(b), .lt(lt), .eq(eq), .gt(gt));
    comparator_board board_ll (.button_a(button_a), .button_b(button_b), .led_pins(led_pins_ll));
    comparator_board #(.BUTTONS_ACTIVE_LOW(0), .LEDS_ACTIVE_LOW(0)) board_hh
        (.button_a(a), .button_b(b), .led_pins(led_pins_hh));
    comparator_board #(.BUTTONS_ACTIVE_LOW(1), .LEDS_ACTIVE_LOW(0)) board_lh
        (.button_a(button_a), .button_b(button_b), .led_pins(led_pins_lh));
    comparator_board #(.BUTTONS_ACTIVE_LOW(0), .LEDS_ACTIVE_LOW(1)) board_hl
        (.button_a(a), .button_b(b), .led_pins(led_pins_hl));
    initial begin
        $dumpfile("build/comparator.vcd");
        $dumpvars(0, tb_comparator);
        csv = $fopen("build/truth_table.csv", "w");
        if (!csv) $fatal(1, "Could not open CSV file");
        $fdisplay(csv, "time_ns,A,B,LT,EQ,GT,LED1_on,LED2_on,LED3_on,button_a_raw,button_b_raw,LED1_pin,LED2_pin,LED3_pin,status");
        failures = 0;
        for (i = 0; i < 4; i = i + 1) begin
            a = (i >> 1) & 1; b = i & 1;
            button_a = ~a; button_b = ~b;
            case (i)
                0: expected = 3'b010;
                1: expected = 3'b001;
                2: expected = 3'b100;
                3: expected = 3'b010;
            endcase
            #1;
            if ({gt,eq,lt} !== expected ||
                led_pins_ll !== ~expected || led_pins_hh !== expected ||
                led_pins_lh !== expected || led_pins_hl !== ~expected) begin
                failures = failures + 1;
                $display("FAIL A=%b B=%b actual=%b expected=%b", a,b,{gt,eq,lt},expected);
            end else
                $display("PASS A=%b B=%b LED1=%b LED2=%b LED3=%b", a,b,lt,eq,gt);
            $fdisplay(csv, "%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%s",
                $time,a,b,lt,eq,gt,lt,eq,gt,button_a,button_b,
                led_pins_ll[0],led_pins_ll[1],led_pins_ll[2],
                ({gt,eq,lt} === expected && led_pins_ll === ~expected &&
                led_pins_hh === expected && led_pins_lh === expected &&
                led_pins_hl === ~expected) ? "PASS" : "FAIL");
            #9;
        end
        $fclose(csv);
        if (failures != 0) $fatal(1, "COMPARATOR FAILED: %0d", failures);
        $display("ALL 4 INPUT COMBINATIONS AND 4 POLARITY CONFIGURATIONS PASSED");
        $finish;
    end
endmodule
