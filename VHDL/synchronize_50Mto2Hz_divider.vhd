library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity synchronize_50Mto2Hz_divider is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 CLK_DIV:out std_logic);
end synchronize_50Mto2Hz_divider;
architecture behav of synchronize_50Mto2Hz_divider is
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal temp_CLK,ena_flag:std_logic;
signal CNT:std_logic_vector(23 downto 0);
begin
	CLK_DIV<=temp_CLK;
	ena_cache:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>'1',ENA=>'1',Q=>ena_flag);
	process(RST,CLK)
	begin
		if (RST='0') then
			temp_CLK<='0';
			CNT<=(others=>'0');
		elsif falling_edge(CLK) then
			if (ena_flag='1') then
				if (CNT="101111101011110000100000") then
					CNT<=(others=>'0');
					temp_CLK<=not(temp_CLK);
				else
					CNT<=CNT+'1';
					temp_CLK<=temp_CLK;
				end if;
			else
				CNT<=CNT;
				temp_CLK<=temp_CLK;
			end if;
		end if;
	end process;
end behav;