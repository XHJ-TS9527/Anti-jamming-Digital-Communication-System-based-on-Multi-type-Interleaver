library ieee;
use ieee.std_logic_1164.all;
entity send_normal_write_control_state_machine is
	port(WCLK:in std_logic;
		 RST:in std_logic;
		 start_flag:in std_logic;
		 pause_flag:in std_logic;
		 mode_select:in std_logic_vector(2 downto 0);
		 accept:out std_logic;
		 write_work:out std_logic;
		 write_chip:out std_logic;
		 last_write_mode:out std_logic_vector(2 downto 0);
		 now_write_mode:out std_logic_vector(2 downto 0);
		 interleave_chip_select:out std_logic_vector(7 downto 0));
end send_normal_write_control_state_machine;
architecture behav of send_normal_write_control_state_machine is
component rising_CNT204 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 CNT:out std_logic_vector(7 downto 0));
end component;
type state is (init0,init1,
			   bloc0,bloc1,  --0:ram 0,1:ram 1
			   rand0,rand1,
			   spin0,spin1,
			   odev0,odev1,
			   refl0,refl1,
			   itdg0,itdg1,
			   circ0,circ1,
			   conv0,conv1);
signal pr_st,nx_st:state;
signal w_work,w_local_work,write_chip_select,accept_flag,allow_flag,local_CLK:std_logic;
signal local_CNT,chip_select:std_logic_vector(7 downto 0);
signal w_mode,last_w_mode:std_logic_vector(2 downto 0);
--000:init or convolution 001:block 010:pseudorandom 011:spiral
--100:oddeven 101:reflection 110:interdigital 111:circle
begin
	--port map
	write_work<=w_work;
	interleave_chip_select<=chip_select;
	write_chip<=write_chip_select;
	now_write_mode<=w_mode;
	last_write_mode<=last_w_mode;
	accept<=accept_flag and not(pause_flag);
	--local counter
	w_work<=w_local_work and not(pause_flag);
	local_counter:rising_CNT204 port map(CLK=>WCLK,RST=>RST,ENA=>w_work,CNT=>local_CNT);
	--state machine
	allow_flag<='1' when (local_CNT="11001011") else '0';
	local_CLK<=WCLK when (pause_flag='0') else 'Z';
	process(RST,local_CLK) --time series process
	begin
		if (RST='0') then pr_st<=init0;
		elsif falling_edge(local_CLK) then pr_st<=nx_st;
		end if;
	end process;
	process(pr_st,RST,start_flag,mode_select,local_CNT) --state process
	begin
		if (RST='0') then nx_st<=init0;
		else
			case pr_st is
				when init0=>
					if (start_flag='1') then nx_st<=init1;
					else nx_st<=init0;
					end if;
				when init1=>
					case mode_select is
						when "000"=>nx_st<=bloc0;
						when "001"=>nx_st<=rand0;
						when "010"=>nx_st<=spin0;
						when "011"=>nx_st<=odev0;
						when "100"=>nx_st<=refl0;
						when "101"=>nx_st<=itdg0;
						when "110"=>nx_st<=circ0;
						when "111"=>nx_st<=conv0;
						when others=>null;
					end case;
				when bloc0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=bloc0;
					end if;
				when bloc1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=bloc1;
					end if;
				when rand0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=rand0;
					end if;
				when rand1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=rand1;
					end if;
				when spin0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=spin0;
					end if;
				when spin1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=spin1;
					end if;
				when odev0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=odev0;
					end if;
				when odev1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=odev1;
					end if;
				when refl0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=refl0;
					end if;
				when refl1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=refl1;
					end if;
				when itdg0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=itdg0;
					end if;
				when itdg1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=itdg1;
					end if;
				when circ0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=circ0;
					end if;
				when circ1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=circ1;
					end if;
				when conv0=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc1;
							when "001"=>nx_st<=rand1;
							when "010"=>nx_st<=spin1;
							when "011"=>nx_st<=odev1;
							when "100"=>nx_st<=refl1;
							when "101"=>nx_st<=itdg1;
							when "110"=>nx_st<=circ1;
							when "111"=>nx_st<=conv1;
							when others=>null;
						end case;
					else nx_st<=conv0;
					end if;
				when conv1=>
					if (local_CNT="00000000") then
						case mode_select is
							when "000"=>nx_st<=bloc0;
							when "001"=>nx_st<=rand0;
							when "010"=>nx_st<=spin0;
							when "011"=>nx_st<=odev0;
							when "100"=>nx_st<=refl0;
							when "101"=>nx_st<=itdg0;
							when "110"=>nx_st<=circ0;
							when "111"=>nx_st<=conv0;
							when others=>null;
						end case;
					else nx_st<=conv1;
					end if;
			end case;
		end if;
	end process;
	--output logic
	accept_flag<='0' when (pr_st=init0) else '1';
	w_local_work<='0' when ((pr_st=init0) or (pr_st=init1)) else '1';
	with pr_st select
		write_chip_select<='1' when bloc1,
						   '1' when rand1,
						   '1' when spin1,
						   '1' when odev1,
						   '1' when refl1,
						   '1' when itdg1,
						   '1' when circ1,
						   '1' when conv1,
						   '0' when others;
	with pr_st select
		w_mode<="001" when bloc0,
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
	with pr_st select
		chip_select<=(0=>'1',others=>'0') when bloc0,
					 (0=>'1',others=>'0') when bloc1,
					 (1=>'1',others=>'0') when rand0,
					 (1=>'1',others=>'0') when rand1,
					 (2=>'1',others=>'0') when spin0,
					 (2=>'1',others=>'0') when spin1,
					 (3=>'1',others=>'0') when odev0,
					 (3=>'1',others=>'0') when odev1,
					 (4=>'1',others=>'0') when refl0,
					 (4=>'1',others=>'0') when refl1,
					 (5=>'1',others=>'0') when itdg0,
					 (5=>'1',others=>'0') when itdg1,
					 (6=>'1',others=>'0') when circ0,
					 (6=>'1',others=>'0') when circ1,
					 (7=>'1',others=>'0') when conv0,
					 (7=>'1',others=>'0') when conv1,
					 (others=>'0') when others;
	process(RST,allow_flag)
	begin
		if (RST='0') then last_w_mode<=(others=>'0');
		elsif rising_edge(allow_flag) then last_w_mode<=w_mode;
		end if;
	end process;
end behav;