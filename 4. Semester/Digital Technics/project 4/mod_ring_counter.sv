module mod_ring_counter (

	input wire reset,
	input wire clock,
	output reg [11:0] mod_ring
	
);

always @(posedge clock or 
	posedge reset)
	
	if (reset == 1)
		mod_ring <= 12'b111000000000 ;
		
	else
		mod_ring <= { mod_ring[0], mod_ring[11:1] };
		
endmodule
