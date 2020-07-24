library ieee;
use ieee.std_logic_1164.all;
entity fast_conv_interweaver_experiment is
	port(CLK:in std_logic;
		 SENDER_RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 RECEIVER_RST:in std_logic;
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end fast_conv_interweaver_experiment;
architecture stru of fast_conv_interweaver_experiment is
component fast_conv_interweaver is
	port(CLK:in std_logic;
		 SENDER_RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 SEND_CLK:out std_logic;
		 READY:out std_logic;
		 SEND_INFO:out std_logic_vector(12 downto 0);
		 RECEIVE_CLK:in std_logic;
		 RECEIVER_RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
signal MID_CLK:std_logic;
signal MID_INFO:std_logic_vector(12 downto 0);
begin
	test_component:fast_conv_interweaver port map(CLK=>CLK,SENDER_RST=>SENDER_RST,START=>START,PAUSE=>PAUSE,
				   TO_SEND_DATA=>TO_SEND_DATA,SEND_CLK=>MID_CLK,READY=>READY,SEND_INFO=>MID_INFO,RECEIVE_CLK=>MID_CLK,
				   RECEIVER_RST=>RECEIVER_RST,RECEIVE_INFO=>MID_INFO,RESTORE_CLK=>RESTORE_CLK,EFFECTIVE=>EFFECTIVE,
				   RESTORE_DATA=>RESTORE_DATA);
end stru;