-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "05/01/2015 11:58:12"
                                                            
-- Vhdl Test Bench template for design  :  Filter
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;
-----------------------------------------------------------------
-- the following is added to support writing with write/writeline
-----------------------------------------------------------------
USE ieee.std_logic_textio.all;
USE std.textio.all;

use ieee.std_logic_signed.all;
use ieee.numeric_std.all;  

use ieee.fixed_pkg.all;
use work.myFilter_pkg.all;                               

ENTITY Filter_vhd_tst IS
END Filter_vhd_tst;
ARCHITECTURE Filter_arch OF Filter_vhd_tst IS
-- constants  
--these must be smaller than g_fixInt
constant InputBits : integer :=8; --Number of bits in the input std_logic_vector
constant	OutputBits : integer :=8;--Number of bits in the output std_logic_vector'
constant FilterCoef : integer :=21;--Number of filter poles

--These numbers should be the same as in the filter package?
--Maybe it works also with different numbers
constant g_fixInt : integer := 10;
constant g_fixDec : integer := 12;
                                               
-- signals                                                   
SIGNAL clk : STD_LOGIC :='0';
SIGNAL reset : STD_LOGIC;
SIGNAL signal_in_int : STD_LOGIC_VECTOR(InputBits-1 DOWNTO 0);
SIGNAL signal_out_int : STD_LOGIC_VECTOR(OutputBits-1 DOWNTO 0);
SIGNAL wave_out : std_LOGIC_VECTOR(7 downto 0);
FILE out_file : TEXT OPEN WRITE_MODE IS "out_values.txt";


signal myFilter : Filter_type(0 to FilterCoef-1) :=
(  
0	=>to_sfixed (-0.000164, g_fixInt-1,-1*g_fixDec),
1	=>to_sfixed (-0.001286, g_fixInt-1,-1*g_fixDec),
2	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
3	=>to_sfixed (0.008320, g_fixInt-1,-1*g_fixDec),
4	=>to_sfixed (0.010323, g_fixInt-1,-1*g_fixDec),
5	=>to_sfixed (-0.019086, g_fixInt-1,-1*g_fixDec),
6	=>to_sfixed (-0.054476, g_fixInt-1,-1*g_fixDec),
7	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
8	=>to_sfixed (0.185697, g_fixInt-1,-1*g_fixDec),
9	=>to_sfixed (0.370673, g_fixInt-1,-1*g_fixDec),
10	=>to_sfixed (0.370673, g_fixInt-1,-1*g_fixDec),
11	=>to_sfixed (0.185697, g_fixInt-1,-1*g_fixDec),
12	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
13	=>to_sfixed (-0.054476, g_fixInt-1,-1*g_fixDec),
14	=>to_sfixed (-0.019086, g_fixInt-1,-1*g_fixDec),
15	=>to_sfixed (0.010323, g_fixInt-1,-1*g_fixDec),
16	=>to_sfixed (0.008320, g_fixInt-1,-1*g_fixDec),
17	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
18	=>to_sfixed (-0.001286, g_fixInt-1,-1*g_fixDec),
19	=>to_sfixed (-0.000164, g_fixInt-1,-1*g_fixDec),
20	=>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec)
);


COMPONENT Filter
  generic (
		g_fixInt : integer; --N bits infront of the point
		g_fixDec : integer; --N bits after the point
		g_FilterCoef : integer ; -- Number of filter coefficients
		
		--these must be smaller than g_fixInt
		g_InputBits : integer; --Number of bits in the input std_logic_vector
		g_OutputBits : integer --Number of bits in the output std_logic_vector
    );

	PORT (
	clk : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	Filter : in Filter_type(0 to g_FilterCoef-1);--array with all filter poles
	signal_in_int : IN STD_LOGIC_VECTOR(InputBits-1 DOWNTO 0);
	signal_out_int : OUT STD_LOGIC_VECTOR(OutputBits-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT SignalFromLookUp
	PORT (
	clk : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	wave_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

BEGIN
	i1 : Filter
	  generic map(
		g_fixInt =>g_fixInt, --N bits infront of the point
		g_fixDec =>g_fixDec, --N bits after the point
		g_FilterCoef => FilterCoef, -- Number of filter coefficients
		
		--these must be smaller than g_fixInt
		g_InputBits =>InputBits, --Number of bits in the input std_logic_vector
		g_OutputBits =>OutputBits --Number of bits in the output std_logic_vector
    )
	
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	reset => reset,
	Filter => myFilter,
	signal_in_int => signal_in_int,
	signal_out_int => signal_out_int
	);
	
	i2 : SignalFromLookUp
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	reset => reset,
	wave_out => wave_out
	);
	
	clk<=not clk after 50 ns;
	signal_in_int<=wave_out;
	
	
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once  
		  --do not put here variabes whicha re also changed in the always process
WAIT;                                                       
END PROCESS init;

                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations 

procedure p_stable is
	begin
	--set all signals to a default value
	reset<='1';	
end procedure p_stable;

procedure filter_test(constant c_loop : integer) is
variable l:line;
variable i:integer :=0;
begin
	loop1: while i <= c_loop loop
		wait until rising_edge(clk);
			i:=i+1;
			WRITE(l, i);
			WRITE(l, string'(" "));
			WRITE(l, to_integer(signed(wave_out)));
			WRITE(l, string'(" "));
			WRITE(l, to_integer(signed(signal_out_int)));
			WRITELINE(out_file, l);
			
	end loop loop1;
end filter_test;

                                     
BEGIN  -- code executes for every event on sensitivity list                                                          
  
	p_stable;
	filter_test(2048);
	
	assert false report "--No Failure at the end of the sim--"
	severity failure;
		  
--WAIT;                                                        
END PROCESS always;                                       
END Filter_arch;
