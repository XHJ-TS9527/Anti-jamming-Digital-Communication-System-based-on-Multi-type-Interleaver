library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_normal_sender is
end tb_normal_sender;
architecture tb of tb_normal_sender is
component normal_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 SEND_CLK:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 SEND_INFO:out std_logic_vector(12 downto 0));
end component;
signal CLK,RST,START,PAUSE,CONFIRM,READY,SEND_CLK:std_logic;
signal MODE,WR_MODE:std_logic_vector(2 downto 0);
signal TO_SEND_DATA:std_logic_vector(7 downto 0):="11001011";
signal SEND_INFO:std_logic_vector(12 downto 0);
begin
	test_component:normal_sender port map(CLK=>CLK,RST=>RST,START=>START,PAUSE=>PAUSE,CONFIRM=>CONFIRM,
				   MODE=>MODE,TO_SEND_DATA=>TO_SEND_DATA,READY=>READY,SEND_CLK=>SEND_CLK,WR_MODE=>WR_MODE,
				   SEND_INFO=>SEND_INFO);
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
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 2500ns;
		MODE<="010";
		wait for 5ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait for 3000ns;
		MODE<="101";
		wait for 5ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait;
	end process;
	START_process:process
	begin
		START<='1';
		wait for 11ns;
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
	TO_SEND_DATA_process:process(RST,CLK)
	begin
		if falling_edge(CLK) then
			if (READY='1') then 
				if (TO_SEND_DATA="11001011") then TO_SEND_DATA<=(others=>'0');
				else TO_SEND_DATA<=TO_SEND_DATA+'1';
				end if;
			else TO_SEND_DATA<=TO_SEND_DATA;
			end if;
		end if;
	end process;
end tb;