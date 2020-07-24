library ieee;
use ieee.std_logic_1164.all;
entity send_normal_read_control_state_machine is
	port(RCLK:in std_logic;
		 RST:in std_logic;
		 write_work:in std_logic;
		 pause_flag:in std_logic;
		 last_write_mode:in std_logic_vector(2 downto 0);
		 read_work:out std_logic;
		 read_chip:out std_logic;
		 read_mode:out std_logic_vector(2 downto 0));
end send_normal_read_control_state_machine;
architecture behav of send_normal_read_control_state_machine is
component rising_CNT204 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 CNT:out std_logic_vector(7 downto 0));
end component;
type state is(init,silent,
			  bloc0,bloc1,  --0:ram 0;1:ram 1
			  rand0,rand1,
			  spin0,spin1,
			  odev0,odev1,
			  refl0,refl1,
			  itdg0,itdg1,
			  circ0,circ1,
			  conv0,conv1);
signal pr_st,nx_st:state;
signal r_work,r_local_work,r_local_CNT_work,r_CNT_work,local_CLK,read_chip_select:std_logic;
signal local_CNT:std_logic_vector(7 downto 0);
signal r_mode:std_logic_vector(2 downto 0);
--000:useless or slow convolution 001:block 010:pseudorandom 011:spiral 100:oddeven 101:reflection 110:interdigital 111:circle
begin
	--port map
	read_work<=r_work;
	read_chip<=read_chip_select;
	read_mode<=r_mode;
	--local counter
	r_work<=r_local_work and not(pause_flag);
	r_local_CNT_work<=r_CNT_work and not(pause_flag);
	local_counter:rising_CNT204 port map(CLK=>RCLK,RST=>RST,ENA=>r_local_CNT_work,CNT=>local_CNT);
	--state machine
	local_CLK<=RCLK when (pause_flag='0') else 'Z';
	process(RST,local_CLK) --time series process
	begin	
		if (RST='0') then pr_st<=init;
		elsif falling_edge(local_CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,write_work,local_CNT,last_write_mode) --state process
	begin
		if (RST='0') then nx_st<=init;
		else
			case pr_st is
				when init=>
					if (write_work='1') then nx_st<=silent;
					else nx_st<=init;
					end if;
				when silent=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=silent;
					end if;
				when bloc0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=bloc0;
					end if;
				when bloc1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=bloc1;
					end if;
				when rand0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=rand0;
					end if;
				when rand1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=rand1;
					end if;
				when spin0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=spin0;
					end if;
				when spin1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=spin1;
					end if;
				when odev0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=odev0;
					end if;
				when odev1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=odev0;
					end if;
				when refl0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=refl0;
					end if;
				when refl1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=refl1;
					end if;
				when itdg0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=itdg0;
					end if;
				when itdg1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=itdg1;
					end if;
				when circ0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=circ0;
					end if;
				when circ1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=circ1;
					end if;
				when conv0=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv1;
							when "001"=>nx_st<=bloc1;
							when "010"=>nx_st<=rand1;
							when "011"=>nx_st<=spin1;
							when "100"=>nx_st<=odev1;
							when "101"=>nx_st<=refl1;
							when "110"=>nx_st<=itdg1;
							when "111"=>nx_st<=circ1;
							when others=>null;
						end case;
					else nx_st<=conv0;
					end if;
				when conv1=>
					if (local_CNT="00000000") then
						case last_write_mode is
							when "000"=>nx_st<=conv0;
							when "001"=>nx_st<=bloc0;
							when "010"=>nx_st<=rand0;
							when "011"=>nx_st<=spin0;
							when "100"=>nx_st<=odev0;
							when "101"=>nx_st<=refl0;
							when "110"=>nx_st<=itdg0;
							when "111"=>nx_st<=circ0;
							when others=>null;
						end case;
					else nx_st<=conv1;
					end if;
			end case;
		end if;
	end process;
	--output logic
	r_local_work<='0' when ((pr_st=init) or (pr_st=silent)) else '1';
	r_CNT_work<='0' when (pr_st=init) else '1';
	with pr_st select
		read_chip_select<='1' when bloc1,
						  '1' when rand1,
						  '1' when spin1,
						  '1' when odev1,
						  '1' when refl1,
						  '1' when itdg1,
						  '1' when circ1,
						  '1' when conv1,
						  '0' when others;
	with pr_st select
		r_mode<="001" when bloc0,
				"001" when bloc1,
				"010" when rand0,
				"010" when rand1,
				"011" when spin0,
				"011" when spin1,
				"100" when odev0,
				"100" when odev1,
				"101" when refl0,
				"101" when refl1,
				"110" when itdg0,
				"110" when itdg1,
				"111" when circ0,
				"111" when circ1,
				"000" when others;
				
end behav;