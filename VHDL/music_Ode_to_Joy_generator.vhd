library ieee;
use ieee.std_logic_1164.all;
entity music_Ode_to_Joy_generator is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 BARK_READY:in std_logic;
		 FINISH:out std_logic;
		 SONG_DATA:out std_logic_vector(7 downto 0));
end music_Ode_to_Joy_generator;
architecture behav of music_Ode_to_Joy_generator is
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
type state is(init,mi1,mi2,fa3,so4,so5,fa6,mi7,ri8,
			  do9,do10,ri11,mi12,mi13,ri14,ri15,mi16,
			  mi17,fa18,so19,so20,fa21,mi22,ri23,do24,
			  do25,ri26,mi27,ri28,do29,do30,played);
signal pr_st,nx_st:state;
signal ready_cache:std_logic;
signal gray,m,state_data:std_logic_vector(4 downto 0);
begin
	ready_flag_cache:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>BARK_READY,ENA=>'1',Q=>ready_cache);
	process(RST,CLK) --time series process
	begin
		if (RST='0') then pr_st<=init;
		elsif falling_edge(CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,ready_cache) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (ready_cache='1') then nx_st<=mi1;
					else nx_st<=init;
					end if;
				when mi1=>nx_st<=mi2;
				when mi2=>nx_st<=fa3;
				when fa3=>nx_st<=so4;
				when so4=>nx_st<=so5;
				when so5=>nx_st<=fa6;
				when fa6=>nx_st<=mi7;
				when mi7=>nx_st<=ri8;
				when ri8=>nx_st<=do9;
				when do9=>nx_st<=do10;
				when do10=>nx_st<=ri11;
				when ri11=>nx_st<=mi12;
				when mi12=>nx_st<=mi13;
				when mi13=>nx_st<=ri14;
				when ri14=>nx_st<=ri15;
				when ri15=>nx_st<=mi16;
				when mi16=>nx_st<=mi17;
				when mi17=>nx_st<=fa18;
				when fa18=>nx_st<=so19;
				when so19=>nx_st<=so20;
				when so20=>nx_st<=fa21;
				when fa21=>nx_st<=mi22;
				when mi22=>nx_st<=ri23;
				when ri23=>nx_st<=do24;
				when do24=>nx_st<=do25;
				when do25=>nx_st<=ri26;
				when ri26=>nx_st<=mi27;
				when mi27=>nx_st<=ri28;
				when ri28=>nx_st<=do29;
				when do29=>nx_st<=do30;
				when do30=>nx_st<=played;
				when played=>nx_st<=init;
			end case;
		end if;
	end process;
	--output logic
	FINISH<='1' when (pr_st=played) else '0';
	SONG_DATA<="000"&state_data;
	state_data<=gray xor m;
	with pr_st select
		gray<="00000" when init,
			  "00001" when mi1,
			  "00011" when mi2,
			  "00010" when fa3,
			  "00110" when so4,
			  "00111" when so5,
			  "00101" when fa6,
			  "00100" when mi7,
			  "01100" when ri8,
			  "01101" when do9,
			  "01111" when do10,
			  "01110" when ri11,
			  "01010" when mi12,
			  "01011" when mi13,
			  "01001" when ri14,
			  "01000" when ri15,
			  "11000" when mi16,
			  "11001" when mi17,
			  "11011" when fa18,
			  "11010" when so19,
			  "11110" when so20,
			  "11111" when fa21,
			  "11101" when mi22,
			  "11100" when ri23,
			  "10100" when do24,
			  "10101" when do25,
			  "10111" when ri26,
			  "10110" when mi27,
			  "10010" when ri28,
			  "10011" when do29,
			  "10001" when do30,
			  "10000" when played;
	m<=(others=>'1') when ((pr_st=mi1)or(pr_st=so5)or(pr_st=ri8)or(pr_st=do10)or(pr_st=mi12)or(pr_st=mi13)or(pr_st=fa18)or(pr_st=so19)or(pr_st=so20)
						   or(pr_st=ri23)or(pr_st=do24)or(pr_st=ri26)or(pr_st=mi27)or(pr_st=ri28)or(pr_st=do29)or(pr_st=do30)) else (others=>'0');
end behav;