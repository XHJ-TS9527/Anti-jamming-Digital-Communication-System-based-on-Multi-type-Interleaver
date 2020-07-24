library ieee;
use ieee.std_logic_1164.all;
entity shift11_bark is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 IN_BIT:in std_logic;
		 OUT_BIT:out std_logic;
		 CONTENT:out std_logic_vector(10 downto 0));
end shift11_bark;
architecture behav of shift11_bark is
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal cache:std_logic_vector(11 downto 0);
begin
	cache(0)<=IN_BIT;
	OUT_BIT<=cache(11);
	CONTENT<=cache(11 downto 1);
	g:for idx in 0 to 10 generate
		d:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>cache(idx),ENA=>ENA,Q=>cache(idx+1));
	end generate;
end behav;