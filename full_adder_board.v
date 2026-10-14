`timescale 1ns/1ps
module full_adder_board #(
    parameter BUTTONS_ACTIVE_LOW = 1,
    parameter LEDS_ACTIVE_LOW = 1
) (
    input wire button_a,
    input wire button_b,
    input wire button_cin,
    output wire [1:0] led_pins
);
    wire a = BUTTONS_ACTIVE_LOW ? ~button_a : button_a;
    wire b = BUTTONS_ACTIVE_LOW ? ~button_b : button_b;
    wire cin = BUTTONS_ACTIVE_LOW ? ~button_cin : button_cin;
    wire sum, cout;
    wire [1:0] led_on = {cout, sum};
    full_adder_1bit u_adder (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
    // LED1 = sum; LED2 = carry-out. Confirm actual board polarity.
    assign led_pins = LEDS_ACTIVE_LOW ? ~led_on : led_on;
endmodule
