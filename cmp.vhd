library ieee;
use ieee.std_logic_1164.all;

entity cmp is
    GENERIC (
		NBIT : POSITIVE := 2
    );
    port(
        CLK     : in std_logic;
        RST     : in std_logic;
        EN      : in std_logic;
        in_sig  : in std_logic_vector(NBIT-1 downto 0);
        cmp_in  : in std_logic_vector(NBIT-1 downto 0);
        out_sig : out std_logic
    );
end entity;

architecture behavioral of cmp is
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            out_sig <= '0';
        elsif rising_edge(CLK) then
            if EN = '1' then
                if cmp_in = in_sig then
                    out_sig <= '1';
                else
                    out_sig <= '0';
                end if;
            end if;
        end if;
    end process;
end behavioral;
