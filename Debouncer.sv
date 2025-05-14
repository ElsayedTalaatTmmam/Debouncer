module debouncer(
input wire i_clk, // 50 MHz clock input
input wire i_rst, // Active-high reset
input wire i_button, // Noisy button input

output reg o_synchronized_button // Debounced button output
);

reg [19:0] counter_r; // 20-bit counter_r to handle 500,000 cycles
reg button_sync1_r, button_sync2_r; // For synchronizing button input to clock
reg button_state_r; // Holds the stable state of the button

// Synchronize the button input to the clock domain
always @(posedge i_clk or posedge i_rst) begin
 if (i_rst) begin
	button_sync1_r <= 1'b0;
	button_sync2_r <= 1'b0;
 end else begin
	button_sync1_r <= i_button;
	button_sync2_r <= button_sync1_r;
		end
 end
 
// Debouncing logic
always @(posedge i_clk or posedge i_rst) begin
 if (i_rst) begin
	counter_r <= 20'b0;
	button_state_r <= 1'b0;
	o_synchronized_button <= 1'b0;
 end else begin
		if (button_sync2_r != button_state_r) begin
// Button state changed, start counting
			counter_r <= counter_r + 1'b1;
		if (counter_r == 500_000) begin
// 10 ms has passed, change the button state

			button_state_r <= button_sync2_r;
			o_synchronized_button <= button_sync2_r;
			counter_r <= 20'b0;
		end
	end else begin
// No state change, reset the counter_r
	counter_r <= 20'b0;
			end
		end
end
endmodule