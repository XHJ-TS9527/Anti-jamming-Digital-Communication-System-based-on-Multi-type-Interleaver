library ieee;
use ieee.std_logic_1164.all;
entity bark_generator_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 FINISH:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 LAST_BIT:in std_logic;
		 READY:out std_logic;
		 CTRL_BIT:out std_logic;
		 FRAME_END:out std_logic);
end bark_generator_controller;
architecture behav of bark_generator_controller is
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
type state is(init,idle0,idle1,idle2,b0,b1,b2,bark0,bark1);
signal pr_st,nx_st:state;
signal RST_start,ready_flag,start_flag,start_D_CLK,start_flag_cache,start_equal,not_start_flag,finish_flag:std_logic;
begin
	ready_cache:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>INTERWEAVE_READY,ENA=>'1',Q=>ready_flag); --interweaver ready signal
	RST_start_cache:rising_D_trigger port map(CLK=>START,RST=>RST,D=>'1',ENA=>'1',Q=>RST_start);
	not_start_flag<=not(start_flag);
	start_equal<='1' when (start_flag=start_flag_cache) else '0';
	start_D_CLK<=START when (start_equal='1') else 'Z';
	start_buff:rising_D_trigger port map(CLK=>START_D_CLK,RST=>RST,D=>not_start_flag,ENA=>'1',Q=>start_flag);
	start_cache:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>start_flag,ENA=>'1',Q=>start_flag_cache);
	finish_cache:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>FINISH,ENA=>'1',Q=>finish_flag);
	--state machine
	process(RST,CLK) --time series process
	begin
		if (RST='0') then pr_st<=init;
		elsif falling_edge(CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,RST_start,ready_flag,LAST_BIT,finish_flag,start_flag,start_flag_cache)
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (RST_start='1') then nx_st<=idle0;
					else nx_st<=init;
					end if;
				when idle0=>
					if (ready_flag='1') then nx_st<=b0;
					else nx_st<=idle0;
					end if;
				when b0=>nx_st<=bark0;
				when bark0=>
					if (LAST_BIT='1') then nx_st<=idle1;
					else nx_st<=bark0;
					end if;
				when idle1=>
					if (finish_flag='1') then nx_st<=b1;
					else nx_st<=idle1;
					end if;
				when b1=>nx_st<=bark1;
				when bark1=>
					if (LAST_BIT='1') then nx_st<=idle2;
					else nx_st<=bark1;
					end if;
				when idle2=>
					if (start_flag=start_flag_cache) then nx_st<=idle2;
					else nx_st<=b2;
					end if;
				when b2=>nx_st<=bark0;
			end case;
		end if;
	end process;
	--output logic
	READY<='1' when (pr_st=idle1) else '0';
	CTRL_BIT<='1' when ((pr_st=b0) or (pr_st=b1) or (pr_st=b2)) else '0';
	FRAME_END<='1' when (pr_st=idle2) else '0';
end behav;