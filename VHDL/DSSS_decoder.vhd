library ieee;
use ieee.std_logic_1164.all;
entity DSSS_decoder is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 SYNCHRONIZED_FLAG:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 DATA_OUT:out std_logic_vector(7 downto 0));
end DSSS_decoder;
architecture behav of DSSS_decoder is
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
signal dsss_copy,dsss_copy_cache:std_logic_vector(4 downto 0);
signal DSSS_vec:std_logic_vector(7 downto 0);
begin
	DSSS_vec<="000"&dsss_copy_cache;
	DATA_OUT<=DATA_IN xor DSSS_vec;
	g:for idx in 0 to 4 generate
		d:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>dsss_copy(idx),ENA=>'1',Q=>dsss_copy_cache(idx));
	end generate;
	--state machine
	process(RST,CLK) --time series process
	begin
		if (RST='0') then pr_st<=init;
		elsif falling_edge(CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,SYNCHRONIZED_FLAG) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (SYNCHRONIZED_FLAG='1') then nx_st<=mi1;
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
	dsss_copy<=(others=>'1') when ((pr_st=mi1)or(pr_st=so5)or(pr_st=ri8)or(pr_st=do10)or(pr_st=mi12)or(pr_st=mi13)or(pr_st=fa18)or(pr_st=so19)or(pr_st=so20)
						   or(pr_st=ri23)or(pr_st=do24)or(pr_st=ri26)or(pr_st=mi27)or(pr_st=ri28)or(pr_st=do29)or(pr_st=do30)) else (others=>'0');
end behav;