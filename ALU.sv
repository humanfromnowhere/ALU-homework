module full_adder (
    input logic in1, in2, cin,
    output logic sum, cout
);
    assign sum = in1 ^ in2 ^ cin;
    assign cout = (in1 & in2) | (cin & (in1 ^ in2));
endmodule

module BA_32bit (
    input logic [31:0] a, b,
    input logic cin,
    output logic [31:0] sum,
    output logic cout
);
    logic [32:0] c;
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            full_adder fa (
              .in1(a[i]),
                .in2(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout(c[i+1])  
            );
        end
    endgenerate

    assign cout = c[32];
endmodule

module mux_2x1 (
    input [31:0] a,
    input [31:0] b,
    input s,
    output [31:0] out
);
    assign out = s ? b : a;
endmodule

module mux_4x1 (
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input [1:0] s,
    output reg [31:0] out
);
    always @(*) begin
        case (s)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
            default: out = 32'b0;
        endcase
    end
endmodule
module ALU (
    input logic [31:0] a, b,
    input logic [2:0] f,
    output logic [31:0] y,
    output logic z
);
    logic [31:0] b_mux, add_res, and_res, or_res, slt_res;
    logic cout;
    mux_2x1 b_select (
        .a(b),
        .b(~b),
        .s(f[2]),
        .out(b_mux)
    );

    BA_32bit adder_inst (
        .a(a),
        .b(b_mux),
        .cin(f[2]),     
        .sum(add_res),
        .cout(cout)
    );

    assign and_res = a & b_mux; 
    assign or_res = a | b_mux; 
    assign slt_res = {31'b0, add_res[31]}; 
  
    mux_4x1 res_mux (
        .a(and_res),     
        .b(or_res),      
        .c(add_res),     
        .d(slt_res),     
        .s(f[1:0]),
        .out(y)
    );
    assign z = (y == 32'b0);
endmodule