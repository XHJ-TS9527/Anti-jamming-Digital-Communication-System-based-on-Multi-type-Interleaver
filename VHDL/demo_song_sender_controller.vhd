library ieee;
use ieee.std_logic_1164.all;
entity demo_song_sender_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 BARK_READY:in std_logic;
		 SONG_FINISH:in std_logic;
		 FRAME_END:in std_logic;
		 SONG_START_ORDER:out std_logic;
		 DATA_SEL:out std_logic);
end demo_song_sender_controller;
architecture behav of demo_song_sender_controller is
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
type state is(init,bark0,song,bark1,idle);
signal pr_st,nx_st:state;
signal ready_flag,bark_ok_flag,finish_flag,start_flag,anti_start_flag,start_flag_cache,start_CLK:std_logic;
signal start_equal,frame_end_flag:std_logic;
begin
	SONG_START_ORDER<=START;
	ready_buff:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>INTERWEAVE_READY,ENA=>'1',Q=>ready_flag);
	bark_ok:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>BARK_READY,ENA=>'1',Q=>bark_ok_flag);
	finish_buff:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>SONG_FINISH,ENA=>'1',Q=>finish_flag);
	frame_end_buff:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>FRAME_END,ENA=>'1',Q=>frame_end_flag);
	start_CLK<=START when (start_equal='1') else 'Z';
	start_equal<='1' when (start_flag=start_flag_cache) else '0';
	anti_start_flag<=not(start_flag);
	start_cache:rising_D_trigger port map(CLK=>start_CLK,RST=>RST,D=>anti_start_flag,ENA=>'1',Q=>start_flag);
	start_cache_cache:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>start_flag,ENA=>'1',Q=>start_flag_cache);
	--state machine
	process(RST,CLK) --time series process
	begin
		if (RST='0') then pr_st<=init;
		elsif falling_edge(CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,ready_flag,bark_ok_flag,start_flag,start_flag_cache,finish_flag,frame_end_flag) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (ready_flag='1') then nx_st<=bark0;
					else nx_st<=init;
					end if;
				when bark0=>
					if (bark_ok_flag='1') then nx_st<=song;
					else nx_st<=bark0;
					end if;
				when song=>
					if (finish_flag='1') then nx_st<=bark1;
					else nx_st<=song;
					end if;
				when bark1=>
					if (frame_end_flag='1') then nx_st<=idle;
					else nx_st<=bark1;
					end if;
				when idle=>
					if (start_flag=start_flag_cache) then nx_st<=idle;
					else nx_st<=bark0;
					end if;
			end case;
		end if;
	end process;
	--output logic
	DATA_SEL<='0' when (pr_st=song) else '1';
end behav;