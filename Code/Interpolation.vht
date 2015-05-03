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
-- Generated on "05/02/2015 22:30:21"
                                                            
-- Vhdl Test Bench template for design  :  Interpolation
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

library work;
use work.myFilter_pkg.all; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;                                

USE ieee.std_logic_textio.all;
USE std.textio.all;



ENTITY Interpolation_vhd_tst IS
END Interpolation_vhd_tst;
ARCHITECTURE Interpolation_arch OF Interpolation_vhd_tst IS
-- constants 
constant g_fixInt : integer := 10; --N bits infront of the point
constant g_fixDec : integer := 12; --N bits after the point
constant g_FilterCoef : integer := 21; -- Number of filter coefficients
--these must be smaller than g_fixInt
constant g_InputBits : integer := 8; --Number of bits in the input std_logic_vector
constant g_OutputBits : integer := 8; --Number of bits in the output std_logic_vector
constant g_Interpolation :integer := 5; --Interploation factor max is 31                                                
-- signals                                                   
SIGNAL clk : STD_LOGIC :='0';
SIGNAL clk_slow : STD_LOGIC :='0';
SIGNAL FilterPole : Filter_type(0 to g_FilterCoef-1);
SIGNAL reset : STD_LOGIC;
SIGNAL signal_in_int : STD_LOGIC_VECTOR(g_InputBits-1 DOWNTO 0);
SIGNAL signal_out_int : STD_LOGIC_VECTOR(g_OutputBits-1 DOWNTO 0);
SIGNAL wave_out : std_LOGIC_VECTOR(7 downto 0);
FILE out_file : TEXT OPEN WRITE_MODE IS "out_values.txt";

signal myFilter : Filter_type(0 to g_FilterCoef-1) :=
( 0	=>to_sfixed (0.003295, g_fixInt-1,-1*g_fixDec),
1	=>to_sfixed (0.015601, g_fixInt-1,-1*g_fixDec),
2	=>to_sfixed (0.042085, g_fixInt-1,-1*g_fixDec),
3	=>to_sfixed (0.088530, g_fixInt-1,-1*g_fixDec),
4	=>to_sfixed (0.158500, g_fixInt-1,-1*g_fixDec),
5	=>to_sfixed (0.250302, g_fixInt-1,-1*g_fixDec),
6	=>to_sfixed (0.355226, g_fixInt-1,-1*g_fixDec),
7	=>to_sfixed (0.458193, g_fixInt-1,-1*g_fixDec),
8	=>to_sfixed (0.541004, g_fixInt-1,-1*g_fixDec),
9	=>to_sfixed (0.587264, g_fixInt-1,-1*g_fixDec),
10	=>to_sfixed (0.587264, g_fixInt-1,-1*g_fixDec),
11	=>to_sfixed (0.541004, g_fixInt-1,-1*g_fixDec),
12	=>to_sfixed (0.458193, g_fixInt-1,-1*g_fixDec),
13	=>to_sfixed (0.355226, g_fixInt-1,-1*g_fixDec),
14	=>to_sfixed (0.250302, g_fixInt-1,-1*g_fixDec),
15	=>to_sfixed (0.158500, g_fixInt-1,-1*g_fixDec),
16	=>to_sfixed (0.088530, g_fixInt-1,-1*g_fixDec),
17	=>to_sfixed (0.042085, g_fixInt-1,-1*g_fixDec),
18	=>to_sfixed (0.015601, g_fixInt-1,-1*g_fixDec),
19	=>to_sfixed (0.003295, g_fixInt-1,-1*g_fixDec),
20	=>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec)
);


COMPONENT Interpolation
  generic (
		g_fixInt : integer; --N bits infront of the point
		g_fixDec : integer; --N bits after the point
		g_FilterCoef : integer ; -- Number of filter coefficients
		
		--these must be smaller than g_fixInt
		g_InputBits : integer; --Number of bits in the input std_logic_vector
		g_OutputBits : integer; --Number of bits in the output std_logic_vector
		g_Interpolation :integer  --Interploation factor max is 31
    );
	PORT (
	clk : IN STD_LOGIC;
	FilterPole : IN Filter_type(0 to g_FilterCoef-1);
	reset : IN STD_LOGIC;
	signal_in_int : IN STD_LOGIC_VECTOR(g_InputBits DOWNTO 0);
	signal_out_int : OUT STD_LOGIC_VECTOR(g_OutputBits DOWNTO 0)
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
	i1 : Interpolation
	generic map(
		g_fixInt =>g_fixInt, --N bits infront of the point
		g_fixDec =>g_fixDec, --N bits after the point
		g_FilterCoef => g_FilterCoef, -- Number of filter coefficients
		
		--these must be smaller than g_fixInt
		g_InputBits =>g_InputBits, --Number of bits in the input std_logic_vector
		g_OutputBits =>g_OutputBits, --Number of bits in the output std_logic_vector
		g_Interpolation => g_Interpolation
    )
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	FilterPole => myFilter,
	reset => reset,
	signal_in_int => signal_in_int,
	signal_out_int => signal_out_int
	);
	
	i2 : SignalFromLookUp
	PORT MAP (
-- list connections between master ports and signals
	clk => clk_slow,
	reset => reset,
	wave_out => wave_out
	);
	
	clk<=not clk after 50 ns;
	clk_slow<=not clk_slow after g_Interpolation*50 ns;
	signal_in_int<=wave_out;
	
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
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


procedure interpolation_test(constant c_loop : integer) is
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
end interpolation_test;

                                     
BEGIN                                                         
        -- code executes for every event on sensitivity list 
		 
	p_stable;
	interpolation_test(3072);
	
	--add a clock divided by three for the input wave signal
	--make control plot without the filter
	
	assert false report "--No Failure at the end of the sim1--"
	severity failure; 
--WAIT;                                                        
END PROCESS always;                                          
END Interpolation_arch;
