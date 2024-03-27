library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_1to8 is
    Port (
        EN          : in  STD_LOGIC;
        dmx_in      : in  STD_LOGIC;
        dmx_out     : out  STD_LOGIC_VECTOR(7 downto 0);
        dmx_select  : in  STD_LOGIC_VECTOR(2 downto 0));
end demux_1to8;

architecture Behavioral of demux_1to8 is
begin
    process (EN, dmx_select, dmx_in)
    begin
        dmx_out <= (others => 'Z');
        if EN = '1' then
            dmx_out <= (others => '0');
            dmx_out(to_integer(unsigned(dmx_select))) <= dmx_in;
        else
            dmx_out <= (others => 'Z');
        end if;
    end process;
end Behavioral;
