library ieee;
use ieee.std_logic_1164.all;
entity tb_fast_conv_receive_controller is
end tb_fast_conv_receive_controller;
architecture tb of tb_fast_conv_receive_controller is
component fast_conv_receive_controller is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 receive_pause_flag:in std_logic;
		 receive_ctrl_bit:in std_logic;
		 work_flag:out std_logic;
		 EFFECTIVE:out std_logic;
		 for_select:out std_logic);
end component;
signal RECEIVE_CLK,RST,receive_pause_flag,receive_ctrl_bit,work_flag,EFFECTIVE,for_select:std_logic;
begin
	test_state_machine:fast_conv_receive_controller port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>RST,
					   receive_pause_flag=>receive_pause_flag,receive_ctrl_bit=>receive_ctrl_bit,
					   work_flag=>work_flag,EFFECTIVE=>EFFECTIVE,for_select=>for_select);
	CLK_process:process
	begin
		RECEIVE_CLK<='0';
		wait for 10ns;
		RECEIVE_CLK<='1';
		wait for 10ns;
	end process;
	RST_process:process
	begin
		RST<='0';
		wait for 1ns;
		RST<='1';
		wait;
	end process;
	receive_pause_flag_process:process
	begin
		receive_pause_flag<='0';
		wait;
	end process;
	receive_ctrl_bit_process:process
	begin
		receive_ctrl_bit<='0';
		wait for 10ns;
		receive_ctrl_bit<='1';
		wait for 20ns;
		receive_ctrl_bit<='0';
		wait;
	end process;
end tb;