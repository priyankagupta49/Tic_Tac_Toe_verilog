`timescale 1ns / 1ps

module tb_tic_tac_toe;

    // Testbench signals
    reg play, rst, clk;
    reg [3:0] comp_pos, player_pos;
    wire who;

    // Instantiate DUT
    tic_tac_toe uut (
        .play(play),
        .rst(rst),
        .clk(clk),
        .comp_pos(comp_pos),
        .player_pos(player_pos),
        .who1(who)   // Connect to who output
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        play = 0;
        rst = 0;
        comp_pos = 0;
        player_pos = 0;

        // Apply reset
        #5 rst = 1;
        #10 rst = 0;

        // Start the game
        #10 play = 1;
        #10 play = 0;

        // Simulate moves (Player / Computer)
        #10 player_pos = 5;
        #10 comp_pos   = 1;

        #10 player_pos = 7;
        #10 comp_pos   = 3;

        #10 player_pos = 2;
        #10 comp_pos   = 8;

        #10 player_pos = 9;
        #10 comp_pos   = 4;

        #10 player_pos = 6;

        // Finish simulation
        #20 $finish;
    end

endmodule
