library ieee;
use ieee.std_logic_1164.all;
entity normal_receive_controller is
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
		 out_reset:out std_logic;
		 read_mode:out std_logic_vector(2 downto 0);
		 write_address:out std_logic_vector(7 downto 0);
		 read_guide:out std_logic_vector(7 downto 0);
		 CS:out std_logic_vector(7 downto 0));
end normal_receive_controller;
architecture stru of normal_receive_controller is
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
component receive_normal_read_control_state_machine is
	port(RCLK:in std_logic;
		 RST:in std_logic;
		 write_work:in std_logic;
		 pause_flag:in std_logic;
		 last_write_mode:in std_logic_vector(2 downto 0);
		 read_work:out std_logic;
		 read_chip:out std_logic;
		 read_mode:out std_logic_vector(2 downto 0);
		 interweave_CS:out std_logic_vector(7 downto 0));
end component;
component falling_CNT204 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 CNT:out std_logic_vector(7 downto 0));
end component;
component rising_D_trigger is
port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal write_CLK,read_CLK,pause_flag,w_work,r_work,reset_flag,buff_last_flag,buff_send_flag,write_chip,read_chip:std_logic;
signal buff_mode,last_write_mode:std_logic_vector(2 downto 0);
begin
	--port map
	WCLK<=write_CLK;
	RCLK<=read_CLK;
	write_CLK<=RECEIVE_CLK;
	read_CLK<=not(RECEIVE_CLK);
	write_work<=w_work;
	read_work<=r_work;
	out_reset<=reset_flag;
	write_sm:receive_normal_write_control_state_machine port map(WCLK=>write_CLK,RST=>RST,BUFF_LAST_FLAG=>buff_last_flag,
			 BUFF_SEND_FLAG=>buff_send_flag,BUFF_MODE=>buff_mode,write_work=>w_work,write_chip=>write_chip,
			 out_RST=>reset_flag,out_pause=>pause_flag,last_write_mode=>last_write_mode);
	read_sm:receive_normal_read_control_state_machine port map(RCLK=>read_CLK,RST=>reset_flag,write_work=>w_work,
			pause_flag=>pause_flag,last_write_mode=>last_write_mode,read_work=>r_work,read_chip=>read_chip,
			read_mode=>read_mode,interweave_CS=>CS);
	write_add:falling_CNT204 port map(CLK=>write_CLK,RST=>reset_flag,ENA=>w_work,CNT=>write_address);
	read_gui:falling_CNT204 port map(CLK=>read_CLK,RST=>reset_flag,ENA=>r_work,CNT=>read_guide);
	RAM0_WENA<='1' when (write_chip='0') else '0';
	RAM1_WENA<='1' when (write_chip='1') else '0';
	RAM0_RENA<='1' when (read_chip='0') else '0';
	RAM1_RENA<='1' when (read_chip='1') else '0';
	--cache
	cache_send_flag:rising_D_trigger port map(CLK=>RECEIVE_CLK,RST=>RST,D=>RECEIVE_SEND_FLAG,ENA=>'1',Q=>buff_send_flag);
	cache_last_flag:rising_D_trigger port map(CLK=>RECEIVE_CLK,RST=>RST,D=>RECEIVE_LAST_FLAG,ENA=>'1',Q=>buff_last_flag);
	g:for idx in 0 to 2 generate
		cache_mode:rising_D_trigger port map(CLK=>RECEIVE_CLK,RST=>RST,D=>RECEIVE_MODE(idx),ENA=>'1',Q=>buff_mode(idx));
	end generate;
end stru;