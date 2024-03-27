-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Vojtěch Vařecha (xvarec06)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_RX_FSM is
    port(
       CLK :        in std_logic;
       RST :        in std_logic;
       START:       in std_logic;
       STOP:        in std_logic;
       SDIN:        in std_logic;
       LASTBIT:     in std_logic;
       START_RST:   out std_logic;
       STOP_RST:    out std_logic;
       CNT_RST:     out std_logic;
       MEM_RST:     out std_logic
    );
end entity;

architecture behavioral of UART_RX_FSM is
    type t_state is (IDLE, START_BIT, DATA, STOP_BIT);
    signal state : t_state;
    signal next_state : t_state := IDLE;
begin

    -- Present state register
    state_register: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                state <= IDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;
    
    -- Next state combinatorial logic
    next_state_logic: process(state, SDIN, START, LASTBIT, STOP)
    begin
        next_state <= state; -- default behaviour, FSM stay in the same state
        if RST = '0' then
            case state is
                when IDLE =>
                    if SDIN = '0' then
                        next_state <= START_BIT;
                    end if;
                when START_BIT =>
                    if START = '1' then
                        next_state <= DATA;
                    end if;
                when DATA =>
                    if LASTBIT = '1' then
                        next_state <= STOP_BIT;
                    end if;
                when STOP_BIT =>
                    if STOP = '1' then
                        next_state <= IDLE;
                    end if;
                end case;
        end if;
    end process;
    
    
    -- Output combinatorial logic
    output_logic: process(state)
    begin
        START_RST <= '1';
        STOP_RST <= '1';
        CNT_RST <= '1';
        MEM_RST <= '1';
        case state is
            when IDLE =>
                START_RST <= '1';
                STOP_RST <= '1';
                CNT_RST <= '1';
                MEM_RST <= '1';
            when START_BIT =>
                START_RST <= '0';
                STOP_RST <= '1';
                CNT_RST <= '1';
                MEM_RST <= '1';
            when DATA =>
                START_RST <= '1';
                STOP_RST <= '1';
                CNT_RST <= '0';
                MEM_RST <= '0';
            when STOP_BIT =>
                START_RST <= '1';
                STOP_RST <= '0';
                CNT_RST <= '1';
                MEM_RST <= '0';
        end case;
    end process;
end architecture;
