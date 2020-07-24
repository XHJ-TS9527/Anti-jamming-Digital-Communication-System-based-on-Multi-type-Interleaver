library ieee;
use ieee.std_logic_1164.all;
entity tb_normal_receive_controller is
end tb_normal_receive_controller;
architecture tb of tb_normal_receive_controller is
component normal_receive_controller is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_SEND_FLAG:in std_logic;
		 RECEIVE_LAST_FLAG:in std_logic;
		 RECEIVE_MODE:in std_logic_vector(2 downto 0);
		 WCLK:out std_logic;
		 RCLK:out std_logic;
		 RAM0_WENA:out std_logic;
		 RAM1_WENA:out std_logic;
		 RAM0_RENA:out std_logic;
		 RAM1_RENA:out std_logic;
		 write_work:out std_logic;
		 read_work:out std_logic;
		 read_mode:out std_logic_vector(2 downto 0);
		 write_address:out std_logic_vector(7 downto 0);
		 read_guide:out std_logic_vector(7 downto 0);
		 CS:out std_logic_vector(7 downto 0));
end component;
signal RECEIVE_CLK,RST,RECEIVE_SEND_FLAG,RECEIVE_LAST_FLAG,WCLK,RCLK,RAM0_WENA,RAM1_WENA,RAM0_RENA,RAM1_RENA:std_logic;
signal write_work,read_work:std_logic;
signal RECEIVE_MODE,read_mode:std_logic_vector(2 downto 0);
signal write_address,read_guide,CS:std_logic_vector(7 downto 0);
begin
	test_controller:normal_receive_controller port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>RST,RECEIVE_SEND_FLAG=>RECEIVE_SEND_FLAG,
					RECEIVE_LAST_FLAG=>RECEIVE_LAST_FLAG,RECEIVE_MODE=>RECEIVE_MODE,WCLK=>WCLK,RCLK=>RCLK,RAM0_WENA=>RAM0_WENA,
					RAM1_WENA=>RAM1_WENA,RAM0_RENA=>RAM0_RENA,RAM1_RENA=>RAM1_RENA,write_work=>write_work,read_work=>read_work,
					read_mode=>read_mode,write_address=>write_address,read_guide=>read_guide,CS=>CS);
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
	RECEIVE_SEND_FLAG_process:process
	begin
		RECEIVE_SEND_FLAG<='0';
		wait for 20ns;
		RECEIVE_SEND_FLAG<='1';
		wait;
	end process;
	RECEIVE_LAST_FLAG_process:process
	begin
		RECEIVE_LAST_FLAG<='0';
		wait for 20ns;
		RECEIVE_LAST_FLAG<='1';
		wait for 20ns;
		RECEIVE_LAST_FLAG<='0';
		wait;
	end process;
	RECEIVE_MODE_PROCESS:process
	begin
		RECEIVE_MODE<="001";
		wait for 20ns;
		RECEIVE_MODE<="110";
		wait for 3600ns;
		RECEIVE_MODE<="000";
		wait;
	end process;
end tb;