`timescale 1ns / 1ps

module tic_tac_toe(
    input play,
    input rst,
    input clk, 
    input [3:0] comp_pos,
    input [3:0] player_pos,
    output reg who1,          // 0 = Player wins, 1 = Computer wins
    output reg win,
    output reg no_space
);

    // FSM states
    localparam IDLE      = 2'b00,
               PLAYER    = 2'b01,
               COMPUTER  = 2'b10,
               GAME_OVER = 2'b11;

    integer i;
    reg [1:0] pos [0:8];           // board storage: 00=empty, 01=Player, 10=Computer
    reg [1:0] present_state, next_state;
    reg illegal_move_p, illegal_move_c;
    reg [3:0] cnt;                 // move counter

    // Illegal move detection
    always @(*) begin
        illegal_move_p = (pos[player_pos-1] == 2'b00) ? 1'b0 : 1'b1;
        illegal_move_c = (pos[comp_pos-1] == 2'b00) ? 1'b0 : 1'b1;
    end

    // Reset logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            present_state <= IDLE;
            cnt <= 4'b0000;
            no_space <= 1'b0;
            win <= 1'b0;
            who1 <= 1'b0;
            for (i=0; i<9; i=i+1)
                pos[i] <= 2'b00;
        end else begin
            present_state <= next_state;
        end
    end

    // FSM transitions
    always @(*) begin
        next_state = present_state;
        case (present_state)
            IDLE: begin
                if (play && ~rst)
                    next_state = PLAYER;
            end

            PLAYER: begin
                if (~illegal_move_p) begin
                    next_state = COMPUTER;
                end else if (no_space || win) begin
                    next_state = GAME_OVER;
                end else begin
                    next_state = present_state;
                end
            end

            COMPUTER: begin
                if (~illegal_move_c) begin
                    next_state = PLAYER;
                end else if (no_space || win) begin
                    next_state = GAME_OVER;
                end else begin
                    next_state = present_state;
                end
            end

            GAME_OVER: begin
                if (rst)
                    next_state = IDLE;
            end
        endcase
    end

    // Board update logic
    always @(posedge clk) begin
        if (present_state == PLAYER && ~illegal_move_p) begin
            pos[player_pos-1] <= 2'b01;
            cnt <= cnt + 1;
        end else if (present_state == COMPUTER && ~illegal_move_c) begin
            pos[comp_pos-1] <= 2'b10;
            cnt <= cnt + 1;
        end
    end

    // Check for draw
    always @(*) begin
        if (cnt == 9)
            no_space = 1'b1;
        else
            no_space = 1'b0;
    end

    // Win detection
    always @(*) begin
        win  = 1'b0;
        who1 = 1'b0;

        // Player win check (01)
        if ((pos[0]==2'b01 && pos[1]==2'b01 && pos[2]==2'b01) ||
            (pos[3]==2'b01 && pos[4]==2'b01 && pos[5]==2'b01) ||
            (pos[6]==2'b01 && pos[7]==2'b01 && pos[8]==2'b01) ||
            (pos[0]==2'b01 && pos[3]==2'b01 && pos[6]==2'b01) ||
            (pos[1]==2'b01 && pos[4]==2'b01 && pos[7]==2'b01) ||
            (pos[2]==2'b01 && pos[5]==2'b01 && pos[8]==2'b01) ||
            (pos[0]==2'b01 && pos[4]==2'b01 && pos[8]==2'b01) ||
            (pos[2]==2'b01 && pos[4]==2'b01 && pos[6]==2'b01)) begin
                win  = 1'b1;
                who1 = 1'b0;   // Player
        end

        // Computer win check (10)
        else if ((pos[0]==2'b10 && pos[1]==2'b10 && pos[2]==2'b10) ||
                 (pos[3]==2'b10 && pos[4]==2'b10 && pos[5]==2'b10) ||
                 (pos[6]==2'b10 && pos[7]==2'b10 && pos[8]==2'b10) ||
                 (pos[0]==2'b10 && pos[3]==2'b10 && pos[6]==2'b10) ||
                 (pos[1]==2'b10 && pos[4]==2'b10 && pos[7]==2'b10) ||
                 (pos[2]==2'b10 && pos[5]==2'b10 && pos[8]==2'b10) ||
                 (pos[0]==2'b10 && pos[4]==2'b10 && pos[8]==2'b10) ||
                 (pos[2]==2'b10 && pos[4]==2'b10 && pos[6]==2'b10)) begin
                win  = 1'b1;
                who1 = 1'b1;   // Computer
        end
    end

endmodule
