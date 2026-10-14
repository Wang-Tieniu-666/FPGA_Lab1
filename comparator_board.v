`timescale 1ns/1ps
// Confirm these polarity parameters against the actual board schematic.
module comparator_board #(
    parameter BUTTONS_ACTIVE_LOW = 1,
    parameter LEDS_ACTIVE_LOW = 1
) (
    input wire button_a,
    input wire button_b,
    output wire [2:0] led_pins
);
    wire a = BUTTONS_ACTIVE_LOW ? ~button_a : button_a;
    wire b = BUTTONS_ACTIVE_LOW ? ~button_b : button_b;
    wire lt, eq, gt;
    wire [2:0] led_on = {gt, eq, lt};
    comparator_1bit u_cmp (.a(a), .b(b), .lt(lt), .eq(eq), .gt(gt));
    // Bit 0 = LED1 (A<B); bit 1 = LED2 (A=B); bit 2 = LED3 (A>B).
    assign led_pins = LEDS_ACTIVE_LOW ? ~led_on : led_on;
endmodule
