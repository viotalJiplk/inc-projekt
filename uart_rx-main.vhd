-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Vojtěch Vařecha (xvarec06)




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;

-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
    signal START : std_logic;
    signal STOP : std_logic;
    signal SDIN : std_logic;
    signal MSDIN : std_logic;
    signal LASTBIT : std_logic;
    signal START_RST : std_logic;
    signal STOP_RST : std_logic;
    signal CNT_RST : std_logic;
    signal MEM_RST : std_logic;
    signal START_CNT : std_logic_vector(4 downto 0);
    signal STOP_CNT : std_logic_vector(4 downto 0);
    signal CLK_CNT : std_logic_vector(3 downto 0);
    signal SAMPLE : std_logic;
    signal ADRESS : std_logic_vector(2 downto 0);
    signal DMX_VALUE : std_logic_vector(7 downto 0);
    signal DMX_ENABLE : std_logic_vector(7 downto 0);
begin
    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        RST => RST,
        START => START,
        STOP => STOP,
        SDIN => SDIN,
        LASTBIT => LASTBIT,
        START_RST => START_RST,
        STOP_RST => STOP_RST,
        CNT_RST => CNT_RST,
        MEM_RST => MEM_RST
    );

    cnt_start: entity work.cnt
    generic map(
        NBIT => 5
    )
    port map (
        CLK => CLK,
        RST => START_RST,
        EN => '1',
        COUNT => START_CNT
    );

    cmp_start: entity work.cmp
    generic map(
        NBIT => 5
    )
    port map (
        CLK => CLK,
        RST => START_RST,
        EN => '1',
        in_sig => START_CNT,
        cmp_in => "10011",
        out_sig => START
    );

    cnt_stop: entity work.cnt
    generic map(
        NBIT => 5
    )
    port map (
        CLK => CLK,
        RST => STOP_RST,
        EN => '1',
        COUNT => STOP_CNT
    );

    cmp_stop: entity work.cmp
    generic map(
        NBIT => 5
    )
    port map (
        CLK => CLK,
        RST => STOP_RST,
        EN => '1',
        in_sig => STOP_CNT,
        cmp_in => "10010",
        out_sig => STOP
    );

    in_ddx1: entity work.dffx
    port map (
        CLK => CLK,
        RST => RST,
        D => DIN,
        EN => '1',
        Q =>MSDIN
    );

    in_ddx2: entity work.dffx
    port map (
        CLK => CLK,
        RST => RST,
        D => MSDIN,
        EN => '1',
        Q =>SDIN
    );

    out_vld_ddx: entity work.dffx
    port map (
        CLK => CLK,
        RST => RST,
        D => LASTBIT,
        EN => '1',
        Q =>DOUT_VLD
    );

    cnt_clk: entity work.cnt
    generic map(
        NBIT => 4
    )
    port map (
        CLK => CLK,
        RST => CNT_RST,
        EN => '1',
        COUNT => CLK_CNT
    );

    cmp_clk: entity work.cmp
    generic map(
        NBIT => 4
    )
    port map (
        CLK => CLK,
        RST => CNT_RST,
        EN => '1',
        in_sig => CLK_CNT,
        cmp_in => "0000",
        out_sig => SAMPLE
    );

    cnt_addr: entity work.cnt
    generic map(
        NBIT => 3
    )
    
    port map (
        CLK => CLK,
        RST => CNT_RST,
        EN => SAMPLE,
        COUNT => ADRESS
    );

    cmp_addr: entity work.cmp
    generic map(
        NBIT => 3
    )
    port map (
        CLK => CLK,
        RST => CNT_RST,
        EN => SAMPLE,
        in_sig => ADRESS,
        cmp_in => "111",
        out_sig => LASTBIT
    );

    dmx_in: entity work.demux_1to8
    port map (
        EN => SAMPLE,
        dmx_in => SDIN,
        dmx_out => DMX_VALUE,
        dmx_select => ADRESS
    );

    dmx_en: entity work.demux_1to8
    port map (
        EN => SAMPLE,
        dmx_in => SDIN,
        dmx_out => DMX_ENABLE,
        dmx_select => ADRESS
    );

    -- out registers

    out_ddx0: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(0),
        EN => DMX_ENABLE(0),
        Q => DOUT(0)
    );

    out_ddx1: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(1),
        EN => DMX_ENABLE(1),
        Q => DOUT(1)
    );

    out_ddx2: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(2),
        EN => DMX_ENABLE(2),
        Q => DOUT(2)
    );

    out_ddx3: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(3),
        EN => DMX_ENABLE(3),
        Q => DOUT(3)
    );

    out_ddx4: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(4),
        EN => DMX_ENABLE(4),
        Q => DOUT(4)
    );

    out_ddx5: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(5),
        EN => DMX_ENABLE(5),
        Q => DOUT(5)
    );

    out_ddx6: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(6),
        EN => DMX_ENABLE(6),
        Q => DOUT(6)
    );

    out_ddx7: entity work.dffx
    port map (
        CLK => CLK,
        RST => MEM_RST,
        D => DMX_VALUE(7),
        EN => DMX_ENABLE(7),
        Q => DOUT(7)
    );

end architecture;
