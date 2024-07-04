//////////////////////////////////////////////////////////////////////////////
// NAME       : RITIK CHOUDHARY
// ROLL NO.   : 122EE0355                            
// YEAR       : THIRD YEAR                
// DEPARTMENT : ELECTRICAL ENGINEERING
// PROJECT    : VOTING MACHINE
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module votingmachine_tb;

    // Inputs
    reg clock;
    reg reset;
    reg mode;
    reg button1;
    reg button2;
    reg button3;
    reg button4;

    // Outputs
    wire [7:0] led;

    // Instantiate the Unit Under Test (UUT)
    votingmachine dut (
        .clock(clock),
        .reset(reset),
        .mode(mode),
        .button1(button1),
        .button2(button2),
        .button3(button3),
        .button4(button4),
        .led(led)
    );

    // Clock generation
    always #5 clock = ~clock;

    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 1;
        mode = 0;
        button1 = 0;
        button2 = 0;
        button3 = 0;
        button4 = 0;

        // Wait for global reset
        #100;
        reset = 0;

        // Test voting mode
        // Simulate button presses for candidate 1
        #50 button1 = 1;
        #100 button1 = 0;
        #50 button1 = 1;
        #100 button1 = 0;

        // Simulate button presses for candidate 2
        #50 button2 = 1;
        #100 button2 = 0;
        #50 button2 = 1;
        #100 button2 = 0;

        // Simulate button presses for candidate 3
        #50 button3 = 1;
        #100 button3 = 0;
        #50 button3 = 1;
        #100 button3 = 0;

        // Simulate button presses for candidate 4
        #50 button4 = 1;
        #100 button4 = 0;
        #50 button4 = 1;
        #100 button4 = 0;
        
        //reset the system
        #100 reset = 1;
        #50  reset = 0;

#500
        $finish;

end
 initial 
begin 
$dumpvars;
$dumpfile("dump.vcd");
end
initial
$monitor($time,"mode=%b,button1=%b,button2=%b,button3=%b,button4=%b ,led=%d",mode,button1,button2,button3,button4,led);
endmodule
