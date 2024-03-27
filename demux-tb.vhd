--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:00:06 04/02/2023
-- Design Name:   
-- Module Name:   /home/viotal/fit/1BIT_2/INC/1proj/impl/ise/inc/dmux.vhd
-- Project Name:  inc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: demux_1to8
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY dmux IS
END dmux;
 
ARCHITECTURE behavior OF dmux IS 
   --Inputs
   signal EN : std_logic := '0';
   signal dmx_in : std_logic := '0';
   signal dmx_select : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
	signal dmx_out : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   UUT: ENTITY work.demux_1to8 PORT MAP (
          EN => EN,
          dmx_in => dmx_in,
          dmx_out => dmx_out,
          dmx_select => dmx_select
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		dmx_in <= '1';
		dmx_select <= "000";
      EN <= '1';
		wait for 10 ns;
		ASSERT dmx_out = "00000001";
		
		wait for 10 ns;
		dmx_in <= '1';
		dmx_select <= "000";
      EN <= '0';
		wait for 10 ns;
		ASSERT dmx_out = "ZZZZZZZZ";

      wait;
   end process;

END;
