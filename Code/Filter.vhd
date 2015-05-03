-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : xx-xx-2015
-----------------------------------------------------------------------------
-- Description     : Description
--	In this package we work with a 32 bit long fixed point, separated in 20 bits before the point and 12 after the point						
-- The output comes filterlength+2 clks later
-----------------------------------------------------------------------------
-- Copyright 2015. All rights reserved
-----------------------------------------------------------------------------



use work.myFilter_pkg.all; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;  



entity Filter is
  generic (

		--Do not change this g_fixInt, g_fixDec without changing
		-- also the package definition
		-- quartus does not support VHDL 2008 arrays with two unconstraint sizes
		g_fixInt : integer := 10; --N bits infront of the point
		g_fixDec : integer := 12; --N bits after the point
		
		
		g_FilterCoef : integer := 21; -- Number of filter coefficients
		
		--these must be smaller than g_fixInt
		g_InputBits : integer := 8; --Number of bits in the input std_logic_vector
		g_OutputBits : integer := 8 --Number of bits in the output std_logic_vector
    );
	port 
	(
		clk		: in std_logic;
		reset	:	in	std_logic;
		
		Filter : in Filter_type(0 to g_FilterCoef-1);--array with all filter poles
		
		signal_in_int : in std_logic_vector(g_InputBits-1 downto 0);
		signal_out_int : out std_logic_vector(g_OutputBits-1 downto 0)
		
	);

end entity;

architecture rtl of Filter is

--type Filter_type is array (0 to g_FilterCoef-1) of sfixed (g_fixInt-1 downto -1*g_fixDec);
type IterBuffer is array (0 to g_FilterCoef-1) of sfixed (g_fixInt-1 downto -1*g_fixDec);

----Place here the list of coefficients (Filter Kernel)
--signal Filter : Filter_type(0 to 20) :=
--(  
--0	=>to_sfixed (-0.000164, g_fixInt-1,-1*g_fixDec),
--1	=>to_sfixed (-0.001286, g_fixInt-1,-1*g_fixDec),
--2	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--3	=>to_sfixed (0.008320, g_fixInt-1,-1*g_fixDec),
--4	=>to_sfixed (0.010323, g_fixInt-1,-1*g_fixDec),
--5	=>to_sfixed (-0.019086, g_fixInt-1,-1*g_fixDec),
--6	=>to_sfixed (-0.054476, g_fixInt-1,-1*g_fixDec),
--7	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--8	=>to_sfixed (0.185697, g_fixInt-1,-1*g_fixDec),
--9	=>to_sfixed (0.370673, g_fixInt-1,-1*g_fixDec),
--10	=>to_sfixed (0.370673, g_fixInt-1,-1*g_fixDec),
--11	=>to_sfixed (0.185697, g_fixInt-1,-1*g_fixDec),
--12	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--13	=>to_sfixed (-0.054476, g_fixInt-1,-1*g_fixDec),
--14	=>to_sfixed (-0.019086, g_fixInt-1,-1*g_fixDec),
--15	=>to_sfixed (0.010323, g_fixInt-1,-1*g_fixDec),
--16	=>to_sfixed (0.008320, g_fixInt-1,-1*g_fixDec),
--17	=>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--18	=>to_sfixed (-0.001286, g_fixInt-1,-1*g_fixDec),
--19	=>to_sfixed (-0.000164, g_fixInt-1,-1*g_fixDec),
--20	=>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec)
--);

