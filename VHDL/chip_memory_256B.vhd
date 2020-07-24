library ieee;
library altera_mf;
use ieee.std_logic_1164.all;
use altera_mf.all;
entity chip_memory_256B is
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
end chip_memory_256B;
architecture stru of chip_memory_256B is
signal sub_wire:std_logic_vector(7 downto 0);
component altsyncram
	generic(address_aclr_b:string;
			address_reg_b:string;
			clock_enable_input_a:string;
			clock_enable_input_b:string;
			clock_enable_output_b:string;
			intended_device_family:string;
			lpm_type:string;
			numwords_a:natural;
			numwords_b:natural;
			operation_mode:string;
			outdata_aclr_b:string;
			outdata_reg_b:string;
			power_up_uninitialized:string;
			rdcontrol_reg_b:string;
			widthad_a:natural;
			widthad_b:natural;
			width_a:natural;
			width_b:natural;
			width_byteena_a:natural);
	port(clocken0:in std_logic;
		 clocken1:in std_logic;
		 wren_a:in std_logic;
		 clock0:in std_logic;
		 aclr1:in std_logic;
		 clock1:in std_logic;
		 address_a:in std_logic_vector(7 downto 0);
		 address_b:in std_logic_vector(7 downto 0);
		 rden_b:in std_logic;
		 q_b:out std_logic_vector(7 downto 0);
		 data_a:in std_logic_vector(7 downto 0));
end component;
begin
	read_out_data<=sub_wire;
	altsyncram_component:altsyncram
	generic map(address_aclr_b=>"CLEAR1",
				address_reg_b=>"CLOCK1",
				clock_enable_input_a=>"NORMAL",
				clock_enable_input_b=>"NORMAL",
				clock_enable_output_b=>"BYPASS",
				intended_device_family=>"Cyclone IV E",
				lpm_type=>"altsyncram",
				numwords_a=>256,
				numwords_b=>256,
				operation_mode=>"DUAL_PORT",
				outdata_aclr_b=>"CLEAR1",
				outdata_reg_b=>"UNREGISTERED",
				power_up_uninitialized=>"FALSE",
				rdcontrol_reg_b=>"CLOCK1",
				widthad_a=>8,
				widthad_b=>8,
				width_a=>8,
				width_b=>8,
				width_byteena_a=>1)
	port map(clocken0=>write_CLK_enable,
			 clocken1=>read_CLK_enable,
			 wren_a=>write_enable,
			 clock0=>write_CLK,
			 aclr1=>read_clear,
			 clock1=>read_CLK,
			 address_a=>write_address,
			 address_b=>read_address,
			 rden_b=>read_enable,
			 data_a=>write_data,
			 q_b =>sub_wire);
end stru;