-------------------------------------------------------------------------------
--
-- Title       : ALU
-- Design      : ALU
-- Author      : usafa
-- Company     : usafa
--
-------------------------------------------------------------------------------
--
-- File        : ALU.vhd
-- Generated   : Fri Mar 30 11:16:54 2007
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ALU} architecture {ALU}}

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
	 port(
		 OpSel : in STD_LOGIC_VECTOR(2 downto 0);
		 Data : in STD_LOGIC_VECTOR(3 downto 0);
		 Accumulator : in STD_LOGIC_VECTOR(3 downto 0);
		 Result : out STD_LOGIC_VECTOR(3 downto 0)
	     );
end ALU;

--}} End of automatically maintained section

architecture ALU of ALU is	   


begin
	
-- fill in details to create result as a function of Data and Accumulator, based on OpSel.
 -- e.g : Build a multiplexer choosing between the eight ALU operations.  Either use a case statement (and thus a process)
 --       or a conditional signal assignment statement ( x <= Y when <condition> else . . .)
 -- ALU Operations are defined as:
 -- OpSel : Function
--  0     : AND
--  1     : NEG (2s complement)
--  2     : NOT (invert)
--  3     : ROR
--  4     : OR
--  5     : IN
--  6     : ADD
--  7     : LD
aluswitch: process (Accumulator, Data, OpSel)
        begin
		case OpSel is
			when "000" => 
			   -- And using the built in and function
				Result <= Data and Accumulator;
			when "001" =>
				-- Two's compliment by inverting then adding one
				Result <= not Accumulator + "0001";
			when "010" =>
			   -- Invert Use built in inverting Command
				Result <= not Accumulator;
			when "011" =>
				-- Roatate Right by reassigning the bit values
				Result(0) <= Accumulator(1);
				Result(1) <= Accumulator(2);
				Result(2) <= Accumulator(3);
				Result(3) <= Accumulator(0);
			when "100" =>
				-- Or using built in function
				Result <= Accumulator or Data;
			when "101" =>
				-- In simply passes data from the databus from accumulator
				Result <= Data;
			when "110" =>
				-- Add using unsighed addition
				Result <= Accumulator + Data;
			when "111" =>
				-- Load simply passes data from the databus to the accumulator
				Result <= Data;
			when others =>
				Result <= Accumulator;
		end case;
		end process;

-- OR, enter your conditional signal statement here

end ALU;

