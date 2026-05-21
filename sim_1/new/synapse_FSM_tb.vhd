----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/18/2026 12:36:46 PM
-- Design Name: 
-- Module Name: synapse_FSM_tb - Behavioralsynapse_FSM_tb_arch
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
use work.values_pkg.all;

entity synapse_FSM_tb is
end synapse_FSM_tb;

architecture synapse_FSM_tb_arch of synapse_FSM_tb is
component synapse_FSM is
    port(
        rst, clk: in std_logic;
        spike_bus: in std_logic_vector(SENSOR_COUNT+NEURON_COUNT-1 downto 0);
--        spike_bus: in std_logic_vector(NEURON_COUNT-1 downto 0);
--        data_from_memory: in std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0);
        bus_done, weight_valid: out std_logic;
        neuron_address: out std_logic_vector(ADDRESS_WIDTH downto 0)
    );
end component;

    signal rst, clk, bus_done, weight_valid: std_logic;
    signal spike_bus: std_logic_vector(NEURON_COUNT-1 downto 0);
--    signal data_from_memory: std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0);
    signal neuron_address: std_logic_vector(ADDRESS_WIDTH downto 0);
    
    constant clk_period: time:= 50 ns;

begin

    uut: synapse_FSM port map(
        rst => rst,
        clk => clk,
        spike_bus => spike_bus,
--        data_from_memory => data_from_memory,
        bus_done => bus_done,
        weight_valid => weight_valid,
        neuron_address => neuron_address
    );
    
     clock_process: process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
        
    sim_proc: process
        begin
            rst <= '1';
            spike_bus <= "00";
            wait for clk_period;
            
            while now < 1 ms loop
                rst <= '0';
                spike_bus <= "00";
                wait for 50 ns;
                
                rst <= '0';
                spike_bus <= "01";
                wait for 50 ns;
            
                rst <= '0';
                spike_bus <= "11";
                wait for 50 ns;
            end loop;

            wait;
        end process;

end synapse_FSM_tb_arch;
