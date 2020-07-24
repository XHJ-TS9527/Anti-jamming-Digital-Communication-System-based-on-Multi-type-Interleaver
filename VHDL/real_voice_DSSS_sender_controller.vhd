library ieee;
use ieee.std_logic_1164.all;
entity real_voice_DSSS_sender_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 STOP:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 BARK_READY:in std_logic;
		 FRAME_END:in std_logic;
		 RST_M_ORDER:out std_logic;
		 FINISH:out std_logic;
		 START_ORDER:out std_logic;
		 DATA_SEL:out std_logic);
end real_voice_DSSS_sender_controller;
architecture behav of real_voice_DSSS_sender_controller is
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
type state is(init,bark0,voice,bark1,reset_state,idle);
signal pr_st,nx_st:state;
signal ready_flag,bark_ok_flag,finish_flag,start_flag,anti_start_flag,start_flag_cache,start_CLK:std_logic;
signal start_equal,frame_end_flag,stop_equal,stop_flag,anti_stop_flag,stop_flag_cache,stop_CLK,reset_order:std_logic;
begin
	START_ORDER<=START;
	ready_buff:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>INTERWEAVE_READY,ENA=>'1',Q=>ready_flag);
	bark_ok:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>BARK_READY,ENA=>'1',Q=>bark_ok_flag);
	frame_end_buff:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>FRAME_END,ENA=>'1',Q=>frame_end_flag);
	start_CLK<=START when (start_equal='1') else 'Z';
	start_equal<='1' when (start_flag=start_flag_cache) else '0';
	anti_start_flag<=not(start_flag);
	start_cache:rising_D_trigger port map(CLK=>start_CLK,RST=>RST,D=>anti_start_flag,ENA=>'1',Q=>start_flag);
	start_cache_cache:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>start_flag,ENA=>'1',Q=>start_flag_cache);
	stop_equal<='1' when (stop_flag=stop_flag_cache) else '0';
	stop_CLK<=STOP when (stop_equal='1') else 'Z';
	anti_stop_flag<=not(stop_flag);
	stop_cache:rising_D_trigger port map(CLK=>stop_CLK,RST=>RST,D=>anti_stop_flag,ENA=>'1',Q=>stop_flag);
	stop_cache_cache:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>stop_flag,ENA=>'1',Q=>stop_flag_cache);
	--state machine
	process(RST,CLK) --time series process
	begin
		if (RST='0') then pr_st<=init;
		elsif falling_edge(CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,ready_flag,bark_ok_flag,start_flag,start_flag_cache,stop_flag,stop_flag_cache,frame_end_flag) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (ready_flag='1') then nx_st<=bark0;
					else nx_st<=init;
					end if;
				when bark0=>
					if (bark_ok_flag='1') then nx_st<=voice;
					else nx_st<=bark0;
					end if;
				when voice=>
					if (stop_flag=stop_flag_cache) then nx_st<=voice;
					else nx_st<=bark1;
					end if;
				when bark1=>
					if (frame_end_flag='1') then nx_st<=idle;
					else nx_st<=reset_state;
					end if;
				when reset_state=>nx_st<=idle;
				when idle=>
					if (start_flag=start_flag_cache) then nx_st<=idle;
					else nx_st<=bark0;
					end if;
			end case;
		end if;
	end process;
	--output logic
	DATA_SEL<='0' when (pr_st=voice) else '1';
	RST_M_ORDER<=RST and reset_order;
	reset_order<='0' when ((pr_st=reset_state)or(pr_st=idle)) else '1';
	FINISH<='1' when (pr_st=reset_state) else '0';
end behav;