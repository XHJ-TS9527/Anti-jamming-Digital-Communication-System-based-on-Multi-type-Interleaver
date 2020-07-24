library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_oddeven_address_selector is
end tb_oddeven_address_selector;
architecture tb of tb_oddeven_address_selector is
component oddeven_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic; --chip select signal
		 W_address:out std_logic_vector(7 downto 0));
end component;
signal W_CLK,CS:std_logic;
signal guide:std_logic_vector(7 downto 0):="00000000";
signal W_address:std_logic_vector(7 downto 0);
begin
	test_selector:oddeven_address_selector port map(guide=>guide,CS=>CS,W_address=>W_address);
	CLK_process:process
	begin
		W_CLK<='0';
		wait for 100ns;
		W_CLK<='1';
		wait for 100ns;
	end process;
	process(W_CLK)
	begin
		if falling_edge(W_CLK) then
			if (guide="11001011") then
				guide<=(others=>'0');
			else
				guide<=guide+'1';
			end if;
		end if;
	end process;
	CS_process:process
	begin
		CS<='1';
		wait for 980ns;
		CS<='0';
		wait for 300ns;
		CS<='1';
		wait;
	end process;
end tb;