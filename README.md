ECE281_Lab4
===========

Building Prisim

### Algorithmic Logic Unit

#### Design

The first task in completing the PRISIM databus was to create the functionality of the algorithmic logic unit from the ALU_shell.vhd code provided. The PRISIM ALU operates off of the "operation select" (OpSel), "data bus" (Data), and "Accumulator" signals, where OpSel contains the instruction and Data and Accumulator contain the data from the databus and accumulator locations respectively. The opcodes are as follows

|OpSel|Instruction|
|:-:|:-:|
|000|AND|
|001|NEG|
|010|NOT|
|011|ROR|
|100|OR|
|101|IN|
|110|ADD|
|111|LDA|

 Note: OpSel are only multiplexer inputs, not the opcodes used in prisim.
  
The instructions AND, OR, and NOT perform their respective logic operation on the accumulator and/or databus value. NEG performs a two's compliment conversion on the accumulator value. ROR performs a rotate right on the accumulator value. IN and LDA load a value from the databus into the accumulator (the data originating in an input port or memory respectively). Finally ADD performs a simple unsigned binary addition operation on the accumulator and data values.

The ALU was realized int the ALU_shell.vhd file inside a process case statement. AND, OR, and NOT operations were realized using STD_LOGIC binary operations. IN and LDA performed by simply writing the databus input to the output. NEG was performed using the "invert and add one" method using logic operations and unsigned addition. Lastly, ROR was performed by writing each bit of data one index to the right 3 -> 0, 0 -> 1, ect.

#### Debugging

The ALU was tested and debugged using the provided ALU_testbench.vhd file. The testbench simply cycled though all possible values for OpSel to test every instruction, then cycled though two different 4 bit numbers for the accumulator and data inputs. The output of this testbench were visually tested and verified by the designer. The final successful test  results are shown below.

