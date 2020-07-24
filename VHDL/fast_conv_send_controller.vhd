library ieee;
use ieee.std_logic_1164.all;
entity fast_conv_send_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 start_flag:in std_logic;
		 pause_flag:in std_logic;
		 ACCEPT:out std_logic;
		 WORKING:out std_logic;
		 FOR_SELECT:out std_logic);
end fast_conv_send_controller;
architecture behav of fast_conv_send_controller is
type state is(init,ready,work_mode);
signal pr_st,nx_st:state;
signal accept_flag,working_flag,select_flag,local_CLK:std_logic;
begin
	--port map
	ACCEPT<=accept_flag and not(pause_flag);
	WORKING<=working_flag and not(pause_flag);
	FOR_SELECT<=select_flag;
	local_CLK<=CLK when (pause_flag='0') else 'Z';
	--state machine
	process(RST,local_CLK) --time series
	begin
		if (RST='0') then pr_st<=init;
		elsif rising_edge(local_CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,start_flag) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (start_flag='1') then nx_st<=ready;
					else nx_st<=init;
					end if;
				when ready=>nx_st<=work_mode;
				when work_mode=>nx_st<=work_mode;
			end case;
		end if;
	end process;
	--output logic;
	accept_flag<='0' when (pr_st=init) else '1';
	working_flag<='1' when (pr_st=work_mode) else '0';
	select_flag<='1' when (pr_st=ready) else '0';
end behav;