--signal Filter : Filter_type :=
--(
--0       =>to_sfixed (0.000004, g_fixInt-1,-1*g_fixDec),
--1       =>to_sfixed (-0.000006, g_fixInt-1,-1*g_fixDec),
--2       =>to_sfixed (-0.000042, g_fixInt-1,-1*g_fixDec),
--3       =>to_sfixed (-0.000024, g_fixInt-1,-1*g_fixDec),
--4       =>to_sfixed (0.000103, g_fixInt-1,-1*g_fixDec),
--5       =>to_sfixed (0.000156, g_fixInt-1,-1*g_fixDec),
--6       =>to_sfixed (-0.000086, g_fixInt-1,-1*g_fixDec),
--7       =>to_sfixed (-0.000383, g_fixInt-1,-1*g_fixDec),
--8       =>to_sfixed (-0.000159, g_fixInt-1,-1*g_fixDec),
--9       =>to_sfixed (0.000545, g_fixInt-1,-1*g_fixDec),
--10      =>to_sfixed (0.000702, g_fixInt-1,-1*g_fixDec),
--11      =>to_sfixed (-0.000340, g_fixInt-1,-1*g_fixDec),
--12      =>to_sfixed (-0.001376, g_fixInt-1,-1*g_fixDec),
--13      =>to_sfixed (-0.000526, g_fixInt-1,-1*g_fixDec),
--14      =>to_sfixed (0.001687, g_fixInt-1,-1*g_fixDec),
--15      =>to_sfixed (0.002049, g_fixInt-1,-1*g_fixDec),
--16      =>to_sfixed (-0.000943, g_fixInt-1,-1*g_fixDec),
--17      =>to_sfixed (-0.003650, g_fixInt-1,-1*g_fixDec),
--18      =>to_sfixed (-0.001341, g_fixInt-1,-1*g_fixDec),
--19      =>to_sfixed (0.004150, g_fixInt-1,-1*g_fixDec),
--20      =>to_sfixed (0.004881, g_fixInt-1,-1*g_fixDec),
--21      =>to_sfixed (-0.002183, g_fixInt-1,-1*g_fixDec),
--22      =>to_sfixed (-0.008240, g_fixInt-1,-1*g_fixDec),
--23      =>to_sfixed (-0.002960, g_fixInt-1,-1*g_fixDec),
--24      =>to_sfixed (0.008986, g_fixInt-1,-1*g_fixDec),
--25      =>to_sfixed (0.010398, g_fixInt-1,-1*g_fixDec),
--26      =>to_sfixed (-0.004590, g_fixInt-1,-1*g_fixDec),
--27      =>to_sfixed (-0.017163, g_fixInt-1,-1*g_fixDec),
--28      =>to_sfixed (-0.006132, g_fixInt-1,-1*g_fixDec),
--29      =>to_sfixed (0.018602, g_fixInt-1,-1*g_fixDec),
--30      =>to_sfixed (0.021632, g_fixInt-1,-1*g_fixDec),
--31      =>to_sfixed (-0.009664, g_fixInt-1,-1*g_fixDec),
--32      =>to_sfixed (-0.036900, g_fixInt-1,-1*g_fixDec),
--33      =>to_sfixed (-0.013626, g_fixInt-1,-1*g_fixDec),
--34      =>to_sfixed (0.043440, g_fixInt-1,-1*g_fixDec),
--35      =>to_sfixed (0.054430, g_fixInt-1,-1*g_fixDec),
--36      =>to_sfixed (-0.027266, g_fixInt-1,-1*g_fixDec),
--37      =>to_sfixed (-0.125374, g_fixInt-1,-1*g_fixDec),
--38      =>to_sfixed (-0.065212, g_fixInt-1,-1*g_fixDec),
--39      =>to_sfixed (0.514718, g_fixInt-1,-1*g_fixDec),
--40      =>to_sfixed (-0.514718, g_fixInt-1,-1*g_fixDec),
--41      =>to_sfixed (0.065212, g_fixInt-1,-1*g_fixDec),
--42      =>to_sfixed (0.125374, g_fixInt-1,-1*g_fixDec),
--43      =>to_sfixed (0.027266, g_fixInt-1,-1*g_fixDec),
--44      =>to_sfixed (-0.054430, g_fixInt-1,-1*g_fixDec),
--45      =>to_sfixed (-0.043440, g_fixInt-1,-1*g_fixDec),
--46      =>to_sfixed (0.013626, g_fixInt-1,-1*g_fixDec),
--47      =>to_sfixed (0.036900, g_fixInt-1,-1*g_fixDec),
--48      =>to_sfixed (0.009664, g_fixInt-1,-1*g_fixDec),
--49      =>to_sfixed (-0.021632, g_fixInt-1,-1*g_fixDec),
--50      =>to_sfixed (-0.018602, g_fixInt-1,-1*g_fixDec),
--51      =>to_sfixed (0.006132, g_fixInt-1,-1*g_fixDec),
--52      =>to_sfixed (0.017163, g_fixInt-1,-1*g_fixDec),
--53      =>to_sfixed (0.004590, g_fixInt-1,-1*g_fixDec),
--54      =>to_sfixed (-0.010398, g_fixInt-1,-1*g_fixDec),
--55      =>to_sfixed (-0.008986, g_fixInt-1,-1*g_fixDec),
--56      =>to_sfixed (0.002960, g_fixInt-1,-1*g_fixDec),
--57      =>to_sfixed (0.008240, g_fixInt-1,-1*g_fixDec),
--58      =>to_sfixed (0.002183, g_fixInt-1,-1*g_fixDec),
--59      =>to_sfixed (-0.004881, g_fixInt-1,-1*g_fixDec),
--60      =>to_sfixed (-0.004150, g_fixInt-1,-1*g_fixDec),
--61      =>to_sfixed (0.001341, g_fixInt-1,-1*g_fixDec),
--62      =>to_sfixed (0.003650, g_fixInt-1,-1*g_fixDec),
--63      =>to_sfixed (0.000943, g_fixInt-1,-1*g_fixDec),
--64      =>to_sfixed (-0.002049, g_fixInt-1,-1*g_fixDec),
--65      =>to_sfixed (-0.001687, g_fixInt-1,-1*g_fixDec),
--66      =>to_sfixed (0.000526, g_fixInt-1,-1*g_fixDec),
--67      =>to_sfixed (0.001376, g_fixInt-1,-1*g_fixDec),
--68      =>to_sfixed (0.000340, g_fixInt-1,-1*g_fixDec),
--69      =>to_sfixed (-0.000702, g_fixInt-1,-1*g_fixDec),
--70      =>to_sfixed (-0.000545, g_fixInt-1,-1*g_fixDec),
--71      =>to_sfixed (0.000159, g_fixInt-1,-1*g_fixDec),
--72      =>to_sfixed (0.000383, g_fixInt-1,-1*g_fixDec),
--73      =>to_sfixed (0.000086, g_fixInt-1,-1*g_fixDec),
--74      =>to_sfixed (-0.000156, g_fixInt-1,-1*g_fixDec),
--75      =>to_sfixed (-0.000103, g_fixInt-1,-1*g_fixDec),
--76      =>to_sfixed (0.000024, g_fixInt-1,-1*g_fixDec),
--77      =>to_sfixed (0.000042, g_fixInt-1,-1*g_fixDec),
--78      =>to_sfixed (0.000006, g_fixInt-1,-1*g_fixDec),
--79      =>to_sfixed (-0.000004, g_fixInt-1,-1*g_fixDec),
--80      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec)
--);


