library ieee;
use ieee.std_logic_1164.all;
entity tb_fast_conv_send_controller is
end tb_fast_conv_send_controller;
architecture tb of tb_fast_conv_send_controller is
component fast_conv_send_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 start_flag:in std_logic;
		 pause_flag:in std_logic;
		 ACCEPT:out std_logic;
		 WORKING:out std_logic;
		 FOR_SELECT:out std_logic);
end component;
signal CLK,RST,start_flag,pause_flag,ACCEPT,WORKING,FOR_SELECT:std_logic;
begin
	test_state_machine:fast_conv_send_controller port map(CLK=>CLK,RST=>RST,start_flag=>start_flag,pause_flag=>pause_flag,
					   ACCEPT=>ACCEPT,WORKING=>WORKING,FOR_SELECT=>FOR_SELECT);
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
	start_flag_process:process
	begin
		start_flag<='0';
		wait for 3ns;
		start_flag<='1';
		wait;
	end process;
	pause_flag_process:process
	begin
		pause_flag<='0';
		wait;
	end process;
end tb;