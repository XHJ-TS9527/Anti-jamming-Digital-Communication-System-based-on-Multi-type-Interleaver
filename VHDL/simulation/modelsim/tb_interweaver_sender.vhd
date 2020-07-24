library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_interweaver_sender is
end tb_interweaver_sender;
architecture tb of tb_interweaver_sender is
component interweaver_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONV_SELECT:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 SEND_CLK:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 SEND_INFO:out std_logic_vector(13 downto 0));
end component;
signal CLK,RST,START,PAUSE,CONV_SELECT,CONFIRM,READY,SEND_CLK:std_logic;
signal MODE,WR_MODE:std_logic_vector(2 downto 0);
signal TO_SEND_DATA:std_logic_vector(7 downto 0):=(others=>'0');
signal SEND_INFO:std_logic_vector(13 downto 0);
begin
	test_component:interweaver_sender port map(CLK=>CLK,RST=>RST,START=>START,PAUSE=>PAUSE,CONV_SELECT=>CONV_SELECT,
				   CONFIRM=>CONFIRM,MODE=>MODE,TO_SEND_DATA=>TO_SEND_DATA,READY=>READY,SEND_CLK=>SEND_CLK,WR_MODE=>WR_MODE,
				   SEND_INFO=>SEND_INFO);
	CLK_process:process
	begin
		CLK<='0';
		wait for 20ns;
		CLK<='1';
		wait for 20ns;
	end process;
	RST_process:process
	begin
		RST<='0';
		wait for 1ns;
		RST<='1';
		wait;
	end process;
	CONV_SELECT_process:process
	begin
		CONV_SELECT<='0';
		wait for 3ns;
		CONV_SELECT<='1';
		wait;
	end process;
	CONFIRM_process:process
	begin
		CONFIRM<='1';
		wait for 7ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait;
	end process;
	MODE_process:process
	begin
		MODE<=(others=>'0');
		wait;
	end process;
	START_process:process
	begin
		START<='1';
		wait for 22ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait;
	end process;
	PAUSE_process:process
	begin
		PAUSE<='1';
		wait for 206ns;
		PAUSE<='0';
		wait for 1ns;
		PAUSE<='1';
		wait for 80ns;
		PAUSE<='0';
		wait for 1ns;
		PAUSE<='1';
		wait;
	end process;
	TO_SEND_DATA_process:process(CLK)
	begin
		if falling_edge(CLK) then
			if (READY='1') then TO_SEND_DATA<=TO_SEND_DATA+'1';
			else TO_SEND_DATA<=TO_SEND_DATA;
			end if;
		end if;
	end process;
end tb;