--signal Filter : Filter_type :=
--(  
--0       =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--1       =>to_sfixed (-0.000001, g_fixInt-1,-1*g_fixDec),
--2       =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--3       =>to_sfixed (0.000004, g_fixInt-1,-1*g_fixDec),
--4       =>to_sfixed (0.000004, g_fixInt-1,-1*g_fixDec),
--5       =>to_sfixed (-0.000006, g_fixInt-1,-1*g_fixDec),
--6       =>to_sfixed (-0.000014, g_fixInt-1,-1*g_fixDec),
--7       =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--8       =>to_sfixed (0.000024, g_fixInt-1,-1*g_fixDec),
--9       =>to_sfixed (0.000019, g_fixInt-1,-1*g_fixDec),
--10      =>to_sfixed (-0.000023, g_fixInt-1,-1*g_fixDec),
--11      =>to_sfixed (-0.000045, g_fixInt-1,-1*g_fixDec),
--12      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--13      =>to_sfixed (0.000064, g_fixInt-1,-1*g_fixDec),
--14      =>to_sfixed (0.000047, g_fixInt-1,-1*g_fixDec),
--15      =>to_sfixed (-0.000054, g_fixInt-1,-1*g_fixDec),
--16      =>to_sfixed (-0.000101, g_fixInt-1,-1*g_fixDec),
--17      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--18      =>to_sfixed (0.000132, g_fixInt-1,-1*g_fixDec),
--19      =>to_sfixed (0.000092, g_fixInt-1,-1*g_fixDec),
--20      =>to_sfixed (-0.000104, g_fixInt-1,-1*g_fixDec),
--21      =>to_sfixed (-0.000190, g_fixInt-1,-1*g_fixDec),
--22      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--23      =>to_sfixed (0.000237, g_fixInt-1,-1*g_fixDec),
--24      =>to_sfixed (0.000163, g_fixInt-1,-1*g_fixDec),
--25      =>to_sfixed (-0.000181, g_fixInt-1,-1*g_fixDec),
--26      =>to_sfixed (-0.000323, g_fixInt-1,-1*g_fixDec),
--27      =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--28      =>to_sfixed (0.000392, g_fixInt-1,-1*g_fixDec),
--29      =>to_sfixed (0.000266, g_fixInt-1,-1*g_fixDec),
--30      =>to_sfixed (-0.000291, g_fixInt-1,-1*g_fixDec),
--31      =>to_sfixed (-0.000515, g_fixInt-1,-1*g_fixDec),
--32      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--33      =>to_sfixed (0.000613, g_fixInt-1,-1*g_fixDec),
--34      =>to_sfixed (0.000412, g_fixInt-1,-1*g_fixDec),
--35      =>to_sfixed (-0.000448, g_fixInt-1,-1*g_fixDec),
--36      =>to_sfixed (-0.000785, g_fixInt-1,-1*g_fixDec),
--37      =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--38      =>to_sfixed (0.000919, g_fixInt-1,-1*g_fixDec),
--39      =>to_sfixed (0.000614, g_fixInt-1,-1*g_fixDec),
--40      =>to_sfixed (-0.000662, g_fixInt-1,-1*g_fixDec),
--41      =>to_sfixed (-0.001153, g_fixInt-1,-1*g_fixDec),
--42      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--43      =>to_sfixed (0.001334, g_fixInt-1,-1*g_fixDec),
--44      =>to_sfixed (0.000885, g_fixInt-1,-1*g_fixDec),
--45      =>to_sfixed (-0.000949, g_fixInt-1,-1*g_fixDec),
--46      =>to_sfixed (-0.001646, g_fixInt-1,-1*g_fixDec),
--47      =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--48      =>to_sfixed (0.001885, g_fixInt-1,-1*g_fixDec),
--49      =>to_sfixed (0.001245, g_fixInt-1,-1*g_fixDec),
--50      =>to_sfixed (-0.001330, g_fixInt-1,-1*g_fixDec),
--51      =>to_sfixed (-0.002296, g_fixInt-1,-1*g_fixDec),
--52      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--53      =>to_sfixed (0.002608, g_fixInt-1,-1*g_fixDec),
--54      =>to_sfixed (0.001717, g_fixInt-1,-1*g_fixDec),
--55      =>to_sfixed (-0.001827, g_fixInt-1,-1*g_fixDec),
--56      =>to_sfixed (-0.003144, g_fixInt-1,-1*g_fixDec),
--57      =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--58      =>to_sfixed (0.003551, g_fixInt-1,-1*g_fixDec),
--59      =>to_sfixed (0.002330, g_fixInt-1,-1*g_fixDec),
--60      =>to_sfixed (-0.002474, g_fixInt-1,-1*g_fixDec),
--61      =>to_sfixed (-0.004248, g_fixInt-1,-1*g_fixDec),
--62      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--63      =>to_sfixed (0.004778, g_fixInt-1,-1*g_fixDec),
--64      =>to_sfixed (0.003131, g_fixInt-1,-1*g_fixDec),
--65      =>to_sfixed (-0.003319, g_fixInt-1,-1*g_fixDec),
--66      =>to_sfixed (-0.005693, g_fixInt-1,-1*g_fixDec),
--67      =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--68      =>to_sfixed (0.006396, g_fixInt-1,-1*g_fixDec),
--69      =>to_sfixed (0.004190, g_fixInt-1,-1*g_fixDec),
--70      =>to_sfixed (-0.004442, g_fixInt-1,-1*g_fixDec),
--71      =>to_sfixed (-0.007622, g_fixInt-1,-1*g_fixDec),
--72      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--73      =>to_sfixed (0.008581, g_fixInt-1,-1*g_fixDec),
--74      =>to_sfixed (0.005631, g_fixInt-1,-1*g_fixDec),
--75      =>to_sfixed (-0.005983, g_fixInt-1,-1*g_fixDec),
--76      =>to_sfixed (-0.010295, g_fixInt-1,-1*g_fixDec),
--77      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--78      =>to_sfixed (0.011676, g_fixInt-1,-1*g_fixDec),
--79      =>to_sfixed (0.007699, g_fixInt-1,-1*g_fixDec),
--80      =>to_sfixed (-0.008228, g_fixInt-1,-1*g_fixDec),
--81      =>to_sfixed (-0.014251, g_fixInt-1,-1*g_fixDec),
--82      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--83      =>to_sfixed (0.016440, g_fixInt-1,-1*g_fixDec),
--84      =>to_sfixed (0.010957, g_fixInt-1,-1*g_fixDec),
--85      =>to_sfixed (-0.011856, g_fixInt-1,-1*g_fixDec),
--86      =>to_sfixed (-0.020839, g_fixInt-1,-1*g_fixDec),
--87      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--88      =>to_sfixed (0.024962, g_fixInt-1,-1*g_fixDec),
--89      =>to_sfixed (0.017047, g_fixInt-1,-1*g_fixDec),
--90      =>to_sfixed (-0.018994, g_fixInt-1,-1*g_fixDec),
--91      =>to_sfixed (-0.034598, g_fixInt-1,-1*g_fixDec),
--92      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--93      =>to_sfixed (0.045791, g_fixInt-1,-1*g_fixDec),
--94      =>to_sfixed (0.033608, g_fixInt-1,-1*g_fixDec),
--95      =>to_sfixed (-0.041241, g_fixInt-1,-1*g_fixDec),
--96      =>to_sfixed (-0.086071, g_fixInt-1,-1*g_fixDec),
--97      =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--98      =>to_sfixed (0.201639, g_fixInt-1,-1*g_fixDec),
--99      =>to_sfixed (0.374158, g_fixInt-1,-1*g_fixDec),
--100     =>to_sfixed (0.374158, g_fixInt-1,-1*g_fixDec),
--101     =>to_sfixed (0.201639, g_fixInt-1,-1*g_fixDec),
--102     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--103     =>to_sfixed (-0.086071, g_fixInt-1,-1*g_fixDec),
--104     =>to_sfixed (-0.041241, g_fixInt-1,-1*g_fixDec),
--105     =>to_sfixed (0.033608, g_fixInt-1,-1*g_fixDec),
--106     =>to_sfixed (0.045791, g_fixInt-1,-1*g_fixDec),
--107     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--108     =>to_sfixed (-0.034598, g_fixInt-1,-1*g_fixDec),
--109     =>to_sfixed (-0.018994, g_fixInt-1,-1*g_fixDec),
--110     =>to_sfixed (0.017047, g_fixInt-1,-1*g_fixDec),
--111     =>to_sfixed (0.024962, g_fixInt-1,-1*g_fixDec),
--112     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--113     =>to_sfixed (-0.020839, g_fixInt-1,-1*g_fixDec),
--114     =>to_sfixed (-0.011856, g_fixInt-1,-1*g_fixDec),
--115     =>to_sfixed (0.010957, g_fixInt-1,-1*g_fixDec),
--116     =>to_sfixed (0.016440, g_fixInt-1,-1*g_fixDec),
--117     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--118     =>to_sfixed (-0.014251, g_fixInt-1,-1*g_fixDec),
--119     =>to_sfixed (-0.008228, g_fixInt-1,-1*g_fixDec),
--120     =>to_sfixed (0.007699, g_fixInt-1,-1*g_fixDec),
--121     =>to_sfixed (0.011676, g_fixInt-1,-1*g_fixDec),
--122     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--123     =>to_sfixed (-0.010295, g_fixInt-1,-1*g_fixDec),
--124     =>to_sfixed (-0.005983, g_fixInt-1,-1*g_fixDec),
--125     =>to_sfixed (0.005631, g_fixInt-1,-1*g_fixDec),
--126     =>to_sfixed (0.008581, g_fixInt-1,-1*g_fixDec),
--127     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--128     =>to_sfixed (-0.007622, g_fixInt-1,-1*g_fixDec),
--129     =>to_sfixed (-0.004442, g_fixInt-1,-1*g_fixDec),
--130     =>to_sfixed (0.004190, g_fixInt-1,-1*g_fixDec),
--131     =>to_sfixed (0.006396, g_fixInt-1,-1*g_fixDec),
--132     =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--133     =>to_sfixed (-0.005693, g_fixInt-1,-1*g_fixDec),
--134     =>to_sfixed (-0.003319, g_fixInt-1,-1*g_fixDec),
--135     =>to_sfixed (0.003131, g_fixInt-1,-1*g_fixDec),
--136     =>to_sfixed (0.004778, g_fixInt-1,-1*g_fixDec),
--137     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--138     =>to_sfixed (-0.004248, g_fixInt-1,-1*g_fixDec),
--139     =>to_sfixed (-0.002474, g_fixInt-1,-1*g_fixDec),
--140     =>to_sfixed (0.002330, g_fixInt-1,-1*g_fixDec),
--141     =>to_sfixed (0.003551, g_fixInt-1,-1*g_fixDec),
--142     =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--143     =>to_sfixed (-0.003144, g_fixInt-1,-1*g_fixDec),
--144     =>to_sfixed (-0.001827, g_fixInt-1,-1*g_fixDec),
--145     =>to_sfixed (0.001717, g_fixInt-1,-1*g_fixDec),
--146     =>to_sfixed (0.002608, g_fixInt-1,-1*g_fixDec),
--147     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--148     =>to_sfixed (-0.002296, g_fixInt-1,-1*g_fixDec),
--149     =>to_sfixed (-0.001330, g_fixInt-1,-1*g_fixDec),
--150     =>to_sfixed (0.001245, g_fixInt-1,-1*g_fixDec),
--151     =>to_sfixed (0.001885, g_fixInt-1,-1*g_fixDec),
--152     =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--153     =>to_sfixed (-0.001646, g_fixInt-1,-1*g_fixDec),
--154     =>to_sfixed (-0.000949, g_fixInt-1,-1*g_fixDec),
--155     =>to_sfixed (0.000885, g_fixInt-1,-1*g_fixDec),
--156     =>to_sfixed (0.001334, g_fixInt-1,-1*g_fixDec),
--157     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--158     =>to_sfixed (-0.001153, g_fixInt-1,-1*g_fixDec),
--159     =>to_sfixed (-0.000662, g_fixInt-1,-1*g_fixDec),
--160     =>to_sfixed (0.000614, g_fixInt-1,-1*g_fixDec),
--161     =>to_sfixed (0.000919, g_fixInt-1,-1*g_fixDec),
--162     =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--163     =>to_sfixed (-0.000785, g_fixInt-1,-1*g_fixDec),
--164     =>to_sfixed (-0.000448, g_fixInt-1,-1*g_fixDec),
--165     =>to_sfixed (0.000412, g_fixInt-1,-1*g_fixDec),
--166     =>to_sfixed (0.000613, g_fixInt-1,-1*g_fixDec),
--167     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--168     =>to_sfixed (-0.000515, g_fixInt-1,-1*g_fixDec),
--169     =>to_sfixed (-0.000291, g_fixInt-1,-1*g_fixDec),
--170     =>to_sfixed (0.000266, g_fixInt-1,-1*g_fixDec),
--171     =>to_sfixed (0.000392, g_fixInt-1,-1*g_fixDec),
--172     =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--173     =>to_sfixed (-0.000323, g_fixInt-1,-1*g_fixDec),
--174     =>to_sfixed (-0.000181, g_fixInt-1,-1*g_fixDec),
--175     =>to_sfixed (0.000163, g_fixInt-1,-1*g_fixDec),
--176     =>to_sfixed (0.000237, g_fixInt-1,-1*g_fixDec),
--177     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--178     =>to_sfixed (-0.000190, g_fixInt-1,-1*g_fixDec),
--179     =>to_sfixed (-0.000104, g_fixInt-1,-1*g_fixDec),
--180     =>to_sfixed (0.000092, g_fixInt-1,-1*g_fixDec),
--181     =>to_sfixed (0.000132, g_fixInt-1,-1*g_fixDec),
--182     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--183     =>to_sfixed (-0.000101, g_fixInt-1,-1*g_fixDec),
--184     =>to_sfixed (-0.000054, g_fixInt-1,-1*g_fixDec),
--185     =>to_sfixed (0.000047, g_fixInt-1,-1*g_fixDec),
--186     =>to_sfixed (0.000064, g_fixInt-1,-1*g_fixDec),
--187     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--188     =>to_sfixed (-0.000045, g_fixInt-1,-1*g_fixDec),
--189     =>to_sfixed (-0.000023, g_fixInt-1,-1*g_fixDec),
--190     =>to_sfixed (0.000019, g_fixInt-1,-1*g_fixDec),
--191     =>to_sfixed (0.000024, g_fixInt-1,-1*g_fixDec),
--192     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--193     =>to_sfixed (-0.000014, g_fixInt-1,-1*g_fixDec),
--194     =>to_sfixed (-0.000006, g_fixInt-1,-1*g_fixDec),
--195     =>to_sfixed (0.000004, g_fixInt-1,-1*g_fixDec),
--196     =>to_sfixed (0.000004, g_fixInt-1,-1*g_fixDec),
--197     =>to_sfixed (0.000000, g_fixInt-1,-1*g_fixDec),
--198     =>to_sfixed (-0.000001, g_fixInt-1,-1*g_fixDec),
--199     =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec),
--200     =>to_sfixed (-0.000000, g_fixInt-1,-1*g_fixDec)
--);

