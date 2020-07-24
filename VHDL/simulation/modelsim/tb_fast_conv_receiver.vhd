library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_fast_conv_receiver is
end tb_fast_conv_receiver;
architecture tb of tb_fast_conv_receiver is
component fast_conv_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
signal RECEIVE_CLK,RST,RESTORE_CLK,EFFECTIVE:std_logic;
signal RECEIVE_INFO:std_logic_vector(12 downto 0);
signal RESTORE_DATA:std_logic_vector(7 downto 0);
signal DATA:std_logic_vector(7 downto 0):=(others=>'0');
begin
	test_component:fast_conv_receiver port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>RST,RECEIVE_INFO=>RECEIVE_INFO,
				   RESTORE_CLK=>RESTORE_CLK,EFFECTIVE=>EFFECTIVE,RESTORE_DATA=>RESTORE_DATA);
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
	RECEIVE_INFO<="11110"&DATA;
	DATA_process:process(RECEIVE_CLK)
	begin
		if rising_edge(RECEIVE_CLK) then DATA<=DATA+'1';
		end if;
	end process;
end tb;