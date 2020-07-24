library ieee;
use ieee.std_logic_1164.all;
entity bark11_generator is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 FINISH:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 READY:out std_logic;
		 FRAME_END:out std_logic;
		 BARK11:out std_logic_vector(7 downto 0));
end bark11_generator;
architecture stru of bark11_generator is
component bark_generator_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 FINISH:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 LAST_BIT:in std_logic;
		 READY:out std_logic;
		 CTRL_BIT:out std_logic;
		 FRAME_END:out std_logic);
end component;
component shift11_bark is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 IN_BIT:in std_logic;
		 OUT_BIT:out std_logic;
		 CONTENT:out std_logic_vector(10 downto 0));
end component;
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal last_bit,ctrl_bit,now_bark,now_bark_cache:std_logic;
signal content:std_logic_vector(10 downto 0);
begin
	BARK11<=(0=>now_bark_cache,others=>'0');
	CTRLER:bark_generator_controller port map(CLK=>CLK,RST=>RST,START=>START,FINISH=>FINISH,
		   INTERWEAVE_READY=>INTERWEAVE_READY,LAST_BIT=>last_bit,READY=>READY,CTRL_BIT=>ctrl_bit,FRAME_END=>FRAME_END);
	SHIFT:shift11_bark port map(CLK=>CLK,RST=>RST,ENA=>'1',IN_BIT=>ctrl_bit,OUT_BIT=>last_bit,CONTENT=>content);
	now_bark_buff:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>now_bark,ENA=>'1',Q=>now_bark_cache);
	now_bark<='1' when ((content(0)='1')or(content(1)='1')or(content(2)='1')or(content(6)='1')or(content(9)='1')) else '0';
end stru;