`timescale 1ns/1ps
// One-bit unsigned comparator: exactly one relation is true.
module comparator_1bit (
    input wire a,
    input wire b,
    output wire lt,
    output wire eq,
    output wire gt
);
    assign lt = ~a & b;
    assign eq = ~(a ^ b);
    assign gt = a & ~b;
endmodule
