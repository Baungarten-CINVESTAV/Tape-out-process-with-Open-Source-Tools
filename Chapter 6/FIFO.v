`define USE_POWER_PINS
module FIFO(
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
  input  clk0,
  input reset,
  input read_enable,
  input write_enable, 
  input [7:0]  in_FIFO,
  output [7:0] out_FIFO,
  output reg same_addr
);


  wire   csb0; // active low chip select -Input
  wire  web0; // active low write control -Input
  reg   [1:0] wmask0; // write mask -Input
  wire [9:0]  addr0; //Input
  
  reg [9:0] count_w, count_r;
  reg   csb1;
  
  wire [7:0] din0;
  wire [9:0] addr1;
  wire [7:0] dout0;
  wire [7:0] dout1;
  
  assign addr0 = count_w;
  assign web0 = 1'd0;
  assign csb0 = 1'd0;
  assign din0 = in_FIFO;
  
  assign addr1 = count_r;
  assign out_FIFO = dout1;
  

sky130_sram_1kbyte_1rw1r_8x1024_8 sky130_sram_1kbyte_1rw1r_8x1024_8(
`ifdef USE_POWER_PINS
    vccd1,
    vssd1,
`endif
// Port 0: RW
    clk0,csb0,web0,wmask0,addr0,din0,dout0,
// Port 1: R
    clk0,csb1,addr1,dout1
  );
  
    // Lógica de conteo
  always @(posedge clk0, posedge reset) 
  begin
    if (reset)
	 begin
      count_w <= 10'b000;
		count_r <= 10'b000;
	end
    else 
	 begin
	 
	  if (write_enable && (count_w!=10'd1023))
	  begin
       count_w <= count_w + 1'd1;
	  end
	  else if (write_enable && (count_w==10'd1023))
	  begin
		 count_w <= 10'd0;
	  end
	  else
	  begin
	    count_w <= count_w;
	  end

	
	  if ((read_enable) && (count_r==count_w))
	  begin
	    count_r <= count_r;
		 same_addr <= 1'd1;
	  end
     else if ((read_enable) && (count_r!=10'd1023))
	  begin
       count_r <= count_r + 1'd1;
		 same_addr <= 1'd0;
	  end
	  else if ((read_enable) && (count_r==10'd1023))
	  begin
	    count_r <= 10'd0;
		 same_addr <= 1'd0;
	  end
	  else
	  begin
		count_r <= count_r;
		same_addr <= 1'd0;
	  end
  end
 end


// State Machine FIFO function
always@(posedge clk0)
begin
	case({read_enable,write_enable})
		2'b00: //Initial state
		begin
			wmask0 = 1'd0;
			csb1 = 1'd1;
		end
		2'b01: //write state
		begin
			wmask0 = 1'd1;
			csb1 = 1'd1;
		end
		2'b10:
		begin
			wmask0 = 1'd0;
			csb1 = 1'd0;
		end
		2'b11:
		begin
			wmask0 = 1'd1;
			csb1 = 1'd0;
		end
	endcase
end
endmodule 
