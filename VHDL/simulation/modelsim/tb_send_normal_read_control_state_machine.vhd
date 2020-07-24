library ieee;
use ieee.std_logic_1164.all;
entity tb_send_normal_read_control_state_machine is
end tb_send_normal_read_control_state_machine;
architecture tb of tb_send_normal_read_control_state_machine is
component send_normal_read_control_state_machine is
	port(RCLK:in std_logic;
		 RST:in std_logic;
		 write_work:in std_logic;
		 pause_flag:in std_logic;
		 last_write_mode:in std_logic_vector(2 downto 0);
		 read_work:out std_logic;
		 read_chip:out std_logic;
		 read_mode:out std_logic_vector(2 downto 0));
end component;
signal RCLK,RST,write_work,pause_flag,read_work,read_chip:std_logic;
signal last_write_mode,read_mode:std_logic_vector(2 downto 0);
begin
	test_state_machine:send_normal_read_control_state_machine port map(RCLK=>RCLK,RST=>RST,write_work=>write_work,
					   pause_flag=>pause_flag,last_write_mode=>last_write_mode,read_work=>read_work,read_chip=>read_chip,
					   read_mode=>read_mode);
	CLK_process:process
	begin
		RCLK<='1';
		wait for 10ns;
		RCLK<='0';
		wait for 10ns;
	end process;
	RST_process:process
	begin
		RST<='0';
		wait for 1ns;
		RST<='1';
		wait;
	end process;
	pause_flag_process:process
	begin
		pause_flag<='0';
		wait;
	end process;
	write_work_process:process
	begin
		write_work<='0';
		wait for 20ns;
		write_work<='1';
		wait;
	end process;
	last_write_mode_process:process
	begin
		last_write_mode<="101";
		wait for 3000ns;
		last_write_mode<="010";
		wait for 3000ns;
		last_write_mode<="110";
		wait;
	end process;
end tb;