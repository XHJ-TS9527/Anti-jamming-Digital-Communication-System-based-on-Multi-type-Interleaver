library ieee;
use ieee.std_logic_1164.all;
entity normal_interweaver_experiment is
	port(CLK:in std_logic;
		 SENDER_RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 RECEIVER_RST:in std_logic;
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end normal_interweaver_experiment;
architecture stru of normal_interweaver_experiment is
component normal_interweaver is
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
end component;
signal MID_CLK:std_logic;
signal MID_INFO:std_logic_vector(12 downto 0);
begin
	test_component:normal_interweaver port map(CLK=>CLK,SENDER_RST=>SENDER_RST,START=>START,PAUSE=>PAUSE,CONFIRM=>CONFIRM,
				   MODE=>MODE,TO_SEND_DATA=>TO_SEND_DATA,READY=>READY,SEND_CLK=>MID_CLK,WR_MODE=>WR_MODE,SEND_INFO=>MID_INFO,
				   RECEIVE_CLK=>MID_CLK,RECEIVER_RST=>RECEIVER_RST,RECEIVE_INFO=>MID_INFO,RESTORE_CLK=>RESTORE_CLK,
				   EFFECTIVE=>EFFECTIVE,INTERWEAVE_MODE=>INTERWEAVE_MODE,RESTORE_DATA=>RESTORE_DATA);
end stru;