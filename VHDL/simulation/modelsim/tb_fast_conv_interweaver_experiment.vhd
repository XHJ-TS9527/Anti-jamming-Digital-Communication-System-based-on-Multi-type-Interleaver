library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_fast_conv_interweaver_experiment is
end tb_fast_conv_interweaver_experiment;
architecture tb of tb_fast_conv_interweaver_experiment is
component fast_conv_interweaver_experiment is
	port(CLK:in std_logic;
		 SENDER_RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 RECEIVER_RST:in std_logic;
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
signal CLK,SENDER_RST,START,PAUSE,READY,RECEIVER_RST,RESTORE_CLK,EFFECTIVE:std_logic;
signal RESTORE_DATA:std_logic_vector(7 downto 0);
signal TO_SEND_DATA:std_logic_vector(7 downto 0):=(others=>'0');
begin
	test_component:fast_conv_interweaver_experiment port map(CLK=>CLK,SENDER_RST=>SENDER_RST,START=>START,
				   PAUSE=>PAUSE,TO_SEND_DATA=>TO_SEND_DATA,READY=>READY,RECEIVER_RST=>RECEIVER_RST,RESTORE_CLK=>RESTORE_CLK,
				   EFFECTIVE=>EFFECTIVE,RESTORE_DATA=>RESTORE_DATA);
	CLK_process:process
	begin
		CLK<='0';
		wait for 10ns;
		CLK<='1';
		wait for 10ns;
	end process;
	RST_process:process
	begin
		SENDER_RST<='0';
		RECEIVER_RST<='0';
		wait for 1ns;
		SENDER_RST<='1';
		RECEIVER_RST<='1';
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