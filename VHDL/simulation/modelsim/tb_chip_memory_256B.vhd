library ieee;
use ieee.std_logic_1164.all;
entity tb_chip_memory_256B is
end tb_chip_memory_256B;
architecture tb of tb_chip_memory_256B is
component chip_memory_256B is
	port(write_data:in std_logic_vector(7 downto 0);
		 read_clear:in std_logic; --clear the read out data immediately
		 read_address:in std_logic_vector(7 downto 0); --read unit address
		 read_CLK:in std_logic; --read clock, refresh read out data when rising edge, if enabled
		 read_CLK_enable:in std_logic; --enable read clock
		 read_enable:in std_logic; --read enable port, '1' enable
		 write_address:in std_logic_vector(7 downto 0);
		 write_CLK:in std_logic; --write clock, write the unit when rising edge, if enabled.
		 write_CLK_enable:in std_logic;
		 write_enable:in std_logic;
		 read_out_data:out std_logic_vector(7 downto 0));
end component;
signal W_CLK,R_CLK:std_logic;
signal W_CLK_en,R_CLK_en:std_logic;
signal W_en,R_en:std_logic;
signal W_data,R_data:std_logic_vector(7 downto 0);
signal W_add,R_add:std_logic_vector(7 downto 0);
signal CLR:std_logic;
begin
	test_RAM:chip_memory_256B port map(write_data=>W_data,read_clear=>CLR,read_address=>R_add,read_CLK=>R_CLK,
			 read_CLK_enable=>R_CLK_en,read_enable=>R_en,write_address=>W_add,write_CLK=>W_CLK,write_CLK_enable=>W_CLK_en,
			 write_enable=>W_en,read_out_data=>R_data);
	write_data_process:process
	begin
		W_data<="10101010";
		wait for 27ns;
		W_data<="10000001";
		wait for 27ns;
		W_data<="00011000";
		wait;
	end process;
	read_clear_process:process
	begin
		CLR<='0';
		wait;
	end process;
	read_address_process:process
	begin
		R_add<=(0=>'1',others=>'0');
		wait;
	end process;
	read_CLK_process:process
	begin --R_CLK period 30ns
		R_CLK<='0';
		wait for 16ns;
		R_CLK<='1';
		wait for 15ns;
	end process;
	write_CLK_process:process
	begin --W_CLK period 20ns
		W_CLK<='0';
		wait for 10ns;
		W_CLK<='1';
		wait for 10ns;
	end process;
	read_CLK_enable_process:process
	begin
		R_CLK_en<='1';
		wait;
	end process;
	read_enable_process:process
	begin
		R_en<='0';
		wait for 30ns;
		R_en<='1';
		wait;
	end process;
	write_address_process:process
	begin
		W_add<=(0=>'1',others=>'0');
		wait;
	end process;
	write_CLK_enable_process:process
	begin
		W_CLK_en<='1';
		wait;
	end process;
	write_enable_process:process
	begin
		W_en<='0';
		wait for 12ns;
		W_en<='1';
		wait;
	end process;
end tb;