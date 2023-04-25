# Semaphore-controller-VHDL
Hardware design using VHDL for sempahore controller.

**Implementation**

Firstly, we implemented entity bcd_to_7seg that converts BCD code to output for 7 segment display, so that the counting of the time left during the green light can be displayed on its 7 segment LED displays. Later, we will use two of these blocks, for the two displays we have for the display of time.

Next, we implement entity traffic_light in which we implement state machine, that will chose the current state on the semaphore. In the entity we define input signals (clc, reset) and output signals (rc, yc, gc, rp, gp, time_d1, time_d2). All are of type std_logic, and the times are additionally vectors with 4 bits (because take values up to 9 so we need 4 bits). In the declarative part of the architecture, we define the State_t type to name state and the current state and the next state will be of that data type. There we also define the counter signal that will count backwards. In the body of the architecture, we have a special TIMEOUT process that is used for updating counter values. The signals time_d1 and time_d2 are generated at the output and should take values from 0 to 9 because they can be lit by LEDs on the displays. time_d1 and time_d2 represent time remaining until the end of the state. How they they should be displayed only in the greenRed state, in other states they get one of illegal values, e.g. 1010. In the greenRed state there is logic for theirs generation.
