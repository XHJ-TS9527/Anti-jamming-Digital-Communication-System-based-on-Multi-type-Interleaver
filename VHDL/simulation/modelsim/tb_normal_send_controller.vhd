library ieee;
use ieee.std_logic_1164.all;
entity tb_normal_send_controller is
end tb_normal_send_controller;
architecture tb of tb_normal_send_controller is
component normal_send_controller is
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
end component;
signal CLK,RST,START,PAUSE,CONFIRM,RAM0_WENA,RAM1_WENA,RAM0_RENA,RAM1_RENA,WR_CLK,RD_CLK,ACCEPT,W_WORK,R_WORK:std_logic;
signal MODE,WR_MODE,RD_MODE:std_logic_vector(2 downto 0);
signal interweave_CS,RD_ADD,WR_GUIDE:std_logic_vector(7 downto 0);
begin
	test_controller:normal_send_controller port map(CLK=>CLK,RST=>RST,START=>START,PAUSE=>PAUSE,CONFIRM=>CONFIRM,
					MODE=>MODE,RAM0_WENA=>RAM0_WENA,RAM1_WENA=>RAM1_WENA,RAM0_RENA=>RAM0_RENA,RAM1_RENA=>RAM1_RENA,
					WR_CLK=>WR_CLK,RD_CLK=>RD_CLK,ACCEPT=>ACCEPT,W_WORK=>W_WORK,R_WORK=>R_WORK,WR_MODE=>WR_MODE,
					RD_MODE=>RD_MODE,interweave_CS=>interweave_CS,RD_ADD=>RD_ADD,WR_GUIDE=>WR_GUIDE);
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
	MODE_select_process:process
	begin
		MODE<="110";
		CONFIRM<='1';
		wait for 5ns;
		MODE<="110";
		CONFIRM<='0';
		wait for 1ns;
		MODE<="110";
		CONFIRM<='1';
		wait for 3000ns;
		MODE<="010";
		CONFIRM<='1';
		wait for 1ns;
		MODE<="010";
		CONFIRM<='0';
		wait for 1ns;
		MODE<="010";
		CONFIRM<='1';
		wait;
	end process;
	START_process:process
	begin
		START<='1';
		wait for 25ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait;
	end process;
	PAUSE_process:process
	begin
		PAUSE<='1';
		wait;
	end process;
end tb;