library ieee;
use ieee.std_logic_1164.all;
entity pause_processor is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 pause_cache:in std_logic;
		 analog_pause:out std_logic);
end pause_processor;
architecture stru of pause_processor is
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
component CLK_MUX is
	port(data0:in std_logic;
		 data1:in std_logic;
		 sel:in std_logic;
		 result:out std_logic);
end component;
signal evidence,evidence_cache0,evidence_cache1,store,judge0,judge1,judge2,judge3,cache0,cache1,cache2,cache3:std_logic;
signal analog_pause0,analog_pause1:std_logic;
begin
	STORE_D:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>pause_cache,ENA=>'1',Q=>store);
	evidence<=pause_cache xor store;
	evidence_trigger0:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>evidence,ENA=>'1',Q=>evidence_cache0);
	judge0<=evidence and not(cache0);
	judge0_cache:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>judge0,ENA=>'1',Q=>cache0);
	judge1<=not(cache1);
	judge1_cache:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>judge1,ENA=>evidence_cache0,Q=>cache1);
	analog_pause0<=cache0 and cache1;
	evidence_trigger1:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>evidence,ENA=>'1',Q=>evidence_cache1);
	judge2<=evidence and not(cache2);
	judge2_cache:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>judge2,ENA=>'1',Q=>cache2);
	judge3<=not(cache3);
	judge3_cache:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>judge3,ENA=>evidence_cache1,Q=>cache3);
	analog_pause1<=cache2 and cache3;
	analog_pause_mux:CLK_MUX port map(data0=>analog_pause0,data1=>analog_pause1,sel=>pause_cache,result=>analog_pause);
end stru;