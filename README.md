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

The datapath system was implemented based on the schematic above. The areas of intrest are the busses annotated in bold and the output and internal signals labeled in blue. The realization of the datapath system was then simplified by breaking it into roughly eight indpentent components: the program counter in the center of the schematic containing the PC register, incrementer, and the multiplexer situated above the register; the instruction register shown in the upper left corner of the schematic; the MARHi and MARLo memory address registers located betweent the program counter and the instruction register; the address selector multiplexer located below the program counter; the ALU component, which was designed and tested in the previous section, shown in the upper right; the accumulator register connected below the ALU; the tristate buffer for accumulator databus feedback signal; and finally the two output signals "accumulaotr equals zero" and "accumulator less than zero" shown in the lower right of the schematic.

Appart from the two ouput signals, which were realized using combinational logic blocks, and the ALU, which existed as a standalone component, the components above were realized using process statements. Each register was controled using an enable switch, updating clock signal, and an asyncronous reset low switch that reset all regisers to zero when a LOW signal is applied. The multiplexer was realized with an asyncronus process to match the behavior of a practical device. 

Each componented was "wired" into the different signals labeled in blue in the diagram.

#### Debugging

Most of the debugging that took place due to mistypings in the datapath VHDL code which casued several signals to be updated several times while other signals were not assigned at all. These errors were noted in analyzing the waveform below and noting which signals showed no changes. The debugging process was essentially trivial and does not necessitated excessive explinatino.

Verrification of the datapath code was conducted by comparing the datapath waveform to the example provided in the lab assignment sheet, both signals are shown below for coparison.
