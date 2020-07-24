library ieee;
use ieee.std_logic_1164.all;
entity normal_interweaver is
	port(CLK:in std_logic;
		 SENDER_RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 SEND_CLK:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 SEND_INFO:out std_logic_vector(12 downto 0);
		 RECEIVE_CLK:in std_logic;
		 RECEIVER_RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end normal_interweaver;
architecture stru of normal_interweaver is
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
component normal_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
begin
	SENDER:normal_sender port map(CLK=>CLK,RST=>SENDER_RST,START=>START,PAUSE=>PAUSE,CONFIRM=>CONFIRM,MODE=>MODE,
		   TO_SEND_DATA=>TO_SEND_DATA,READY=>READY,SEND_CLK=>SEND_CLK,WR_MODE=>WR_MODE,SEND_INFO=>SEND_INFO);
	RECEIVER:normal_receiver port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>RECEIVER_RST,RECEIVE_INFO=>RECEIVE_INFO,
			 RESTORE_CLK=>RESTORE_CLK,EFFECTIVE=>EFFECTIVE,INTERWEAVE_MODE=>INTERWEAVE_MODE,RESTORE_DATA=>RESTORE_DATA);
end stru;