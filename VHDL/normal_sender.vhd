library ieee;
use ieee.std_logic_1164.all;
entity normal_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 SEND_CLK:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 SEND_INFO:out std_logic_vector(12 downto 0));
end normal_sender;
architecture stru of normal_sender is
component normal_send_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 RAM0_WENA:out std_logic;
		 RAM1_WENA:out std_logic;
		 RAM0_RENA:out std_logic;
		 RAM1_RENA:out std_logic;
		 WR_CLK:out std_logic;
		 RD_CLK:out std_logic;
		 W_WORK:out std_logic;
		 R_WORK:out std_logic;
		 ACCEPT:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 RD_MODE:out std_logic_vector(2 downto 0);
		 interweave_CS:out std_logic_vector(7 downto 0);
		 RD_ADD:out std_logic_vector(7 downto 0);
		 WR_GUIDE:out std_logic_vector(7 downto 0));
end component;
component block_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component pseudorandom_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component spiral_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component oddeven_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component reflection_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component interdigital_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component circle_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component convolution_address_selector is
	port(guide:in std_logic_vector(7 downto 0);
		 CS:in std_logic;
		 W_address:out std_logic_vector(7 downto 0));
end component;
component chip_memory_256B is
	port(write_data:in std_logic_vector(7 downto 0);
		 read_clear:in std_logic; --clear the read out data immediately
		 read_address:in std_logic_vector(7 downto 0); --read unit address
		 read_CLK:in std_logic; --read clock, refresh read out data when rising edge, if enabled
		 read_CLK_enable:in std_logic; --enable read clock
		 read_enable:in std_logic; --read enable port, '1' enable
		 write_address:in std_logic_vector(7 downto 0);
		 write_CLK:in std_logic; --write clock, write the unit when rising edge, if enabled.
		 write_CLK_enable:in std_logic;
		 write_enable:in std_logic;
		 read_out_data:out std_logic_vector(7 downto 0));
end component;
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal interweave_CS,read_address,write_guide,write_address,read_data0,read_data1,read_data:std_logic_vector(7 downto 0);
signal bloc_add,rand_add,spin_add,odev_add,refl_add,itdg_add,circ_add,conv_add:std_logic_vector(7 downto 0);
signal read_mode:std_logic_vector(2 downto 0);
signal ram0_w,ram0_r,ram1_w,ram1_r,writeable,readable,write_CLK,read_CLK,ram_reset,zero_flag,read_select:std_logic;
begin
	--port map
	CTRLER:normal_send_controller port map(CLK=>CLK,RST=>RST,START=>START,PAUSE=>PAUSE,CONFIRM=>CONFIRM,
		   MODE=>MODE,RAM0_WENA=>ram0_w,RAM1_WENA=>ram1_w,RAM0_RENA=>ram0_r,RAM1_RENA=>ram1_r,WR_CLK=>write_CLK,
		   RD_CLK=>read_CLK,W_WORK=>writeable,R_WORK=>readable,ACCEPT=>READY,WR_MODE=>WR_MODE,RD_MODE=>read_mode,
		   interweave_CS=>interweave_CS,RD_ADD=>read_address,WR_GUIDE=>write_guide);
	ram_reset<=not(RST);
	RAM0:chip_memory_256B port map(write_data=>TO_SEND_DATA,read_clear=>ram_reset,read_address=>read_address,
		 read_CLK=>read_CLK,read_CLK_enable=>readable,read_enable=>ram0_r,write_address=>write_address,
		 write_CLK=>write_CLK,write_CLK_enable=>writeable,write_enable=>ram0_w,read_out_data=>read_data0);
	RAM1:chip_memory_256B port map(write_data=>TO_SEND_DATA,read_clear=>ram_reset,read_address=>read_address,
		 read_CLK=>read_CLK,read_CLK_enable=>readable,read_enable=>ram1_r,write_address=>write_address,
		 write_CLK=>write_CLK,write_CLK_enable=>writeable,write_enable=>ram1_w,read_out_data=>read_data1);
	BLOC:block_address_selector port map(guide=>write_guide,CS=>interweave_CS(0),W_address=>bloc_add);
	RAND:pseudorandom_address_selector port map(guide=>write_guide,CS=>interweave_CS(1),W_address=>rand_add);
	SPIN:spiral_address_selector port map(guide=>write_guide,CS=>interweave_CS(2),W_address=>spin_add);
	ODEV:oddeven_address_selector port map(guide=>write_guide,CS=>interweave_CS(3),W_address=>odev_add);
	REFL:reflection_address_selector port map(guide=>write_guide,CS=>interweave_CS(4),W_address=>refl_add);
	ITDG:interdigital_address_selector port map(guide=>write_guide,CS=>interweave_CS(5),W_address=>itdg_add);
	CIRC:circle_address_selector port map(guide=>write_guide,CS=>interweave_CS(6),W_address=>circ_add);
	CONV:convolution_address_selector port map(guide=>write_guide,CS=>interweave_CS(7),W_address=>conv_add);
	read_select_cache:rising_D_trigger port map(CLK=>read_CLK,RST=>RST,D=>ram0_r,ENA=>readable,Q=>read_select);
	--output logic
	with interweave_CS select
		write_address<=bloc_add when "00000001",
					   rand_add when "00000010",
					   spin_add when "00000100",
					   odev_add when "00001000",
					   refl_add when "00010000",
					   itdg_add when "00100000",
					   circ_add when "01000000",
					   conv_add when "10000000",
					   (others=>'Z') when others;
	read_data<=read_data0 when (read_select='1') else read_data1;
	zero_flag<='1' when (read_address="00000000") else '0';
	SEND_CLK<=read_CLK;
	SEND_INFO<=zero_flag&readable&read_mode&read_data;
end stru;