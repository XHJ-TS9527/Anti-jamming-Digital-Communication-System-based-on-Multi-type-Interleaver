library ieee;
library lpm;
use ieee.std_logic_1164.all;
use lpm.lpm_components.all;
entity CLK_MUX is
	port(data0:in std_logic;
		 data1:in std_logic;
		 sel:in std_logic;
		 result:out std_logic);
end CLK_MUX;
architecture stru of CLK_MUX is
signal sub_wire0,sub_wire1:std_logic_vector(0 downto 0);
signal sub_wire2:STD_LOGIC_2D(1 downto 0,0 downto 0);
begin
	result<=sub_wire0(0);
	sub_wire1(0)<=sel;
	sub_wire2(1,0)<=data1;
	sub_wire2(0,0)<=data0;
	lpm_mux_component:lpm_mux
		generic map(lpm_size=>2,lpm_type=>"LPM_MUX",lpm_width=>1,lpm_widths=>1)
		port map(sel=>sub_wire1,data=>sub_wire2,result=>sub_wire0);
end stru;