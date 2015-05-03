-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : xx-xx-2015
-----------------------------------------------------------------------------
-- Description     : Description
--	This block is doing interpolation
		
--
-- The interpolation adds 0s between the samples and then lowpass filteres
-- the signal in order to interpolate
--
-- The clk must have the speed of the output signal
--Interpolation 1 => cutoff 0.5 f
--Interpolation 2 => cutoff 0.25 f
--Interpolation 3 => cutoff 
-----------------------------------------------------------------------------
-- Copyright 2015. All rights reserved
-----------------------------------------------------------------------------

library work;
use work.myFilter_pkg.all; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all; 


entity Interpolation is
  generic (

		--Do not change this g_fixInt, g_fixDec without changing
		-- also the package definition
		-- quartus does not support VHDL 2008 arrays with two unconstraint sizes
		g_fixInt : integer := 10; --N bits infront of the point
		g_fixDec : integer := 12; --N bits after the point
		
		
		g_FilterCoef : integer := 21; -- Number of filter coefficients
		
		--these must be smaller than g_fixInt
		g_InputBits : integer := 8; --Number of bits in the input std_logic_vector
		g_OutputBits : integer := 8; --Number of bits in the output std_logic_vector
		
		g_Interpolation :integer := 3 --Interploation factor max is 31
    );
	port 
	(
		clk		: in std_logic;
		reset	:	in	std_logic;
		
		FilterPole : in Filter_type(0 to g_FilterCoef-1);--array with all filter poles
		
		signal_in_int : in std_logic_vector(g_InputBits-1 downto 0);
		signal_out_int : out std_logic_vector(g_OutputBits-1 downto 0)
		
	);

end entity;

architecture rtl of Interpolation is

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
	signal_in_int : IN STD_LOGIC_VECTOR(g_InputBits-1 DOWNTO 0);
	signal_out_int : OUT STD_LOGIC_VECTOR(g_OutputBits-1 DOWNTO 0)
	);
END COMPONENT;

signal FilterInput: STD_LOGIC_VECTOR(g_InputBits-1 DOWNTO 0);

begin
	
	--signal FilterOutput: STD_LOGIC_VECTOR(g_InputBits-1 DOWNTO 0);


	i1 : Filter
	  generic map(
		g_fixInt =>g_fixInt, --N bits infront of the point
		g_fixDec =>g_fixDec, --N bits after the point
		g_FilterCoef => g_FilterCoef, -- Number of filter coefficients
		--these must be smaller than g_fixInt
		g_InputBits =>g_InputBits, --Number of bits in the input std_logic_vector
		g_OutputBits =>g_OutputBits --Number of bits in the output std_logic_vector
    )
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	reset => reset,
	Filter => FilterPole,
	signal_in_int => FilterInput,
	signal_out_int => signal_out_int
	);

	Interpolation_process: process(clk, reset) 
	
	variable IntpCounter : integer range 0 to 31 := 0;--(others => 0); --can count to 31
	begin
		if(reset='0') then
			IntpCounter:=0;
		elsif(rising_edge(clk)) then
	
			IntpCounter:=IntpCounter+1;
			if(IntpCounter=g_Interpolation) then
				IntpCounter:=0;
			end if;
			
			if(IntpCounter=0) then--if the counter is 0 a data sample goes into the output,
				FilterInput<=signal_in_int;
			else -- otherwise a 0 goes into the output
				FilterInput<=(others => '0');
			end if;

		end if;
	end process Interpolation_process;
	
end rtl;
