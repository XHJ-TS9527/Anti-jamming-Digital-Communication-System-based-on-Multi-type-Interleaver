library ieee;
use ieee.std_logic_1164.all;
entity tb_bark11_detector is
end tb_bark11_detector;
architecture tb of tb_bark11_detector is
component bark11_detector is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 SYNCHRONIZED_FLAG:out std_logic);
end component;
signal CLK,RST,SYNCHRONIZED_FLAG:std_logic;
signal DATA_IN:std_logic_vector(7 downto 0);
begin
	test_component:bark11_detector port map(CLK=>CLK,RST=>RST,DATA_IN=>DATA_IN,SYNCHRONIZED_FLAG=>SYNCHRONIZED_FLAG);
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
	DATA_IN_process:process
	begin
		DATA_IN<=(0=>'0',others=>'0');
		wait for 20ns;
		DATA_IN<=(0=>'1',others=>'0');
		wait for 60ns;
		DATA_IN<=(0=>'0',others=>'0');
		wait for 60ns;
		DATA_IN<=(0=>'1',others=>'0');
		wait for 20ns;
		DATA_IN<=(0=>'0',others=>'0');
		wait for 40ns;
		DATA_IN<=(0=>'1',others=>'0');
		wait for 20ns;
		DATA_IN<=(0=>'0',others=>'0');
		wait;
	end process;
end tb;