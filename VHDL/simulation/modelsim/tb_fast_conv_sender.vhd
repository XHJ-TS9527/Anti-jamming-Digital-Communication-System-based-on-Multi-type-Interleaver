library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_fast_conv_sender is
end tb_fast_conv_sender;
architecture tb of tb_fast_conv_sender is
component fast_conv_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 SEND_CLK:out std_logic;
		 READY:out std_logic;
		 SEND_INFO:out std_logic_vector(12 downto 0));
end component;
signal CLK,RST,START,PAUSE,SEND_CLK,READY:std_logic;
signal TO_SEND_DATA:std_logic_vector(7 downto 0):=(others=>'0');
signal SEND_INFO:std_logic_vector(12 downto 0);
begin
	test_sender:fast_conv_sender port map(CLK=>CLK,RST=>RST,START=>START,PAUSE=>PAUSE,TO_SEND_DATA=>TO_SEND_DATA,
				SEND_CLK=>SEND_CLK,READY=>READY,SEND_INFO=>SEND_INFO);
	CLK_process:process
	begin
		CLK<='0';
		wait for 10ns;
		CLK<='1';
		wait for 10ns;
	end process;
	RST_process:process
	begin
		RST<='0';
		wait for 1ns;
		RST<='1';
		wait;
	end process;
	PAUSE_process:process
	begin
		PAUSE<='1';
		wait;
	end process;
	START_process:process
	begin
		START<='1';
		wait for 2ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait;
	end process;
	TO_SEND_DATA_process:process(CLK)
	begin
		if falling_edge(CLK) then
			if (READY='1') then TO_SEND_DATA<=TO_SEND_DATA+'1';
			else TO_SEND_DATA<=TO_SEND_DATA;
			end if;
		end if;
	end process;
end tb;