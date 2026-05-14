----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2026 01:01:05 AM
-- Design Name: 
-- Module Name: weight_memory_tb - weight_memory_tb_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.values_pkg.all;

entity weight_memory_tb is
end weight_memory_tb;

architecture weight_memory_tb_arch of weight_memory_tb is

    component weight_memory is
        port (
            clk : in std_logic;
            neuron_address : in std_logic_vector(ADDRESS_WIDTH downto 0);
            data_out : out std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0)
        );
    end component;

    signal clk_tb            : std_logic := '0';
    signal neuron_address_tb : std_logic_vector(ADDRESS_WIDTH downto 0) := (others => '0');
    signal data_out_tb       : std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: weight_memory
        port map (
            clk            => clk_tb,
            neuron_address => neuron_address_tb,
            data_out       => data_out_tb
        );

    clk_process : process
    begin
        while now < 200 ns loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin		
        wait for 20 ns;

        neuron_address_tb <= std_logic_vector(to_unsigned(0, ADDRESS_WIDTH+1));
        wait for CLK_PERIOD;
        
        neuron_address_tb <= std_logic_vector(to_unsigned(1, ADDRESS_WIDTH+1));
        wait for CLK_PERIOD;

        wait;
    end process;

end weight_memory_tb_arch;
