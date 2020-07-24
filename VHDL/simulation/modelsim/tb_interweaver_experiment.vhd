library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_interweaver_experiment is
end tb_interweaver_experiment;
architecture tb of tb_interweaver_experiment is
component interweaver_experiment is
	port(CLK:in std_logic;
		 SENDER_RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONV_SELECT:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 RECEIVER_RST:in std_logic;
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 FAST_CONV_FLAG:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
signal CLK,SENDER_RST,START,PAUSE,CONV_SELECT,CONFIRM,READY,RECEIVER_RST,RESTORE_CLK,EFFECTIVE,FAST_CONV_FLAG:std_logic;
signal MODE,WR_MODE,INTERWEAVE_MODE:std_logic_vector(2 downto 0);
signal RESTORE_DATA:std_logic_vector(7 downto 0);
signal TO_SEND_DATA:std_logic_vector(7 downto 0):=(others=>'0');
begin
	test_component:interweaver_experiment port map(CLK=>CLK,SENDER_RST=>SENDER_RST,START=>START,PAUSE=>PAUSE,
				   CONV_SELECT=>CONV_SELECT,CONFIRM=>CONFIRM,MODE=>MODE,TO_SEND_DATA=>TO_SEND_DATA,READY=>READY,
				   WR_MODE=>WR_MODE,RECEIVER_RST=>RECEIVER_RST,RESTORE_CLK=>RESTORE_CLK,EFFECTIVE=>EFFECTIVE,
				   FAST_CONV_FLAG=>FAST_CONV_FLAG,INTERWEAVE_MODE=>INTERWEAVE_MODE,RESTORE_DATA=>RESTORE_DATA);
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
		wait for 49999ns;
		SENDER_RST<='0';
		RECEIVER_RST<='0';
		wait for 1ns;
		SENDER_RST<='1';
		RECEIVER_RST<='1';
		wait;
	end process;
	MODE_select_process:process
	begin
		CONV_SELECT<='0';
		MODE<="000";
		CONFIRM<='1';
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 2030ns;
		MODE<="001";
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 4060ns;
		MODE<="010";
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 4060ns;
		MODE<="011";
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 4060ns;
		MODE<="100";
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 4060ns;
		MODE<="101";
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 4060ns;
		MODE<="110";
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 4060ns;
		MODE<="111";
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait until (SENDER_RST='0');
		CONV_SELECT<='1';
		wait for 2ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait;
	end process;
	START_process:process
	begin
		START<='1';
		wait for 7ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait for 50000ns;
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
	TO_SEND_DATA_process:process(SENDER_RST,CLK)
	begin
		if (SENDER_RST='0') then TO_SEND_DATA<=(others=>'0');
		elsif falling_edge(CLK) then
			if (READY='1') then TO_SEND_DATA<=TO_SEND_DATA+'1';
			else TO_SEND_DATA<=TO_SEND_DATA;
			end if;
		end if;
	end process;
end tb;