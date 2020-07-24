library ieee;
use ieee.std_logic_1164.all;
entity single_m_sequence31 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 IN_BIT:in std_logic;
		 M:out std_logic);
end single_m_sequence31;
architecture stru of single_m_sequence31 is
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal cache:std_logic_vector(0 to 5);
signal feedback:std_logic;
begin
	g:for idx in 0 to 4 generate
		d:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>cache(idx),ENA=>'1',Q=>cache(idx+1));
	end generate;
	cache(0)<=IN_BIT or feedback;
	M<=cache(5);
	feedback<=cache(1) xor cache(2) xor cache(3) xor cache(5);
end stru;