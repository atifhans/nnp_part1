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
    logic signed [15:0] f_int;
    logic valid_int;

    //--------------------------------------------------//
    // Flopping the a, b and valid_in input.
    //--------------------------------------------------//
    always_ff @(posedge clk)
        if (reset) begin
            a_int <= 8'd0;
            b_int <= 8'd0;
            valid_int <= 1'b0;
        end
        else begin
            a_int <= a;
            b_int <= b;
            valid_int <= valid_in;
        end

    //--------------------------------------------------//
    // Doing MAC operation.
    //--------------------------------------------------//
    always_ff @(posedge clk)
        if (reset) begin
            f <= 16'd0;
            valid_out <= 1'b0; 
        end
        else if (valid_int) begin
            f <= f + (a_int * b_int);
            valid_out <= 1'b1;
        end
        else begin
            valid_out <= 1'b0;
        end

    //--------------------------------------------------//
    // Overflow detection.
    //--------------------------------------------------//
    assign overflow = (a > 0 && b > 0 && f < 0) ||
                      (a < 0 && b < 0 && f > 0);

endmodule
//end of file.
