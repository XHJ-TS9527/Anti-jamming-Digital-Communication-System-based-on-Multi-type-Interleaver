library ieee;
use ieee.std_logic_1164.all;
entity real_voice_DSSS_receiver_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_EFFECTIVE:in std_logic;
		 BARK_FLAG:in std_logic;
		 USEABLE:out std_logic;
		 CTRL_BIT:out std_logic;
		 M_RESET:out std_logic);
end real_voice_DSSS_receiver_controller;
architecture behav of real_voice_DSSS_receiver_controller is
type state is(init,idle,b,working,reset_m);
signal pr_st,nx_st:state;
signal temp_reset:std_logic;
begin
	M_RESET<=temp_reset and RST;
	process(RST,CLK)
	begin
		if (RST='0') then pr_st<=init;
		elsif falling_edge(CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,INTERWEAVE_EFFECTIVE,BARK_FLAG)
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (INTERWEAVE_EFFECTIVE='1') then nx_st<=idle;
					else nx_st<=init;
					end if;
				when idle=>
					if (BARK_FLAG='1') then nx_st<=b;
					else nx_st<=idle;
					end if;
				when b=>nx_st<=working;
				when working=>
					if (BARK_FLAG='1') then nx_st<=reset_m;
					else nx_st<=working;
					end if;
				when reset_m=>nx_st<=idle;
			end case;
		end if;
	end process;
	temp_reset<='0' when (pr_st=reset_m) else '1';
	CTRL_BIT<='1' when (pr_st=b) else '0';
	USEABLE<='1' when (pr_st=working) else '0';
end behav;