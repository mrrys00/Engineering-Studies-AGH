module mod_ring_counter (

	input wire reset, clock,
	
	output reg [11:0] mod_ring
	
);

always @(posedge reset or 
	posedge clock)
	
	if (reset == 1)	mod_ring <= 12'b111000000000 ;
		
	else mod_ring <= { mod_ring[0], mod_ring[11:1] };
		
endmodule





module Snake(

	input reset, clock,
	
	output reg [6:0] disp_1, output reg [6:0] disp_2
);

reg [11:0] b_snake_arr;
initial begin b_snake_arr <= 12'b111000000000; end
	
mod_ring_counter ring_counter_obj (
	
	.reset(reset), .clock(clock),
	
	.mod_ring(b_snake_arr)
);

always @(posedge clock)

	begin 
	
		disp_1 = { b_snake_arr[5], 1'b0, 1'b0, b_snake_arr[11], b_snake_arr[0], 
			b_snake_arr[6], ( b_snake_arr[7] || b_snake_arr[1] ) };
			
		disp_2 = { b_snake_arr[4], b_snake_arr[3], b_snake_arr[9], b_snake_arr[10], 
			1'b0, 1'b0, ( b_snake_arr[2] || b_snake_arr[8] ) };
	
	end

endmodule
