library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all; 

package myFilter_pkg is
	 	--define the resolution of the filter poles
	  constant FilterFixIntSize : integer := 10;
	  constant FilterFixDecSize : integer := -12;
     type Filter_type is array (integer range <>) of sfixed(FilterFixIntSize-1 downto FilterFixDecSize);

end package myFilter_pkg;