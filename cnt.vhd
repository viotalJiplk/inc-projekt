library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cnt is
    GENERIC (
		NBIT : POSITIVE := 2
    );
    port(
        CLK     : in std_logic;
        RST     : in std_logic;
        EN      : in std_logic;
        COUNT   : out std_logic_vector(NBIT-1 downto 0)
    );
end entity;

architecture behavioral of cnt is
    signal intcnt: std_logic_vector(NBIT-1 downto 0);
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            intcnt <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                intcnt <= intcnt + 1;
            end if;
        end if;
        COUNT <= intcnt;
    end process;
end behavioral;
