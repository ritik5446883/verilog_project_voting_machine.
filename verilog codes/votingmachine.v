//////////////////////////////////////////////////////////////////////////////
// NAME       : RITIK CHOUDHARY
// ROLL NO.   : 122EE0355                            
// YEAR       : THIRD YEAR                
// DEPARTMENT : ELECTRICAL ENGINEERING
// PROJECT    : VOTING MACHINE
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

// Button control module
module buttoncontrol(
    input clock,
    input reset,
    input button,
    output reg valid_vote
);
    reg [30:0] counter;

    always @(posedge clock) begin
        if (reset)
            counter <= 0;
        else begin
            if (button & counter < 11)
                counter <= counter + 1;
            else if (!button)
                counter <= 0;
        end
    end

    always @(posedge clock) begin
        if (reset)
            valid_vote <= 1'b0;
        else begin
            if (counter == 10)
                valid_vote <= 1'b1;
            else
                valid_vote <= 1'b0;
        end
    end
endmodule

// Mode control module
module modecontrol(
    input clock,
    input reset,
    input mode,
    input valid_vote_casted,
    input [7:0] candidate_1_vote,
    input [7:0] candidate_2_vote,
    input [7:0] candidate_3_vote,
    input [7:0] candidate_4_vote,
    input candidate1_button_press,
    input candidate2_button_press,
    input candidate3_button_press,
    input candidate4_button_press,
    output reg [7:0] leds
);
    reg [30:0] counter;

    always @(posedge clock) begin
        if (reset)
            counter <= 0;
        else if (valid_vote_casted)
            counter <= counter + 1;
        else if (counter != 0 & counter < 10)
            counter <= counter + 1;
        else
            counter <= 0;
    end

    always @(posedge clock) begin
        if (reset)
            leds <= 0;
        else begin
            if (mode == 0 & counter > 0)
                leds <= 8'hFF;
            else if (mode == 0)
                leds <= 8'h00;
            else if (mode == 1) begin
                if (candidate1_button_press)
                    leds <= candidate_1_vote;
                else if (candidate2_button_press)
                    leds <= candidate_2_vote;
                else if (candidate3_button_press)
                    leds <= candidate_3_vote;
                else if (candidate4_button_press)
                    leds <= candidate_4_vote;
            end
        end
    end
endmodule

// Vote logger module
module voteLogger(
    input clock,
    input reset,
    input mode,
    input cand1_vote_valid,
    input cand2_vote_valid,
    input cand3_vote_valid,
    input cand4_vote_valid,
    output reg [7:0] cand1_vote_recvd,
    output reg [7:0] cand2_vote_recvd,
    output reg [7:0] cand3_vote_recvd,
    output reg [7:0] cand4_vote_recvd
);
    always @(posedge clock) begin
        if (reset) begin
            cand1_vote_recvd <= 0;
            cand2_vote_recvd <= 0;
            cand3_vote_recvd <= 0;
            cand4_vote_recvd <= 0;
        end else begin
            if (cand1_vote_valid & mode == 0)
                cand1_vote_recvd <= cand1_vote_recvd + 1;
            if (cand2_vote_valid & mode == 0)
                cand2_vote_recvd <= cand2_vote_recvd + 1;
            if (cand3_vote_valid & mode == 0)
                cand3_vote_recvd <= cand3_vote_recvd + 1;
            if (cand4_vote_valid & mode == 0)
                cand4_vote_recvd <= cand4_vote_recvd + 1;
        end
    end
endmodule

// Main voting machine module
module votingmachine(
    input clock,
    input reset,
    input mode,
    input button1,
    input button2,
    input button3,
    input button4,
    output [7:0] led
);
    wire valid_vote_1;
    wire valid_vote_2;
    wire valid_vote_3;
    wire valid_vote_4;
    wire [7:0] cand1_vote_recvd;
    wire [7:0] cand2_vote_recvd;
    wire [7:0] cand3_vote_recvd;
    wire [7:0] cand4_vote_recvd;
    wire anyvalidvote;

    assign anyvalidvote = valid_vote_1 | valid_vote_2 | valid_vote_3 | valid_vote_4;

    buttoncontrol bc1(
        .clock(clock),
        .reset(reset),
        .button(button1),
        .valid_vote(valid_vote_1)
    );

    buttoncontrol bc2(
        .clock(clock),
        .reset(reset),
        .button(button2),
        .valid_vote(valid_vote_2)
    );

    buttoncontrol bc3(
        .clock(clock),
        .reset(reset),
        .button(button3),
        .valid_vote(valid_vote_3)
    );

    buttoncontrol bc4(
        .clock(clock),
        .reset(reset),
        .button(button4),
        .valid_vote(valid_vote_4)
    );

    voteLogger VL(
        .clock(clock),
        .reset(reset),
        .mode(mode),
        .cand1_vote_valid(valid_vote_1),
        .cand2_vote_valid(valid_vote_2),
        .cand3_vote_valid(valid_vote_3),
        .cand4_vote_valid(valid_vote_4),
        .cand1_vote_recvd(cand1_vote_recvd),
        .cand2_vote_recvd(cand2_vote_recvd),
        .cand3_vote_recvd(cand3_vote_recvd),
        .cand4_vote_recvd(cand4_vote_recvd)
    );

    modecontrol MC(
        .clock(clock),
        .reset(reset),
        .mode(mode),
        .valid_vote_casted(anyvalidvote),
        .candidate_1_vote(cand1_vote_recvd),
        .candidate_2_vote(cand2_vote_recvd),
        .candidate_3_vote(cand3_vote_recvd),
        .candidate_4_vote(cand4_vote_recvd),
        .candidate1_button_press(valid_vote_1),
        .candidate2_button_press(valid_vote_2),
        .candidate3_button_press(valid_vote_3),
        .candidate4_button_press(valid_vote_4),
        .leds(led)
    );
endmodule
