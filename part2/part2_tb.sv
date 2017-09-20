//TODO:
class mac_model;
    rand bit signed [ 7:0] a;
    rand bit signed [ 7:0] b;
    rand bit        valid;
    static int      idx = 0;
    bit signed     [ 7:0] x[*];
    bit signed     [ 7:0] y[*];
    bit signed     [15:0] f[*];
    
    constraint a_con {a >= 8'h00; a <= 8'h2f;}
    constraint b_con {a >= 8'h00; a <= 8'h2f;}
    constraint valid_con {valid dist{0:/1, 1:/1};}

    function void post_randomize();
    begin
        if (valid == 1) begin
            x[idx] = a;
            y[idx] = b;
            f[idx] = (idx == 0) ? (a * b) : (f[idx-1] + (a * b));
            idx++;
        end
    end
    endfunction
endclass

module tb_part2_mac();

   logic clk, reset, valid_in, valid_out, overflow;
   logic signed [7:0] a, b;
   logic signed [15:0] f;
   int idx = 0;

   part2_mac dut(clk, reset, a, b, valid_in, f, valid_out, overflow);

   initial clk = 0;
   always #5 clk = ~clk;

   mac_model mac_m = new();

   initial begin

      // Before first clock edge, initialize
      reset = 1;
      {a, b} = {8'b0,8'b0};
      valid_in = 0;

      @(posedge clk);
      #1; // After 1 posedge
      reset = 0; a = 1; b = 1; valid_in = 0;

      for (int i = 0; i < 30; i++) begin
          @(posedge clk);
          #1;
          mac_m.randomize();
          a = mac_m.a;
          b = mac_m.b;
          valid_in = mac_m.valid;
      end

      @(posedge clk);
      #1;
      valid_in = 1'b0;

      #100 $finish();

   end // initial begin

   always @(posedge clk) begin
       if(valid_out) begin
           if(f == mac_m.f[idx])
               $display("Validation PASSED - a: %d, b: %d, f: %d, f_exp: %d", mac_m.x[idx], mac_m.y[idx], f, mac_m.f[idx]);
           else begin
               $display("Validation FAILED - a: %d, b: %d, f: %d, f_exp: %d", mac_m.x[idx], mac_m.y[idx], f, mac_m.f[idx]);
               $finsih();
           end
           idx++;
       end
   end

endmodule // tb_part2_mac
