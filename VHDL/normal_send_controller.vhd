library ieee;
use ieee.std_logic_1164.all;
entity normal_send_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 RAM0_WENA:out std_logic;
		 RAM1_WENA:out std_logic;
		 RAM0_RENA:out std_logic;
		 RAM1_RENA:out std_logic;
		 WR_CLK:out std_logic;
		 RD_CLK:out std_logic;
		 W_WORK:out std_logic;
		 R_WORK:out std_logic;
		 ACCEPT:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 RD_MODE:out std_logic_vector(2 downto 0);
		 interweave_CS:out std_logic_vector(7 downto 0);
		 RD_ADD:out std_logic_vector(7 downto 0);
		 WR_GUIDE:out std_logic_vector(7 downto 0));
end normal_send_controller;
architecture stru of normal_send_controller is
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
signal write_clock,read_clock,write_work,read_work,ram0_w,ram1_w,ram0_r,ram1_r:std_logic;
signal start_flag,pause_flag,write_chip,read_chip,temp_D:std_logic;
signal mode_select,last_write_mode:std_logic_vector(2 downto 0);
begin
	--port map
	RAM0_WENA<=ram0_w;
	RAM1_WENA<=ram1_w;
	RAM0_RENA<=ram0_r;
	RAM1_RENA<=ram1_r;
	WR_CLK<=write_clock;
	RD_CLK<=read_clock;
	write_clock<=CLK;
	read_clock<=not(CLK);
	W_WORK<=write_work;
	R_WORK<=read_work;
	write_control_sm:send_normal_write_control_state_machine port map(WCLK=>write_clock,RST=>RST, start_flag=>start_flag,
					 pause_flag=>pause_flag,mode_select=>mode_select,accept=>ACCEPT,write_work=>write_work,write_chip=>write_chip,
					 last_write_mode=>last_write_mode,now_write_mode=>WR_MODE,interleave_chip_select=>interweave_CS);
	read_control_sm:send_normal_read_control_state_machine port map(RCLK=>read_clock,RST=>RST,write_work=>write_work,
					pause_flag=>pause_flag,last_write_mode=>last_write_mode,read_work=>read_work,
					read_chip=>read_chip,read_mode=>RD_MODE);
	guide:falling_CNT204 port map(CLK=>write_clock,RST=>RST,ENA=>write_work,CNT=>WR_GUIDE);
	read_address:falling_CNT204 port map(CLK=>read_clock,RST=>RST,ENA=>read_work,CNT=>RD_ADD);
	--cache
	temp_D<=not(pause_flag);
	start_button:rising_D_trigger port map(CLK=>START,RST=>RST,D=>'1',ENA=>'1',Q=>start_flag);
	pause_button:rising_D_trigger port map(CLK=>PAUSE,RST=>RST,D=>temp_D,ENA=>start_flag,Q=>pause_flag);
	g:for idx in 0 to 2 generate
		confirm_button:rising_D_trigger port map(CLK=>CONFIRM,RST=>RST,D=>MODE(idx),ENA=>'1',Q=>mode_select(idx));
	end generate;
	--write and read chip
	ram0_w<='1' when write_chip='0' else '0';
	ram1_w<='1' when write_chip='1' else '0';
	ram0_r<='1' when read_chip='0' else '0';
	ram1_r<='1' when read_chip='1' else '0';
end stru;