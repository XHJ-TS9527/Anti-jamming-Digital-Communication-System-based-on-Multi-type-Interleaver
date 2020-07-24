library ieee;
use ieee.std_logic_1164.all;
entity tb_send_normal_write_control_state_machine is
end tb_send_normal_write_control_state_machine;
architecture tb of tb_send_normal_write_control_state_machine is
component send_normal_write_control_state_machine is
	port(WCLK:in std_logic;
		 RST:in std_logic;
		 start_flag:in std_logic;
		 pause_flag:in std_logic;
		 mode_select:in std_logic_vector(2 downto 0);
		 accept:out std_logic;
		 write_work:out std_logic;
		 write_chip:out std_logic;
		 last_write_mode:out std_logic_vector(2 downto 0);
		 now_write_mode:out std_logic_vector(2 downto 0);
		 interleave_chip_select:out std_logic_vector(7 downto 0));
end component;
signal WCLK,RST,start_flag,pause_flag,accept,write_work,write_chip:std_logic;
signal mode_select,last_write_mode,now_write_mode:std_logic_vector(2 downto 0);
signal interleave_chip_select:std_logic_vector(7 downto 0);
begin
	test_state_machine:send_normal_write_control_state_machine port map(WCLK=>WCLK,RST=>RST,start_flag=>start_flag,
					   pause_flag=>pause_flag,mode_select=>mode_select,accept=>accept,write_work=>write_work,
					   write_chip=>write_chip,last_write_mode=>last_write_mode,now_write_mode=>now_write_mode,
					   interleave_chip_select=>interleave_chip_select);
	CLK_process:process
	begin
		WCLK<='1';
		wait for 10ns;
		WCLK<='0';
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
		wait for 12ns;
		start_flag<='1';
		wait;
	end process;
	pause_flag_process:process
	begin
		pause_flag<='0';
		wait;
	end process;
	mode_select_process:process
	begin
		mode_select<="111";
		wait for 2000ns;
		mode_select<="010";
		wait for 3000ns;
		mode_select<="101";
		wait;
	end process;
end tb;