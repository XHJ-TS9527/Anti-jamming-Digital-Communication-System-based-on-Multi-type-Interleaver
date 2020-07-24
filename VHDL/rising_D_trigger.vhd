library ieee;
use ieee.std_logic_1164.all;
entity rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end rising_D_trigger;
architecture behav of rising_D_trigger is
signal cache:std_logic;
begin
	Q<=cache;
	Qbar<=not(cache);
	process(RST,CLK)
	begin
		if (RST='0') then cache<='0';
		elsif rising_edge(CLK) then
			if (ENA='1') then cache<=D;
			else cache<=cache;
			end if;
		end if;
	end process;
end behav;