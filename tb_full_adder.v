`timescale 1ns/1ps
module tb_full_adder;
    reg a, b, cin;
    reg button_a, button_b, button_cin;
    wire sum, cout;
    wire [1:0] led_pins_ll, led_pins_hh, led_pins_lh, led_pins_hl;
    reg [1:0] expected;
    integer i, failures, csv;
    full_adder_1bit dut (.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    full_adder_board board_ll (.button_a(button_a),.button_b(button_b),.button_cin(button_cin),.led_pins(led_pins_ll));
    full_adder_board #(.BUTTONS_ACTIVE_LOW(0),.LEDS_ACTIVE_LOW(0)) board_hh
        (.button_a(a),.button_b(b),.button_cin(cin),.led_pins(led_pins_hh));
    full_adder_board #(.BUTTONS_ACTIVE_LOW(1),.LEDS_ACTIVE_LOW(0)) board_lh
        (.button_a(button_a),.button_b(button_b),.button_cin(button_cin),.led_pins(led_pins_lh));
    full_adder_board #(.BUTTONS_ACTIVE_LOW(0),.LEDS_ACTIVE_LOW(1)) board_hl
        (.button_a(a),.button_b(b),.button_cin(cin),.led_pins(led_pins_hl));
    initial begin
        $dumpfile("build/full_adder.vcd"); $dumpvars(0,tb_full_adder);
        csv = $fopen("build/truth_table.csv","w");
        if (!csv) $fatal(1,"Could not open CSV");
        $fdisplay(csv,"time_ns,A,B,Cin,Sum,Cout,LED1_on,LED2_on,button_a_raw,button_b_raw,button_cin_raw,LED1_pin,LED2_pin,status");
        failures = 0;
        for (i=0;i<8;i=i+1) begin
            a=(i>>2)&1; b=(i>>1)&1; cin=i&1;
            button_a=~a; button_b=~b; button_cin=~cin;
            // Arithmetic oracle is independent of the gate equations under test.
            expected={1'b0,a}+{1'b0,b}+{1'b0,cin};
            #1;
            if ({cout,sum} !== expected || led_pins_ll !== ~expected ||
                led_pins_hh !== expected || led_pins_lh !== expected || led_pins_hl !== ~expected) begin
                failures=failures+1;
                $display("FAIL A=%b B=%b Cin=%b expected=%b actual=%b",a,b,cin,expected,{cout,sum});
            end else $display("PASS A=%b B=%b Cin=%b Sum=%b Cout=%b",a,b,cin,sum,cout);
            $fdisplay(csv,"%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%s",
                $time,a,b,cin,sum,cout,sum,cout,button_a,button_b,button_cin,
                led_pins_ll[0],led_pins_ll[1],
                ({cout,sum}===expected && led_pins_ll===~expected && led_pins_hh===expected &&
                 led_pins_lh===expected && led_pins_hl===~expected)?"PASS":"FAIL");
            #9;
        end
        $fclose(csv);
        if (failures) $fatal(1,"FULL ADDER FAILED: %0d",failures);
        $display("ALL 8 INPUT COMBINATIONS AND 4 POLARITY CONFIGURATIONS PASSED");
        $finish;
    end
endmodule