--End list of coefficients

 
 signal signal_in : sfixed (g_fixInt-1 downto -1*g_fixDec);
 signal signal_out : sfixed (g_fixInt-1 downto -1*g_fixDec);
 signal signal_out_tmp : sfixed (g_fixInt-1 downto -1*g_fixDec);

begin

	Filter_process: process(clk, reset) 
	
	variable myBuffer : IterBuffer;
	variable signal_tmp : sfixed (2*g_fixInt downto -2*g_fixDec);
	
	begin
		if(reset='0') then
			for I in 0 to g_FilterCoef-1 loop
				myBuffer(I):=to_sfixed (0.0, g_fixInt-1,-1*g_fixDec);
			end loop;

		elsif(rising_edge(clk)) then	
		--Do the convolution
		--This part could be piplined for faster operation
			for I in 0 to g_FilterCoef-1 loop
				signal_tmp:=myBuffer(I)+signal_in*Filter(I);
				myBuffer(I):=signal_tmp(g_fixInt-1 downto -1*g_fixDec);
			end loop;
			signal_out_tmp<=myBuffer(0);
			
			for I in 0 to (g_FilterCoef-1)-1 loop--shift the buffer
				myBuffer(I):=myBuffer(1+I);
			end loop;
			
			myBuffer(g_FilterCoef-1):=to_sfixed (0.0, g_fixInt-1,-1*g_fixDec);--Add 0;
			
		end if;
	end process Filter_process;
	
	--Make sure the output comes at the clock edge
	Output_process: process(clk)
	begin
		if(rising_edge(clk)) then
			signal_out<=signal_out_tmp;
		end if;
	end process Output_process;
	
	signal_in<=to_sfixed (signed(signal_in_int), g_fixInt-1,-1*g_fixDec);
	signal_out_int<='0'  &(g_outputBits-2 downto 0 => '1')  when signal_out > 2**(g_outputBits-1) else --max allowed by #bits
						 '1' & (g_outputBits-2 downto 0 => '0') when signal_out < -1*2**(g_outputBits-1) else --min allowed by #bits
						  std_logic_vector(signal_out(g_outputBits-1 downto 0));
end rtl;
