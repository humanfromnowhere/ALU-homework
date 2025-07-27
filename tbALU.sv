module tbALU();
    logic [31:0] a, b, y;
    logic [2:0] f;
    logic z;

    // Instantiate the ALU
    ALU alu_inst (.a(a), .b(b), .f(f), .y(y), .z(z));

    initial begin
        // Test AND (f = 000)
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; f = 3'b000;
        #10; check_res(y, z, 32'hFFFFFFFF, 0);

        a = 32'hFFFFFFFF; b = 32'h12345678; f = 3'b000;
        #10; check_res(y, z, 32'h12345678, 0);

        a = 32'h12345678; b = 32'h87654321; f = 3'b000;
        #10; check_res(y, z, 32'h02244220, 0);

        a = 32'h00000000; b = 32'hFFFFFFFF; f = 3'b000;
        #10; check_res(y, z, 32'h00000000, 1);

        // Test OR (f = 001)
        a = 32'h00000000; b = 32'h00000000; f = 3'b001;
        #10; check_res(y, z, 32'h00000000, 1);

        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; f = 3'b001;
        #10; check_res(y, z, 32'hFFFFFFFF, 0);

        a = 32'h12345678; b = 32'h87654321; f = 3'b001;
        #10; check_res(y, z, 32'h97755779, 0);

        a = 32'hFFFFFFFF; b = 32'h00000000; f = 3'b001;
        #10; check_res(y, z, 32'hFFFFFFFF, 0);

        // Test ADD (f = 010)
        a = 32'h00000000; b = 32'h00000000; f = 3'b010;
        #10; check_res(y, z, 32'h00000000, 1);

        a = 32'h00000000; b = 32'hFFFFFFFF; f = 3'b010;
        #10; check_res(y, z, 32'hFFFFFFFF, 0);

        a = 32'h00000001; b = 32'hFFFFFFFF; f = 3'b010;
        #10; check_res(y, z, 32'h00000000, 1);

        a = 32'h000000FF; b = 32'h00000001; f = 3'b010;
        #10; check_res(y, z, 32'h00000100, 0);

        // Test AND with ~B (f = 100)
        a = 32'hFFFFFFFF; b = 32'h12345678; f = 3'b100;
        #10; check_res(y, z, ~32'h12345678 & 32'hFFFFFFFF, 0);

        a = 32'h12345678; b = 32'h87654321; f = 3'b100;
        #10; check_res(y, z, 32'h12345678 & ~32'h87654321, 0);

        // Test OR with ~B (f = 101)
        a = 32'h12345678; b = 32'h87654321; f = 3'b101;
        #10; check_res(y, z, 32'h12345678 | ~32'h87654321, 0);

        a = 32'hFFFFFFFF; b = 32'h12345678; f = 3'b101;
        #10; check_res(y, z, 32'hFFFFFFFF, 0);

        // Test SUB (f = 110)
        a = 32'h00000000; b = 32'h00000000; f = 3'b110;
        #10; check_res(y, z, 32'h00000000, 1);

        a = 32'h00000000; b = 32'hFFFFFFFF; f = 3'b110;
        #10; check_res(y, z, 32'h00000001, 0);

        a = 32'h00000001; b = 32'h00000001; f = 3'b110;
        #10; check_res(y, z, 32'h00000000, 1);

        a = 32'h00000100; b = 32'h00000001; f = 3'b110;
        #10; check_res(y, z, 32'h000000FF, 0);

        // Test SLT (f = 111)
        a = 32'h00000000; b = 32'h00000000; f = 3'b111;
        #10; check_res(y, z, 32'h00000000, 1);

        a = 32'h00000000; b = 32'h00000001; f = 3'b111;
        #10; check_res(y, z, 32'h00000001, 0);

        a = 32'h00000000; b = 32'hFFFFFFFF; f = 3'b111;
        #10; check_res(y, z, 32'h00000000, 1);

        a = 32'hFFFFFFFF; b = 32'h00000000; f = 3'b111;
        #10; check_res(y, z, 32'h00000001, 0);
        $finish;
    end

       task check_res(input logic [31:0] actual_y, actual_z, exp_y, exp_z);
        if (actual_y === exp_y && actual_z === exp_z) begin
          $display("Test Passed: a = %h, b = %h, f = %b, y = %h, z =%1b", a, b, f, actual_y, actual_z);
        end else begin
          $display("Test Failed: a = %h, b = %h, f = %b, y = %h, exp y = %h, z = %1b, exp z = %1b", 
                     a, b, f, actual_y, exp_y, actual_z, exp_z);
        end
    endtask
endmodule
