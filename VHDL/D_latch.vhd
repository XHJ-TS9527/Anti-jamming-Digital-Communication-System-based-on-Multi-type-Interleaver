library ieee;
use ieee.std_logic_1164.all;
entity D_latch is
	port(D:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end D_latch;
architecture behav of D_latch is
signal cache:std_logic;
begin
	Q<=cache;
	Qbar<=not(cache);
	process(RST,ENA,D)
	begin
		if (RST='0') then cache<='0';
		elsif (ENA='1') then cache<=D;
		else cache<=cache;
		end if;
	end process;
end behav;