//-----------------------------------------------------//
// MAC (Multiply & Accumulate Unit)
//-----------------------------------------------------//

module part3_mac (
    input  logic                clk, 
    input  logic                reset,
    input  logic signed [ 7:0]  a, 
    input  logic signed [ 7:0]  b,  
    input  logic                valid_in,
    output logic signed [15:0]  f, 
    output logic                valid_out,
    output logic                overflow
);

    localparam NUM_S = 6;

    logic signed [ 7:0] a_int;
    logic signed [ 7:0] b_int;
    logic signed [15:0] c_int;
    logic signed [15:0] d_int;
    logic signed [15:0] e_int;
    logic overflow_int;
    logic enable_d;
    logic enable_f;
    logic [NUM_S-1:0] enable_m;

    assign e_int = f + d_int;

    //Simple overflow detection logic
    assign overflow_int = ( f[15] &  d_int[15] & !e_int[15]) |
                          (!f[15] & !d_int[15] &  e_int[15]);

    generate
        if (NUM_S == 1) begin
            assign c_int = (a_int * b_int);
            assign enable_m[0] = enable_d;
        end
        else begin 
            if (NUM_S == 2) begin
                DW02_mult_2_stage #(8, 8) multinstance(a_int, b_int, 1'b1, clk, c_int);
            end
            else if(NUM_S == 3) begin
                DW02_mult_3_stage #(8, 8) multinstance(a_int, b_int, 1'b1, clk, c_int);
            end
            else if(NUM_S == 4) begin
                DW02_mult_4_stage #(8, 8) multinstance(a_int, b_int, 1'b1, clk, c_int);
            end
            else if(NUM_S == 5) begin
                DW02_mult_5_stage #(8, 8) multinstance(a_int, b_int, 1'b1, clk, c_int);
            end
            else if(NUM_S == 6) begin
                DW02_mult_6_stage #(8, 8) multinstance(a_int, b_int, 1'b1, clk, c_int);
            end

            always_ff @(posedge clk)
                if (reset) begin
                    enable_m <= 'd0;
                end
                else begin
                    enable_m[NUM_S-2] <= enable_d;
                    for(int i = 0; i < NUM_S-2; i++)
                        enable_m[i] <= enable_m[i+1];
                end
        end
    endgenerate

    //--------------------------------------------------//
    // Flopping the a, b and valid_in input.
    //--------------------------------------------------//
    always_ff @(posedge clk)
        if (reset) begin
            a_int    <= 8'd0;
            b_int    <= 8'd0;
            enable_d <= 1'b0;
        end
        else if (valid_in) begin
            a_int    <= a;
            b_int    <= b;
            enable_d <= 1'b1;
        end
        else begin
            enable_d <= 1'b0;
        end


    //--------------------------------------------------//
    // Pipeline reg between multiplier and adder.
    //--------------------------------------------------//
    always_ff @(posedge clk)
        if (reset) begin
            d_int    <= 16'd0;
            enable_f <= 1'b0;
        end
        else if (enable_m[0]) begin
            d_int    <= c_int; 
            enable_f <= 1'b1;
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
            f         <= f + d_int;
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
