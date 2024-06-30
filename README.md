# Digital Voting Machine Project Using Verilog
This project focuses on the design and implementation of a digital voting machine using Verilog HDL. The voting machine allows users to vote for one of four candidates by pressing corresponding buttons. The machine debounces the button presses, logs valid votes, and displays the results on LEDs based on the operating mode (voting or result display).
# Components and Functionality
1. Button Control Module (buttoncontrol)
Purpose: Debounces button presses and registers valid votes.
Inputs:
'clock': System clock signal.
'reset': Reset signal to initialize the module.
'button': Button press signal.
Output:
'valid_vote': Signal indicating a valid vote has been registered.
Description: This module uses a counter to debounce the button presses. When a button is pressed, the counter increments, and once it reaches a threshold (10 in this case), a valid vote is registered. If the button is released before reaching the threshold, the counter resets.

2. Mode Control Module (modecontrol)
Purpose: Manages the operating mode (voting or result display) and controls LED outputs.
Inputs:
'clock': System clock signal.
'reset': Reset signal to initialize the module.
'mode': Mode signal (0 for voting, 1 for result display).
'valid_vote_casted': Signal indicating any valid vote has been cast.
'candidate_1_vote', 'candidate_2_vote', 'candidate_3_vote', 'candidate_4_vote': Vote counts for each candidate.
'candidate1_button_press', 'candidate2_button_press', 'candidate3_button_press', 'candidate4_button_press': Button press signals for each candidate.
Output:
'leds': LED output to display status or results.
Description: This module controls the LEDs based on the mode and vote counts. In voting mode, it shows active/inactive status. In result display mode, it shows the vote counts for the selected candidate based on button presses.

3. Vote Logger Module (voteLogger)
Purpose: Logs and counts valid votes for each candidate.
Inputs:
'clock': System clock signal.
'reset': Reset signal to initialize the module.
'mode': Mode signal (0 for voting, 1 for result display).
'cand1_vote_valid', 'cand2_vote_valid', 'cand3_vote_valid', 'cand4_vote_valid': Valid vote signals for each candidate.
Outputs:
'cand1_vote_recvd', 'cand2_vote_recvd', 'cand3_vote_recvd', 'cand4_vote_recvd': Vote counts for each candidate.
Description: This module increments the vote count for each candidate when a valid vote is registered in voting mode.

4. Main Voting Machine Module (votingmachine)
Purpose: Integrates all sub-modules to form the complete voting machine.
Inputs:
'clock': System clock signal.
'reset': Reset signal to initialize the module.
'mode': Mode signal (0 for voting, 1 for result display).
'button1', 'button2', 'button3', 'button4': Button press signals for each candidate.
Output:
'led': LED output to display status or results.
Description: This top-level module instantiates the button control, vote logger, and mode control modules. It connects the button presses to the button control modules, collects valid vote signals, logs votes using the vote logger module, and manages LED outputs using the mode control module.
# Detailed Operation
1.Voting Mode (mode = 0):

Users press buttons to vote for candidates.
Button control modules debounce the presses and register valid votes.
Vote logger module counts and logs valid votes for each candidate.
Mode control module indicates active status using LEDs.

2.Result Display Mode (mode = 1):

Users can press buttons to display vote counts for each candidate.
Mode control module outputs the vote counts on LEDs based on the button pressed.
# Conclusion
This digital voting machine project demonstrates the application of Verilog HDL in designing a practical voting system. The modular approach ensures easy debugging and testing, while the clear separation of concerns allows each module to perform its specific function efficiently. The project can be further extended to include more candidates, different voting mechanisms, and more sophisticated result displays.
