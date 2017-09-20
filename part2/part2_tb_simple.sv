// This is a very small testbench for you to check that you have the right
// idea for the input/output timing.

// This should not be your only test -- it's simply a basic way to make
// sure you have the right idea.

module simple_tb_part2_mac();

   logic clk, reset, valid_in, valid_out, overflow;
   logic signed [7:0] a, b;
   logic signed [15:0] f;

   part2_mac dut(clk, reset, a, b, valid_in, f, valid_out, overflow);

   initial clk = 0;
   always #5 clk = ~clk;

   initial begin

      // Before first clock edge, initialize
      reset = 1;
      {a, b} = {8'b0,8'b0};
      valid_in = 0;

      @(posedge clk);
      #1; // After 1 posedge
      reset = 0; a = 1; b = 1; valid_in = 0;
      @(posedge clk);
      #1; // After 2 posedges
      a = 2; b = 2; valid_in = 1;
      @(posedge clk);
      #1; // After 3 posedges
      a = 3; b = 3; valid_in = 1;
      @(posedge clk);
      #1; // After 4 posedges
      a = 4; b = 4; valid_in = 0;
      @(posedge clk);
      #1; // After 5 posedges
      a = 5; b = 5; valid_in = 0;
      @(posedge clk);
      #1; // After 6 posedges
      a = 6; b = 6; valid_in = 1;
   end // initial begin

   initial begin
      @(posedge clk);
      #1; // After 1 posedge
      $display("valid_out = %b. Expected value is 0.", valid_out);
      $display("f = %d. Expected value is 0.", f);
 
      @(posedge clk);
      #1; // After 2 posedges
      $display("valid_out = %b. Expected value is 0.", valid_out);
      $display("f = %d. Expected value is 0.", f);

      @(posedge clk);
      #1; // After 3 posedges
      $display("valid_out = %b. Expected value is 0.", valid_out);
      $display("f = %d. Expected value is 0.", f);

      @(posedge clk);
      #1; // After 4 posedges
      $display("valid_out = %b. Expected value is 1.", valid_out);
      $display("f = %d. Expected value is 4.", f);

      @(posedge clk);
      #1; // After 5 posedges
      $display("valid_out = %b. Expected value is 1.", valid_out);
      $display("f = %d. Expected value is 13.", f);

      @(posedge clk);
      #1; // After 6 posedges
      $display("valid_out = %b. Expected value is 0.", valid_out);
      $display("f = %d. Expected value is 13.", f);

      @(posedge clk);
      #1; // After 7 posedges
      $display("valid_out = %b. Expected value is 0.", valid_out);
      $display("f = %d. Expected value is 13.", f);

      @(posedge clk);
      #1; // After 8 posedges
      $display("valid_out = %b. Expected value is 1.", valid_out);
      $display("f = %d. Expected value is 49.", f);

      #20;
      $finish;
   end

endmodule // tb_part2_mac
