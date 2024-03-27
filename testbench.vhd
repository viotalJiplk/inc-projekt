-- testbench.vhd: Basic UART RX side simulation testing
-- Author(s): Lukas Kekely (ikekely@fit.vutbr.cz)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;



entity testbench is
end testbench;



architecture TB of testbench is

    constant baudrate : natural := 9600;
    constant clkrate : natural := baudrate*16;
    constant clk_period : time := 1 sec / clkrate;
    constant baud_period : time := clk_period*16;

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal din : std_logic := '1';
    signal dout : std_logic_vector(7 downto 0);
    signal dout_vld : std_logic;
    signal running : boolean := true;
    type generator_state is (IDLE, START, D0, D1, D2, D3, D4, D5, D6, D7, STOP);
    signal din_state : generator_state := IDLE;

begin

    -- Tested module
    DUT: entity work.UART_RX
    port map (
        CLK => clk,
        RST => rst,
        DIN => din,
        DOUT => dout,
        DOUT_VLD => dout_vld
    );

    -- Clock generator
    clk_process: process
    begin
        while running loop
            wait for clk_period/2;
            clk <= not clk;
        end loop;
        wait;
    end process;

    -- Output monitoring and reporting
    dout_process: process(clk)
        constant msg : string := "Output data from DOUT with value: 0x";
        variable row : line;
    begin
        if rising_edge(clk) then
            if dout_vld = '1' then
                write(row, msg);
                hwrite(row, dout);
                writeline(OUTPUT, row);
            end if;
        end if;
    end process;

    -- Main testbench process
    test: process
        -- Auxilary procedure for byte sending and DIN generation
        procedure send_byte(constant byte_in : in std_logic_vector(7 downto 0)) is
            constant msg : string := "Sending data onto DIN with value: 0x";
            variable row : line;
        begin
            write(row, msg);
            hwrite(row, byte_in);
            writeline(OUTPUT, row);
            din <= '0'; -- START bit
            din_state <= START;
            wait for baud_period;
            din_state <= D0;
            for i in 0 to 7 loop  -- 8x DATA bit
                din <= byte_in(i);
                wait for baud_period;
                din_state <= generator_state'val(generator_state'pos(din_state)+1);
            end loop;
            din <= '1'; -- STOP bit
            din_state <= STOP;
            wait for baud_period;
            din_state <= IDLE;
        end send_byte;
    begin
        wait for clk_period*5;
        rst <= '0';
        wait for clk_period*5;
        send_byte("01000111");
        wait for clk_period*50;
        send_byte("01010101");
        wait for clk_period*40;
        send_byte("10101010");
        wait for clk_period*30;
        send_byte("11001010");
        wait for clk_period*20;
                                 -- <<< TODO: Insert additional test words here.
        din <= '0'; -- START bit
        din_state <= START;
        wait for baud_period;
        din_state <= D0;
        for i in 0 to 6 loop  -- 8x DATA bit
            din <= '1';
            wait for baud_period;
            din_state <= generator_state'val(generator_state'pos(din_state)+1);
        end loop;

        din <= '0';
        wait for clk_period*7;
        din <= '1';
        wait for clk_period;
        din <= '0';
        wait for clk_period*7;
        din <= '0'; -- STOP bit
        din_state <= STOP;
        din_state <= IDLE;
        running <= false;
        wait;
    end process;

end architecture;
