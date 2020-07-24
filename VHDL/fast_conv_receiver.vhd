library ieee;
use ieee.std_logic_1164.all;
entity fast_conv_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end fast_conv_receiver;
architecture stru of fast_conv_receiver is
component fast_conv_receive_controller is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 receive_pause_flag:in std_logic;
		 receive_ctrl_bit:in std_logic;
		 work_flag:out std_logic;
		 EFFECTIVE:out std_logic;
		 for_select:out std_logic);
end component;
component shift12_switch is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 IN_BIT:in std_logic;
		 OUT_BIT:out std_logic;
		 CONTENT:out std_logic_vector(11 downto 0));
end component;
component shift17 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift34 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift51 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift68 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift85 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift102 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift119 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift136 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift153 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift170 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component shift187 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal reset_flag,shift_RST,pause_flag,effect,working_flag,ctrl_bit0,ctrl_bit1,ctrl_bit2:std_logic;
signal receive_data_cache,restored_data,restore_data_cache:std_logic_vector(7 downto 0);
signal road_select,real_road_select:std_logic_vector(11 downto 0);
type fast_conv_interweave_memory is array(11 downto 0) of std_logic_vector(7 downto 0);
signal road:fast_conv_interweave_memory;
begin
	--port map
	RESTORE_CLK<=RECEIVE_CLK;
	reset_flag<=RST and RECEIVE_INFO(12);
	pause_flag<=RECEIVE_INFO(8);
	CTRLER:fast_conv_receive_controller port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>reset_flag,receive_pause_flag=>pause_flag,
		   receive_ctrl_bit=>RECEIVE_INFO(9),work_flag=>working_flag,EFFECTIVE=>EFFECTIVE,for_select=>ctrl_bit0);
	ctrl_bit2<=ctrl_bit0 or ctrl_bit1;
	ROAD_SELECTOR:shift12_switch port map(CLK=>RECEIVE_CLK,RST=>reset_flag,ENA=>working_flag,IN_BIT=>ctrl_bit2,OUT_BIT=>ctrl_bit1,
				  CONTENT=>road_select);
	shift_RST<=not(reset_flag);
	g0:for idx in 0 to 11 generate
		real_road_select(idx)<=road_select(idx) and not(pause_flag);
	end generate;
	R0:shift187 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(0),IN_DATA=>receive_data_cache,OUT_DATA=>road(0));
	R1:shift170 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(1),IN_DATA=>receive_data_cache,OUT_DATA=>road(1));
	R2:shift153 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(2),IN_DATA=>receive_data_cache,OUT_DATA=>road(2));
	R3:shift136 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(3),IN_DATA=>receive_data_cache,OUT_DATA=>road(3));
	R4:shift119 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(4),IN_DATA=>receive_data_cache,OUT_DATA=>road(4));
	R5:shift102 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(5),IN_DATA=>receive_data_cache,OUT_DATA=>road(5));
	R6:shift85 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(6),IN_DATA=>receive_data_cache,OUT_DATA=>road(6));
	R7:shift68 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(7),IN_DATA=>receive_data_cache,OUT_DATA=>road(7));
	R8:shift51 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(8),IN_DATA=>receive_data_cache,OUT_DATA=>road(8));
	R9:shift34 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(9),IN_DATA=>receive_data_cache,OUT_DATA=>road(9));
	R10:shift17 port map(CLK=>RECEIVE_CLK,CLR=>shift_RST,ENA=>real_road_select(10),IN_DATA=>receive_data_cache,OUT_DATA=>road(10));
	R11:road(11)<=receive_data_cache;
	--data cache
	g1:for idx in 0 to 7 generate
		d0:falling_D_trigger port map(CLK=>RECEIVE_CLK,RST=>reset_flag,D=>RECEIVE_INFO(idx),ENA=>'1',Q=>receive_data_cache(idx));
		d1:rising_D_trigger port map(CLK=>RECEIVE_CLK,RST=>reset_flag,D=>restored_data(idx),ENA=>working_flag,Q=>restore_data_cache(idx));
		d2:falling_D_trigger port map(CLK=>RECEIVE_CLK,RST=>reset_flag,D=>restore_data_cache(idx),ENA=>working_flag,Q=>RESTORE_DATA(idx));
	end generate;
	--output logic
	with real_road_select select
		restored_data<=road(0) when "000000000001",
					   road(1) when "000000000010",
					   road(2) when "000000000100",
					   road(3) when "000000001000",
					   road(4) when "000000010000",
					   road(5) when "000000100000",
					   road(6) when "000001000000",
					   road(7) when "000010000000",
					   road(8) when "000100000000",
					   road(9) when "001000000000",
					   road(10) when "010000000000",
					   road(11) when "100000000000",
					   (others=>'Z') when others;
end stru;