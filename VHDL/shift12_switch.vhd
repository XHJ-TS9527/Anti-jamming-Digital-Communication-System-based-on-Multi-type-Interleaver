library ieee;
use ieee.std_logic_1164.all;
entity shift12_switch is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 IN_BIT:in std_logic;
		 OUT_BIT:out std_logic;
		 CONTENT:out std_logic_vector(11 downto 0));
end shift12_switch;
architecture stru of shift12_switch is
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal cache:std_logic_vector(12 downto 0);
begin
	g:for idx in 0 to 11 generate
		d:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>cache(idx),ENA=>ENA,Q=>cache(idx+1));
	end generate;
	cache(0)<=IN_BIT;
	OUT_BIT<=cache(12);
	CONTENT<=cache(12 downto 1);
end stru;