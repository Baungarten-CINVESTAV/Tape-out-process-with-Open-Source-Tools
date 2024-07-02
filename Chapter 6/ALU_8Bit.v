module ALU_8Bit(input [7:0] a, input [7:0]b, input [1:0] opcode, output reg [7:0] o_ALU,`ifdef USE_POWER_PINS inout VPWR, inout VGND `endif);
    // 8-bit ALU module
     
     wire [7:0] o_Adder8Bit;
     wire [7:0] o_Subtractor8Bit;
     wire [7:0] o_LeftShifter8Bit;
     wire [7:0] o_RightShifter8Bit;

     Adder8Bit Adder8Bit(a, b, o_Adder8Bit,`ifdef USE_POWER_PINS VPWR, VGND `endif); // Addition operation
     Subtractor8Bit Subtractor8Bit(a, b, o_Subtractor8Bit,`ifdef USE_POWER_PINS VPWR, VGND `endif); // Subtraction operation
     LeftShifter8Bit LeftShifter8Bit(a, b[2:0], o_LeftShifter8Bit,`ifdef USE_POWER_PINS VPWR, VGND `endif); // Left shift operation
     RightShifter8Bit RightShifter8Bit(a, b[2:0], o_RightShifter8Bit,`ifdef USE_POWER_PINS VPWR, VGND `endif); // Right shift operation
     
    always@*
    begin
        case (opcode)
            2'b00: o_ALU = o_Adder8Bit; // Addition operation
            2'b01: o_ALU = o_Subtractor8Bit; // Subtraction operation
            2'b10: o_ALU = o_LeftShifter8Bit; // Left shift operation
            2'b11: o_ALU = o_RightShifter8Bit; // Right shift operation
            default: o_ALU = 0;
        endcase
    end
endmodule 
