library ieee;
use ieee.std_logic_1164.all;
entity rising_CNT204 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 CNT:out std_logic_vector(7 downto 0));
end rising_CNT204;
architecture stru of rising_CNT204 is
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal Qs,Ds:std_logic_vector(7 downto 0);
signal cache:std_logic_vector(6 downto 0);
signal CNT_end:std_logic;
begin
	CNT<=Qs;
	g0:for idx in 0 to 7 generate
		d:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>Ds(idx),ENA=>ENA,Q=>Qs(idx));
	end generate;
	CNT_end<=not(Qs(7) and Qs(6) and Qs(3) and Qs(1) and Qs(0));
	cache(0)<=Qs(0);
	g1:for idx in 1 to 6 generate
		cache(idx)<=cache(idx-1) and Qs(idx);
	end generate;
	Ds(0)<=not(Qs(0));
	Ds(1)<=Qs(1) xor cache(0);
	Ds(2)<=(Qs(2) xor cache(1)) and CNT_end;
	Ds(3)<=(Qs(3) xor cache(2)) and CNT_end;
	Ds(4)<=Qs(4) xor cache(3);
	Ds(5)<=Qs(5) xor cache(4);
	Ds(6)<=(Qs(6) xor cache(5)) and CNT_end;
	Ds(7)<=(Qs(7) xor cache(6)) and CNT_end;
end stru;