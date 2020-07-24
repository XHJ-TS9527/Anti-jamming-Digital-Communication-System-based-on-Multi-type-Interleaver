library ieee;
use ieee.std_logic_1164.all;
entity tb_demo_song_receiver is
end entity;
architecture tb of tb_demo_song_receiver is
component demo_song_receiver is
port(
	CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 MUSIC_TONE:out std_logic;
		 MUSIC_OUT:out std_logic_vector(2 downto 0)
	);
end component;
signal clk,rst,interweave_ready,music_wave:std_logic;
signal music_out:std_logic_vector(2 downto 0);
signal data_in:std_logic_vector(7 downto 0);
begin
test:demo_song_receiver port map(CLK=>clk,RST=>rst,INTERWEAVE_READY=>interweave_ready,DATA_IN=>data_in,MUSIC_TONE=>music_wave,MUSIC_OUT=>music_out);

CLK_process:process
	begin
		clk<='0';
		wait for 10ns;
		clk<='1';
		wait for 10ns;
	end process;
	RST_process:process
	begin
		rst<='0';
		wait for 1ns;
		rst<='1';
		wait;
	end process;
	SYNCHRONIZED_FLAG_process:process
	begin
		interweave_ready<='1';
		wait;
	end process;
	DATA_IN_process:process
	begin
		data_in<="00000000";
		wait for 20 ns;
		data_in<="00000001";
		wait for 10 ns;
		data_in<="00000001";
		wait for 10 ns;
		data_in<="00000001";
		wait for 10 ns;
		data_in<="00000000";
		wait for 10 ns;
		data_in<="00000000";
		wait for 10 ns;
		data_in<="00000000";
		wait for 10 ns;
		data_in<="00000001";
		wait for 10 ns;
		data_in<="00000000";
		wait for 10 ns;
		data_in<="00000000";
		wait for 10 ns;
		data_in<="00000001";
		wait for 10 ns;
		data_in<="00000000";
		wait for 10 ns;
		data_in<="00000010";
		wait for 10 ns;
		data_in<="00000100";
		wait for 10 ns;
		data_in<="00000101";
		wait for 30 ns;
		data_in<="00000000";
		wait for 30 ns;
		data_in<="00011110";
		wait for 20 ns;
		data_in<="00000011";
		wait for 20 ns;
		data_in<="00000010";
		wait for 20 ns;
		data_in<="00000110";
		wait for 20 ns;
		data_in<="00011000";
		wait for 20 ns;
		data_in<="00000101";
		wait for 20 ns;
		data_in<="00000100";
		wait for 20 ns;
		data_in<="00010011";
		wait for 20 ns;
		data_in<="00001101";
		wait for 20 ns;
		data_in<="00010000";
		wait for 20 ns;
		data_in<="00001110";
		wait for 20 ns;
		data_in<="00010101";
		wait for 20 ns;
		data_in<="00010100";
		wait for 20ns;
		data_in<="00001001";
		wait for 20 ns;
		data_in<="00001000";
		wait for 20 ns;
		data_in<="00011000";
		wait for 20 ns;
		data_in<="00011001";
		wait for 20 ns;
		data_in<="00000100";
		wait for 20 ns;
		data_in<="00000101";
		wait for 20 ns;
		data_in<="00000001";
		wait for 20 ns;
		data_in<="00011111";
		wait for 20 ns;
		data_in<="00011101";
		wait for 20 ns;
		data_in<="00000011";
		wait for 20 ns;
		data_in<="00001011";
		wait for 20 ns;
		data_in<="00010101";
		wait for 20 ns;
		data_in<="00001000";
		wait for 20 ns;
		data_in<="00001001";
		wait for 20 ns;
		data_in<="00001101";
		wait for 20 ns;
		data_in<="00001100";
		wait for 20 ns;
		data_in<="00001110";
		wait for 20 ns;
		data_in<="00010000";
		wait for 20 ns;
		data_in<="00000000";
		wait for 20 ns;
		data_in<="00000001";
		wait for 60 ns;
		data_in<="00000000";
		wait for 60 ns;
		data_in<="00000001";
		wait for 20 ns;
		data_in<="00000000";
		wait for 40 ns;
		data_in<="00000001";
		wait for 20 ns;
		data_in<="00000000";
		wait for 30 ns;
	end process;
	end architecture;