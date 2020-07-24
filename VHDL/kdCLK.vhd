library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity kdCLK is
	port(clk:in std_logic;
		 k:in std_logic_vector(17 downto 0);
		 clk_div:out std_logic;
		 CNT:out std_logic_vector(17 downto 0));
end kdCLK;
architecture behav of kdCLK is
signal rising_CNT,falling_CNT,total_CNT:std_logic_vector(17 downto 0);
signal RST,tmp_flag,tmp_clk:std_logic;
begin
	CNT<=total_CNT;         
	clk_div<=tmp_clk;
	tmp_flag<='1' when total_CNT=(k-'1') else '0';
	process(RST,clk)
	begin
		if (RST='0') then rising_CNT<=(others=>'0');
		elsif (clk'event and clk='1') then rising_CNT<=falling_CNT+'1';
		end if;
	end process;
	process(RST,clk)
	begin
		if (RST='0') then falling_CNT<=(others=>'0');
		elsif (clk'event and clk='0') then falling_CNT<=rising_CNT+'1';
		end if;
	end process;
	process(clk)
	begin
		if (total_CNT=k) then
			total_CNT<=(others=>'0');
			RST<='0';
		else
			RST<='1';
			if (clk='1') then total_CNT<=rising_CNT;
			else total_CNT<=falling_CNT;
			end if;
		end if;
	end process;
	process(tmp_flag)
	begin
		if (tmp_flag'event and tmp_flag='0') then tmp_clk<=not(tmp_clk);
		end if;
	end process;
end behav;