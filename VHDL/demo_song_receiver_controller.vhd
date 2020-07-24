library ieee;
use ieee.std_logic_1164.all;
entity demo_song_receiver_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_EFFECTIVE:in std_logic;
		 BARK_READY:in std_logic;
		 DE_WORK:out std_logic);
end demo_song_receiver_controller;
architecture behav of demo_song_receiver_controller is
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
type state is(init,bark,song);
signal pr_st,nx_st:state;
signal ready_flag,bark_ok_flag,finish_flag,start_flag,anti_start_flag,start_flag_cache,start_CLK:std_logic;
signal start_equal,frame_end_flag:std_logic;
begin
	ready_buff:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>INTERWEAVE_EFFECTIVE,ENA=>'1',Q=>ready_flag);
	bark_ok:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>BARK_READY,ENA=>'1',Q=>bark_ok_flag);
	--state machine
	process(RST,CLK) --time series process
	begin
		if (RST='0') then pr_st<=init;
		elsif falling_edge(CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,ready_flag,bark_ok_flag) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (ready_flag='1') then nx_st<=bark;
					else nx_st<=init;
					end if;
				when bark=>
					if (bark_ok_flag='1') then nx_st<=song;
					else nx_st<=bark;
					end if;
				when song=>
					if (bark_ok_flag='1') then nx_st<=bark;
					else nx_st<=song;
					end if;
				
			end case;
		end if;
	end process;
	--output logic
	DE_WORK<='1' when (pr_st=song) else '0';
end behav;