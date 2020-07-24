library ieee;
use ieee.std_logic_1164.all;
entity fast_conv_receive_controller is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 receive_pause_flag:in std_logic;
		 receive_ctrl_bit:in std_logic;
		 work_flag:out std_logic;
		 EFFECTIVE:out std_logic;
		 for_select:out std_logic);
end fast_conv_receive_controller;
architecture behav of fast_conv_receive_controller is
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
type state is(init,ready,work_mode);
signal pr_st,nx_st:state;
signal cache_ctrl_bit,effect,selection,local_CLK,working:std_logic;
begin
	--port map
	receive_ctrl_bit_cache:falling_D_trigger port map(CLK=>RECEIVE_CLK,RST=>RST,D=>receive_ctrl_bit,ENA=>'1',Q=>cache_ctrl_bit);
	work_flag<=working and not(receive_pause_flag);
	EFFECTIVE<=effect and not(receive_pause_flag);
	for_select<=selection and not(receive_pause_flag);
	--state machine
	local_CLK<=RECEIVE_CLK when (receive_pause_flag='0') else 'Z';
	process(RST,local_CLK) --time series process
	begin
		if (RST='0') then pr_st<=init;
		elsif rising_edge(local_CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(RST,pr_st,cache_ctrl_bit) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (cache_ctrl_bit='1') then nx_st<=ready;
					else nx_st<=init;
					end if;
				when ready=>nx_st<=work_mode;
				when work_mode=>nx_st<=work_mode;
			end case;
		end if;
	end process;
	--output logic
	effect<='1' when (pr_st=work_mode) else '0';
	selection<='1' when (pr_st=ready) else '0';
	working<='0' when (pr_st=init) else '1';
end behav;