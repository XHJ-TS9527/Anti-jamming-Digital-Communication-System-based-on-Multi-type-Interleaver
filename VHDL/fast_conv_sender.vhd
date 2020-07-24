library ieee;
use ieee.std_logic_1164.all;
entity fast_conv_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 SEND_CLK:out std_logic;
		 READY:out std_logic;
		 SEND_INFO:out std_logic_vector(12 downto 0));
end fast_conv_sender;
architecture stru of fast_conv_sender is
component fast_conv_send_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 start_flag:in std_logic;
		 pause_flag:in std_logic;
		 ACCEPT:out std_logic;
		 WORKING:out std_logic;
		 FOR_SELECT:out std_logic);
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
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
type fast_conv_interweave_memory is array(11 downto 0) of std_logic_vector(7 downto 0);
signal road:fast_conv_interweave_memory;
signal cache_data,out_data,selected_road_data:std_logic_vector(7 downto 0);
signal road_select,real_road_select:std_logic_vector(11 downto 0);
signal start_flag,pause_flag,work_flag,ready_flag,send_clock,shift_RST,ctrl_bit0,ctrl_bit1,ctrl_bit2,temp_D:std_logic;
signal real_ready_flag:std_logic;
begin
	--port map
	SEND_CLK<=send_clock;
	send_clock<=CLK;
	READY<=ready_flag;
	CTRLER:fast_conv_send_controller port map(CLK=>CLK,RST=>RST,start_flag=>start_flag,pause_flag=>pause_flag,
		   ACCEPT=>ready_flag,WORKING=>work_flag,FOR_SELECT=>ctrl_bit0);
	ctrl_bit2<=ctrl_bit0 or ctrl_bit1;
	real_ready_flag<=ready_flag and not(pause_flag);
	ROAD_SELECTOR:shift12_switch port map(CLK=>CLK,RST=>RST,ENA=>real_ready_flag,IN_BIT=>ctrl_bit2,OUT_BIT=>ctrl_bit1,
				  CONTENT=>road_select);
	shift_RST<=not(RST);
	g0:for idx in 0 to 11 generate
		real_road_select(idx)<=road_select(idx) and not(pause_flag);
	end generate;
	R0:road(0)<=TO_SEND_DATA;
	R1:shift17 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(1),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(1));
	R2:shift34 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(2),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(2));
	R3:shift51 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(3),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(3));
	R4:shift68 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(4),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(4));
	R5:shift85 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(5),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(5));
	R6:shift102 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(6),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(6));
	R7:shift119 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(7),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(7));
	R8:shift136 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(8),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(8));
	R9:shift153 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(9),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(9));
	R10:shift170 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(10),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(10));
	R11:shift187 port map(CLK=>CLK,CLR=>shift_RST,ENA=>real_road_select(11),IN_DATA=>TO_SEND_DATA,OUT_DATA=>road(11));
	g1:for idx in 0 to 7 generate
		d:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>out_data(idx),ENA=>real_ready_flag,Q=>cache_data(idx));
	end generate;
	start_flag_cache:rising_D_trigger port map(CLK=>START,RST=>RST,D=>'1',ENA=>'1',Q=>start_flag);
	temp_D<=not(pause_flag);
	pause_flag_cache:rising_D_trigger port map(CLK=>PAUSE,RST=>RST,D=>temp_D,ENA=>start_flag,Q=>pause_flag);
	--logic;
	with real_road_select select
			out_data<=road(0) when "000000000001",
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
	SEND_INFO<=RST&ready_flag&work_flag&ctrl_bit2&pause_flag&cache_data;
end stru;