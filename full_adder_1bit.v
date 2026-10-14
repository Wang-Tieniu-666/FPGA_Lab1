`timescale 1ns/1ps
module full_adder_1bit (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
    wire axb;
    assign axb = a ^ b;
    assign sum = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule
