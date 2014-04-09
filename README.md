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

The waveform image provided has been overlaid with identifying markers to ease demonstration. Each segment between yellow vertical lines represents a single instruction cycle with the name of the instruction provided below each segment. Each set of accumulator, data, and OpSel inputs were analyzed separately to ensure that the "Result" output corresponded with which values were expected. 

The only major bug found in the code during debugging was that the "rotate right" instruction executed like a "rotate left" which indicated that the index rotation used in the code was backwards. Analyzing the code indicated that the indexes were incremented in ROR, the indexes were reassigned in decremented order accordingly.

After the debugging cycle all input values displayed the correct result values. Although all values for every instruction were not tested exhaustively, the simplistic nature of the ALU structure provides a good level of confidence in the limited results presented.

After several debugging cycles each input set produced the proper expected output. 
