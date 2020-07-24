library ieee;
use ieee.std_logic_1164.all;
entity fast_conv_interweaver is
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
end fast_conv_interweaver;
architecture stru of fast_conv_interweaver is
component fast_conv_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 SEND_CLK:out std_logic;
		 READY:out std_logic;
		 SEND_INFO:out std_logic_vector(12 downto 0));
end component;
component fast_conv_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
begin
	SENDER:fast_conv_sender port map(CLK=>CLK,RST=>SENDER_RST,START=>START,PAUSE=>PAUSE,TO_SEND_DATA=>TO_SEND_DATA,
		   SEND_CLK=>SEND_CLK,READY=>READY,SEND_INFO=>SEND_INFO);
	RECEIVER:fast_conv_receiver port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>RECEIVER_RST,RECEIVE_INFO=>RECEIVE_INFO,
			 RESTORE_CLK=>RESTORE_CLK,EFFECTIVE=>EFFECTIVE,RESTORE_DATA=>RESTORE_DATA);
end stru;