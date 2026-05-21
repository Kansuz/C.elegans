----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/18/2026 02:02:02 PM
-- Design Name: 
-- Module Name: top_cell - top_cell_arch
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
use IEEE.fixed_pkg.all;
use work.values_pkg.all;
use IEEE.numeric_std.all;


entity top_cell is
    port(
        rst, clk: in std_logic;
        external_spike_bus_signal: in std_logic_vector(SENSOR_COUNT-1 downto 0);
        
--        membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);

        membrane_potential_monitor: out std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);
        leak_monitor: out std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);
        threshold_monitor: out std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);
        
        bus_done_monitor: out std_logic
    );
end top_cell;

architecture top_cell_arch of top_cell is

type monitor_array is array (0 to NEURON_COUNT-1) of sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal intermediate_membrane  : monitor_array;
signal intermediate_leak      : monitor_array;
signal intermediate_threshold : monitor_array;

signal spike_bus_signal: std_logic_vector(SENSOR_COUNT+NEURON_COUNT-1 downto 0);
signal internal_spikes : std_logic_vector(NEURON_COUNT-1 downto 0):= (others => '0');
signal data_out_signal: std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0);
signal bus_done_signal: std_logic;
signal weight_valid_signal: std_logic;
signal fsm_neuron_address: std_logic_vector(ADDRESS_WIDTH downto 0) := (others => '0');
signal neuron_addr_from_neuron: std_logic_vector(ADDRESS_WIDTH downto 0) := (others => '0');

begin
    spike_bus_signal <= internal_spikes & external_spike_bus_signal;
    bus_done_monitor <= bus_done_signal;
    
    neuron_gen: for i in 0 to NEURON_COUNT-1 generate
        component_neuron: entity work.neuron 
            port map(
                neuron_id => std_logic_vector(to_unsigned(SENSOR_COUNT+i, ADDRESS_WIDTH+1)),
                clk => clk,
                rst => rst,
                input_neurons => to_sfixed(signed(data_out_signal((i+1)*WEIGHT_WIDTH-1 downto WEIGHT_WIDTH*i)), VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN),
                bus_done => bus_done_signal,
                weight_valid => weight_valid_signal,
                spike => internal_spikes(i),
                neuron_address => neuron_addr_from_neuron,
                
                membrane_potential_monitor => intermediate_membrane(i),
                leak_monitor => intermediate_leak(i),
                threshold_monitor => intermediate_threshold(i)
            );
    end generate neuron_gen;
    
    pack_monitors_gen: for i in 0 to NEURON_COUNT-1 generate
        membrane_potential_monitor((i+1)*SFIXED_WIDTH-1 downto i*SFIXED_WIDTH) <= std_logic_vector(intermediate_membrane(i));
        leak_monitor((i+1)*SFIXED_WIDTH-1 downto i*SFIXED_WIDTH) <= std_logic_vector(intermediate_leak(i));
        threshold_monitor((i+1)*SFIXED_WIDTH-1 downto i*SFIXED_WIDTH) <= std_logic_vector(intermediate_threshold(i));
    end generate pack_monitors_gen;
    
    component_weight_memory: entity work.weight_memory 
        port map(
            clk => clk,
            neuron_address => fsm_neuron_address,
            data_out => data_out_signal
        );
        
    component_FSM: entity work.synapse_FSM
        port map(
            rst => rst,
            clk => clk,
            spike_bus => spike_bus_signal,
            bus_done => bus_done_signal,
            weight_valid => weight_valid_signal,
            neuron_address => fsm_neuron_address
        );
        
end top_cell_arch;
