//-----------------------------------------------------//
// MAC (Multiply & Accumulate Unit)
//-----------------------------------------------------//

module part2_mac (
    input  logic                clk, 
    input  logic                reset,
    input  logic signed [ 7:0]  a, 
    input  logic signed [ 7:0]  b,  
    input  logic                valid_in,
    output logic signed [15:0]  f, 
    output logic                valid_out,
    output logic                overflow
);
    logic signed [ 7:0] a_int;
    logic signed [ 7:0] b_int;
    logic signed [15:0] c_int;
    logic signed [15:0] d_int;
    logic overflow_int;
    logic enable_f;

    assign c_int = (a_int * b_int);
    assign d_int = f + c_int;
    //assign overflow_int = (f > 0 && c_int > 0 && d_int < 0) ||
    //                      (f < 0 && c_int < 0 && d_int > 0);
    //Simple overflow detection logic
    assign overflow_int = ( f[15] &  c_int[15] & !d_int[15]) |
                          (!f[15] & !c_int[15] &  d_int[15]);

    //--------------------------------------------------//
    // Flopping the a, b and valid_in input.
    //--------------------------------------------------//
    always_ff @(posedge clk)
        if (reset) begin
            a_int    <= 8'd0;
            b_int    <= 8'd0;
            enable_f <= 1'b0;
        end
        else if (valid_in) begin
            a_int    <= a;
            b_int    <= b;
            enable_f <= valid_in;
        end
        else begin
            enable_f <= 1'b0;
        end

    //--------------------------------------------------//
    // Doing MAC operation.
    //--------------------------------------------------//
    always_ff @(posedge clk)
        if (reset) begin
            f         <= 16'd0;
            valid_out <= 1'b0; 
        end
        else if (enable_f) begin
            f         <= d_int;
            valid_out <= 1'b1;
        end
        else begin
            valid_out <= 1'b0;
        end

    //--------------------------------------------------//
    // Overflow detection.
    //--------------------------------------------------//
    always_ff @(posedge clk)
        if (reset)
            overflow <= 1'b0; 
        else if (overflow_int && enable_f)
            overflow <= 1'b1;

endmodule
//end of file.
