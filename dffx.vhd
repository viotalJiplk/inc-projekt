library IEEE;
use IEEE.std_logic_1164.all;

entity dffx is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        D   : in std_logic;
        EN  : in std_logic;
        Q   : out std_logic
    );
end dffx;
architecture behavioral of dffx is
begin
    process(CLK, RST)
    begin
        if RST='1' then
            Q <= '0';
        elsif rising_edge(CLK) and EN='1' then
            Q <= D;
        end if;
    end process;
end behavioral;
