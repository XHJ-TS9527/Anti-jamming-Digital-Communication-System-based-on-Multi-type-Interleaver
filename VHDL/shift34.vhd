library ieee;
library altera_mf;
use ieee.std_logic_1164.all;
USE altera_mf.all;
entity shift34 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end shift34;
architecture stru of shift34 is
component altshift_taps is
	generic(lpm_hint:string;
			lpm_type:string;
			number_of_taps:natural;
			tap_distance:natural;
			width:natural);
	port(taps:out std_logic_vector(7 downto 0);
		 clken:in std_logic;
		 aclr:in std_logic;
		 clock:in std_logic;
		 shiftout:out std_logic_vector(7 downto 0);
		 shiftin:in std_logic_vector(7 downto 0));
end component;
begin
	altshift_taps_component:altshift_taps
	generic map(lpm_hint=>"RAM_BLOCK_TYPE=AUTO",lpm_type=>"altshift_taps",number_of_taps=>1,tap_distance=>34,width=>8)
	port map(clken=>ENA,aclr=>CLR,clock=>CLK,shiftin=>IN_DATA,shiftout=>OUT_DATA);
end stru;