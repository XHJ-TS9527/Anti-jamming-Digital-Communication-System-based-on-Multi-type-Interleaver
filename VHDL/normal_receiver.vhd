library ieee;
use ieee.std_logic_1164.all;
entity normal_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end normal_receiver;
architecture stru of normal_receiver is
component normal_receive_controller is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_SEND_FLAG:in std_logic;
		 RECEIVE_LAST_FLAG:in std_logic;
		 RECEIVE_MODE:in std_logic_vector(2 downto 0);
		 WCLK:out std_logic;
		 RCLK:out std_logic;
		 RAM0_WENA:out std_logic;
		 RAM1_WENA:out std_logic;
		 RAM0_RENA:out std_logic;
		 RAM1_RENA:out std_logic;
		 write_work:out std_logic;
		 read_work:out std_logic;
		 out_reset:out std_logic;
		 read_mode:out std_logic_vector(2 downto 0);
		 write_address:out std_logic_vector(7 downto 0);
		 read_guide:out std_logic_vector(7 downto 0);
		 CS:out std_logic_vector(7 downto 0));
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
signal write_CLK,read_CLK,writeable,readable,ram0_w,ram1_w,ram0_r,ram1_r,reset_flag,ram_reset,read_select:std_logic;
signal buff_data,buff_data1,restored_data,read_address,write_address,read_guide,chip_select,ram0_data,ram1_data:std_logic_vector(7 downto 0);
signal bloc_add,rand_add,spin_add,odev_add,refl_add,itdg_add,circ_add,conv_add,read_data:std_logic_vector(7 downto 0);
signal effect:std_logic;
signal last_write_mode,restore_mode,read_mode:std_logic_vector(2 downto 0);
begin
	--port map
	RESTORE_CLK<=read_CLK;
	EFFECTIVE<=effect;
	RESTORE_DATA<=restored_data;
	INTERWEAVE_MODE<=restore_mode;
	CTRLER:normal_receive_controller port map(RECEIVE_CLK=>RECEIVE_CLK,RST=>RST,RECEIVE_SEND_FLAG=>RECEIVE_INFO(11),
		   RECEIVE_LAST_FLAG=>RECEIVE_INFO(12),RECEIVE_MODE=>RECEIVE_INFO(10 downto 8),WCLK=>write_CLK,RCLK=>read_CLK,
		   RAM0_WENA=>ram0_w,RAM1_WENA=>ram1_w,RAM0_RENA=>ram0_r,RAM1_RENA=>ram1_r,write_work=>writeable,read_work=>readable,
		   out_reset=>reset_flag,read_mode=>read_mode,write_address=>write_address,read_guide=>read_guide,CS=>chip_select);
	ram_reset<=not(reset_flag);
	RAM0:chip_memory_256B port map(write_data=>buff_data,read_clear=>ram_reset,read_address=>read_address,read_CLK=>read_CLK,
		 read_CLK_enable=>readable,read_enable=>ram0_r,write_address=>write_address,write_CLK=>write_CLK,write_CLK_enable=>writeable,
		 write_enable=>ram0_w,read_out_data=>ram0_data);
	RAM1:chip_memory_256B port map(write_data=>buff_data,read_clear=>ram_reset,read_address=>read_address,read_CLK=>read_CLK,
		 read_CLK_enable=>readable,read_enable=>ram1_r,write_address=>write_address,write_CLK=>write_CLK,write_CLK_enable=>writeable,
		 write_enable=>ram1_w,read_out_data=>ram1_data);
	--address selector
	BLOC:block_address_selector port map(guide=>read_guide,CS=>chip_select(0),W_address=>bloc_add);
	RAND:pseudorandom_address_selector port map(guide=>read_guide,CS=>chip_select(1),W_address=>rand_add);
	SPIN:spiral_address_selector port map(guide=>read_guide,CS=>chip_select(2),W_address=>spin_add);
	ODEV:oddeven_address_selector port map(guide=>read_guide,CS=>chip_select(3),W_address=>odev_add);
	REFL:reflection_address_selector port map(guide=>read_guide,CS=>chip_select(4),W_address=>refl_add);
	ITDG:interdigital_address_selector port map(guide=>read_guide,CS=>chip_select(5),W_address=>itdg_add);
	CIRC:circle_address_selector port map(guide=>read_guide,CS=>chip_select(6),W_address=>circ_add);
	CONV:convolution_address_selector port map(guide=>read_guide,CS=>chip_select(7),W_address=>conv_add);
	read_select_cache:rising_D_trigger port map(CLK=>read_CLK,RST=>reset_flag,D=>ram0_r,ENA=>readable,Q=>read_select);
	--data cache
	effect_cache:rising_D_trigger port map(CLK=>read_CLK,RST=>reset_flag,D=>readable,ENA=>'1',Q=>effect);
	g0:for idx in 0 to 2 generate
		mode_cache:rising_D_trigger port map(CLK=>read_CLK,RST=>reset_flag,D=>read_mode(idx),ENA=>'1',Q=>restore_mode(idx));
	end generate;
	g1:for idx in 0 to 7 generate
		data_cache0:falling_D_trigger port map(CLK=>RECEIVE_CLK,RST=>RST,D=>RECEIVE_INFO(idx),ENA=>'1',Q=>buff_data1(idx));
		data_cache1:falling_D_trigger port map(CLK=>RECEIVE_CLK,RST=>RST,D=>buff_data1(idx),ENA=>'1',Q=>buff_data(idx));
		data_cache2:falling_D_trigger port map(CLK=>read_CLK,RST=>reset_flag,D=>read_data(idx),ENA=>readable,Q=>restored_data(idx));
	end generate;
	--output logic
	with chip_select select
		read_address<=bloc_add when "00000001",
					  rand_add when "00000010",
					  spin_add when "00000100",
					  odev_add when "00001000",
					  refl_add when "00010000",
					  itdg_add when "00100000",
					  circ_add when "01000000",
					  conv_add when "10000000",
					  (others=>'Z') when others;
	read_data<=ram0_data when (read_select='1') else ram1_data;
end stru;