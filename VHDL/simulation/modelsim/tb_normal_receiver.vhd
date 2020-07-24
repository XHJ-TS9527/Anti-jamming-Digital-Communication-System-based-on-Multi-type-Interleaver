library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_normal_receiver is
end tb_normal_receiver;
architecture tb of tb_normal_receiver is
component normal_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
signal RECEIVE_CLK,RST,RESTORE_CLK,EFFECTIVE,LAST_FLAG,SEND_FLAG:std_logic;
signal INTERWEAVE_MODE,RECEIVE_MODE:std_logic_vector(2 downto 0);
signal RECEIVE_DATA:std_logic_vector(7 downto 0):=(others=>'0');
signal RESTORE_DATA:std_logic_vector(7 downto 0);
signal RECEIVE_INFO:std_logic_vector(12 downto 0);
begin
	test_component:normal_receiver port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>RST,RECEIVE_INFO=>RECEIVE_INFO,
				   RESTORE_CLK=>RESTORE_CLK,EFFECTIVE=>EFFECTIVE,INTERWEAVE_MODE=>INTERWEAVE_MODE,
				   RESTORE_DATA=>RESTORE_DATA);
	RECEIVE_INFO<=LAST_FLAG&SEND_FLAG&RECEIVE_MODE&RECEIVE_DATA;
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
	LAST_FLAG_process:process
	begin
		LAST_FLAG<='0';
		wait for 20ns;
		LAST_FLAG<='1';
		wait for 20ns;
		LAST_FLAG<='0';
		wait;
	end process;
	RECEIVE_MODE_process:process
	begin
		RECEIVE_MODE<="001";
		wait for 3600ns;
		RECEIVE_MODE<="010";
		wait for 3600ns;
		RECEIVE_MODE<="101";
		wait;
	end process;
	SEND_FLAG_process:process
	begin
		SEND_FLAG<='0';
		wait for 20ns;
		SEND_FLAG<='1';
		wait;
	end process;
	SEND_DATA_process:process(RECEIVE_CLK)
	begin
		if rising_edge(RECEIVE_CLK) then RECEIVE_DATA<=RECEIVE_DATA+'1';
		end if;
	end process;
end tb;