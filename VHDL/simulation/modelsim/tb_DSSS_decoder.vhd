library ieee;
use ieee.std_logic_1164.all;
entity tb_DSSS_decoder is
end tb_DSSS_decoder;
architecture tb of tb_DSSS_decoder is
component DSSS_decoder is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 SYNCHRONIZED_FLAG:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 DATA_OUT:out std_logic_vector(7 downto 0));
end component;
signal CLK,RST,SYNCHRONIZED_FLAG:std_logic;
signal DATA_IN,DATA_OUT:std_logic_vector(7 downto 0);
begin
	test_state_machine:DSSS_decoder port map(CLK=>CLK,RST=>RST,SYNCHRONIZED_FLAG=>SYNCHRONIZED_FLAG,DATA_IN=>DATA_IN,
					   DATA_OUT=>DATA_OUT);
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
	SYNCHRONIZED_FLAG_process:process
	begin
		SYNCHRONIZED_FLAG<='0';
		wait for 10ns;
		SYNCHRONIZED_FLAG<='1';
		wait for 20ns;
		SYNCHRONIZED_FLAG<='0';
		wait;
	end process;
	DATA_IN_process:process
	begin
		DATA_IN<="00000000";
		wait for 30ns;
		DATA_IN<="00011110";
		wait for 20ns;
		DATA_IN<="00000011";
		wait for 20ns;
		DATA_IN<="00000010";
		wait for 20ns;
		DATA_IN<="00000110";
		wait for 20ns;
		DATA_IN<="00011000";
		wait for 20ns;
		DATA_IN<="00000101";
		wait for 20ns;
		DATA_IN<="00000100";
		wait for 20ns;
		DATA_IN<="00010011";
		wait for 20ns;
		DATA_IN<="00001101";
		wait for 20ns;
		DATA_IN<="00010000";
		wait for 20ns;
		DATA_IN<="00001110";
		wait for 20ns;
		DATA_IN<="00010101";
		wait for 20ns;
		DATA_IN<="00010100";
		wait for 20ns;
		DATA_IN<="00001001";
		wait for 20ns;
		DATA_IN<="00001000";
		wait for 20ns;
		DATA_IN<="00011000";
		wait for 20ns;
		DATA_IN<="00011001";
		wait for 20ns;
		DATA_IN<="00000100";
		wait for 20ns;
		DATA_IN<="00000101";
		wait for 20ns;
		DATA_IN<="00000001";
		wait for 20ns;
		DATA_IN<="00011111";
		wait for 20ns;
		DATA_IN<="00011101";
		wait for 20ns;
		DATA_IN<="00000011";
		wait for 20ns;
		DATA_IN<="00001011";
		wait for 20ns;
		DATA_IN<="00010101";
		wait for 20ns;
		DATA_IN<="00001000";
		wait for 20ns;
		DATA_IN<="00001001";
		wait for 20ns;
		DATA_IN<="00001101";
		wait for 20ns;
		DATA_IN<="00001100";
		wait for 20ns;
		DATA_IN<="00001110";
		wait for 20ns;
		DATA_IN<="00010000";
		wait for 20ns;
		DATA_IN<="00000000";
		wait for 20ns;
		DATA_IN<="00000001";
		wait for 60ns;
		DATA_IN<="00000000";
		wait for 60ns;
		DATA_IN<="00000001";
		wait for 20ns;
		DATA_IN<="00000000";
		wait for 40ns;
		DATA_IN<="00000001";
		wait for 20ns;
		DATA_IN<="00000000";
		wait;
	end process;
end tb;