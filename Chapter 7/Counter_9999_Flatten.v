module Counter_9999 (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [15:0] load_value, // 4 BCD digits (each digit is 4 bits) -> 16 bits
    output reg [3:0] units,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands
);

    reg [3:0] next_units, next_tens, next_hundreds, next_thousands;

    // Sequential Logic - Registers
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            units <= 4'b0000;
            tens <= 4'b0000;
            hundreds <= 4'b0000;
            thousands <= 4'b0000;
        end
        else if (load)
        begin
            units <= load_value[3:0];
            tens <= load_value[7:4];
            hundreds <= load_value[11:8];
            thousands <= load_value[15:12];
        end
        else 
        begin
            units <= next_units;
            tens <= next_tens;
            hundreds <= next_hundreds;
            thousands <= next_thousands;
        end
    end

    // Combinational Logic
    always @(*)
    begin
        // Default to incrementing the current value
        next_units = units + 4'b0001;
        next_tens = tens;
        next_hundreds = hundreds;
        next_thousands = thousands;

        if (units == 4'b1001)
        begin
            next_units = 4'b0000;
            next_tens = tens + 4'b0001;

            if (tens == 4'b1001)
            begin
                next_tens = 4'b0000;
                next_hundreds = hundreds + 4'b0001;

                if (hundreds == 4'b1001)
                begin
                    next_hundreds = 4'b0000;
                    next_thousands = thousands + 4'b0001;

                    if (thousands == 4'b1001)
                    begin
                        next_thousands = 4'b0000;
                    end
                end
            end
        end
    end
endmodule
