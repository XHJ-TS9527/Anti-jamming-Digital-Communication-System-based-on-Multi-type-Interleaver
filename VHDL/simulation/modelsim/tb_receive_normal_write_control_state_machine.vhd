library ieee;
use ieee.std_logic_1164.all;
entity tb_receive_normal_write_control_state_machine is
end tb_receive_normal_write_control_state_machine;
architecture tb of tb_receive_normal_write_control_state_machine is
component receive_normal_write_control_state_machine is
	port(WCLK:in std_logic;
		 RST:in std_logic;
		 BUFF_LAST_FLAG:in std_logic;
		 BUFF_SEND_FLAG:in std_logic;
		 BUFF_MODE:in std_logic_vector(2 downto 0);
		 write_work:out std_logic;
		 write_chip:out std_logic;
		 out_RST:out std_logic;
		 out_pause:out std_logic;
		 last_write_mode:out std_logic_vector(2 downto 0));
end component;
signal WCLK,RST,BUFF_LAST_FLAG,BUFF_SEND_FLAG,write_work,write_chip,out_RST,out_pause:std_logic;
signal BUFF_MODE,last_write_mode:std_logic_vector(2 downto 0);
begin
	test_state_machine:receive_normal_write_control_state_machine port map(WCLK=>WCLK,RST=>RST,
					   BUFF_LAST_FLAG=>BUFF_LAST_FLAG,BUFF_SEND_FLAG=>BUFF_SEND_FLAG,BUFF_MODE=>BUFF_MODE,
					   write_work=>write_work,write_chip=>write_chip,out_RST=>out_RST,out_pause=>out_pause,
					   last_write_mode=>last_write_mode);
	CLK_process:process
	begin
		WCLK<='0';
		wait for 10ns;
		WCLK<='1';
		wait for 10ns;
	end process;
	RST_process:process
	begin
		RST<='0';
		wait for 1ns;
		RST<='1';
		wait;
	end process;
	BUFF_LAST_FLAG_process:process
	begin
		BUFF_LAST_FLAG<='0';
		wait for 10ns;
		BUFF_LAST_FLAG<='1';
		wait for 20ns;
		BUFF_LAST_FLAG<='0';
		wait;
	end process;
	BUFF_SEND_FLAG_process:process
	begin
		BUFF_SEND_FLAG<='0';
		wait for 10ns;
		BUFF_SEND_FLAG<='1';
		wait;
	end process;
	BUFF_MODE_process:process
	begin
		BUFF_MODE<="000";
		wait for 10ns;
		BUFF_MODE<="110";
		wait for 3600ns;
		BUFF_MODE<="010";
		wait;
	end process;
end tb;