![alt text](https://raw2.github.com/IanGoodbody/ECE281_Lab4/master/ALU_test.jpg "ALU Testbench Waveform")

The waveform image provided has been overlaid with identifying markers to ease demonstration, yellow vertical lines seperate different instructions and red numbering on the right side of the waveform shows the values that cut off by the viewing range. Each segment between yellow vertical lines represents a single instruction cycle with the name of the instruction provided below each segment. Each set of accumulator, data, and OpSel inputs were analyzed separately to ensure that the "Result" output corresponded with which values were expected. 

The only major bug found in the code during debugging was that the "rotate right" instruction executed like a "rotate left" which indicated that the index rotation used in the code was backwards. Analyzing the code indicated that the indexes were incremented in ROR, the indexes were reassigned in decremented order accordingly.

After the debugging cycle all input values displayed the correct result values. Although all values for every instruction were not tested exhaustively, the simplistic nature of the ALU structure provides a good level of confidence in the limited results presented.

After several debugging cycles each input set produced the proper expected output.

### Datapath

#### Design

![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab4/master/Datapath.jpg "Datapath Schematic")

The datapath system was implemented based on the schematic above. The areas of interest are the buses annotated in bold and the output and internal signals labeled in blue. The realization of the datapath system was then simplified by breaking it into roughly eight independent components: the program counter in the center of the schematic containing the PC register, incrementer, and the multiplexer situated above the register; the instruction register shown in the upper left corner of the schematic; the MARHi and MARLo memory address registers located between the program counter and the instruction register; the address selector multiplexer located below the program counter; the ALU component, which was designed and tested in the previous section, shown in the upper right; the accumulator register connected below the ALU; the tristate buffer for accumulator databus feedback signal; and finally the two output signals "accumulator equals zero" and "accumulator less than zero" shown in the lower right of the schematic.

Appart from the two ouput signals, which were realized using combinationallogic blocks, and the ALU, which existed as a standalone component, the components above were realized using process statements. Each register was controlled using an enable switch, updating clock signal, and an asynchronous reset low switch that reset all registers to zero when a LOW signal is applied. The multiplexer was realized with an asynchronous process to match the behavior of a practical device. 

Each component was "wired" into the different signals labeled in blue in the diagram.

#### Debugging

Most of the debugging that took place due to mistypings in the datapath VHDL code which caused several signals to be updated several times while other signals were not assigned at all. These errors were noted in analyzing the waveform below and noting which signals showed no changes. The debugging process was essentially trivial and does not necessitated excessive explanation.

Verification of the datapath code was conducted by comparing the datapath waveform to the example provided in the lab assignment sheet, both signals are shown below for comparison.

Datapath output waveform
![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab4/master/Datapath_test.jpg "Output Waveform")

Verification waveform
![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab4/master/VerificationWave.jpg "Verification")


The discrepancy shown in the clock signal is due to the fact that the measurements were taken approximately 5 ns apart from one another, only the clock signal changed within the period and the remainder of the signals can be verified correct upon simple inspection.

### Program Reverse Engineering

#### Initial Operation

![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab4/master/Wave130ns.JPG "Reverse Engineering Wave")

The final portion of the lab was to reverse engineer segments of the program expressed by thethe PRISM circuit waveform. The first segment of code analyzed is shown in the waveform above and the important signals and timing are shown in the table below for convenience.

|Time|PC|IR|Instruction|data|accumulator|addr|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|16 ns|01|7|LDAI|7|0|01|
|28 ns|02|7|LDAI|B|0|02|
|48 ns|03|7|LDAI|3|B|03|
|58 ns|04|3|ROR|4|B|04|
|78 ns|04|3|ROR|4|D|04|
|93 ns|05|4|OUT|3|D|05|
|110 ns|06|4|OUT|D|D|03|
|130 ns|07|0|NOP|D|D|07|

Prior to 16 ns the PRISM computer has been reset to the zero state and the instruction is a NOP;, however the program has alread loaded 7 from memory location 00. By 16 ns the program counter has incremented to 01 alongside the "addr" signal and the value previously on the "data" signal, 7, is loaded into the IR indicating a "load immediately" command.

By 28 ns the program counter and "addr" address signal have incremented to 02; however it is the value B from location 01 that currently resides on the "data" bus. PRISM instructions indicate that the next signal after LADI will be the value to be loaded and at 58 ns the B value found at 01 is loaded into the accumulator.

By 58 ns the PC and "addr" values have moved onto the next memory location, and a new instruction has been loaded form the previous memory location 02 to the "data" bus, and from there into the instruction register. This value, 3, corresponds to a ROR command which affects the value in the accumulator. By 78 ns the accumulator value has rotated from B to D.

After the next incrementation in the program counter at 93 ns the 4 signal that was previously on the "data" bus has been loaded into the instruction register, and the "data" bus signal has assumed the next value in memory 3. Because the 4 signal corresponds with the OUT instruction the 3 in "data" corresponds with the address of the output port. consequently at 110 ns the "addr" signal has assumed a value of 03 (instead of following the program counter) and the "data" bus is set to D essentially writing the value at the accumulator to the memory address 3.

The last instruction shown at 130 ns is a 0 indicating a NOP instruction. The "addr" signal has re-assumed the value of the program counter, and the accumulator remains set to D. The value in "data" bus has been set to D which here represents the next instruction in the program.

In summary the first 150 of the program load a decimal 11 or hexadecimal B into the accumulator, preform a rotate right operation converting it to a decimal 13 or hexadecimal D, and finally write the hexadecimal D to the output port at address 3.

#### Jump Instruction

![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab4/master/Jump.jpg "Reverse Engineering Wave")

The second portion of the signal to be analyzed is the jump command shown in the waveform above, as before a simplified table is provided to highlight the convenient signals.

|Time|PC|IR|Instruction|data|accumulator|addr|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|190 ns|0A|D|STA|B|D|0A|
|200 ns|0B|B|JN|2|D|0B|
|220 ns|0C|B|JN|0|B|03|
|230 ns|0D|B|JN|7|D|02|
|240 ns|02|B|JN|3|D|02|
|250 ns|03|3|ROR|4|D|03|

At the 190 ns mark the instruction D, STA, has just completed storing the accumulator value into memory. The main focus at this time is the B value in the "data" bus that has been read from memory location 0A.

At 200 ns this B value is loaded into the instruction register to correspond with the JN or "jump when negative instruction" which jumps to a specified memory location if the value in the accumulator is a two's compliment negative. This is determined by the "alesszero" signal shown in the bottom of the waveform. The accumulator value is HIGH all though the period analyzed.

The next two memory inputs, located at 0B and 0C give the jump location for the JN command. These values are loaded at 200 ns 220 ns respectively into the databus and then into the MARHi and MARlo registers as shown on the waveform. 
At 230 ns the signal is transitioning. The address bus has changed to 02, however the program counter is on its incremented instruction and 7, likely the instruction located at 0D is in the "data" bus.

By 240 ns the program counter has jumped back to 02 and the 3 from that memory location, corresponding with the ROR command, is loaded in the "data" bus. The ROR command begins execution at 250 ns and the program begins to cycle as before.

In summary, this portion of the program checks if the accumulator value is negative and if so jumps the program back to memory location 02 containing a ROR command. In sequence the first and second code blocks will rotate the accumulator value until it is less than an unsigned 8 corresponding to a positive two's compliment number. Given the original input B, the program will cycle thrice from B, to D, to F, and finally to 7 which will be stored in memory and the program will continue on from there. The PRISM GUI realization for these first two sections is shown below.

![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab4/master/PRISM.jpg "PRISM Code")

Documentation: Captain Silva helped me fix some inherent errors in the Datapath_shell.vhd code that I had missed during class.
