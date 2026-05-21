----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2026 12:04:19 PM
-- Design Name: 
-- Module Name: synapse_FSM - synapse_FSM_arch
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
use IEEE.numeric_std.all;

entity synapse_FSM is
    port(
        rst, clk: in std_logic;
        spike_bus: in std_logic_vector(SENSOR_COUNT+NEURON_COUNT-1 downto 0);
--        data_from_memory: in std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0);
        bus_done, weight_valid: out std_logic;
        neuron_address: out std_logic_vector(ADDRESS_WIDTH downto 0)
    );
end synapse_FSM;

architecture synapse_FSM_arch of synapse_FSM is

    type STATES is (INITIAL, BUS_COMPARE, WAIT_BRAM, ASSERT_WEIGHT, ADD_WEIGHTS);
    signal STATE, NEXT_STATE: STATES;
    signal spike_bus_signal: std_logic_vector(SENSOR_COUNT+NEURON_COUNT-1 downto 0);

begin
    SEQ_PROC: process (clk, rst)
        variable found: std_logic;
        variable index: integer;

        begin
            if rst = '1' then
                STATE <= INITIAL;
            elsif rising_edge(clk) then
                case STATE is
                    when INITIAL =>
                        bus_done <= '0';
                        spike_bus_signal <= spike_bus;
                        weight_valid <= '0';
                        found := '0';
                        index := 0;
                        neuron_address <= (others => '0');
                        STATE <= BUS_COMPARE;
     
                    when BUS_COMPARE =>
                        bus_done <= '0';
                        weight_valid <= '0';
                        
                        if index >= (SENSOR_COUNT + NEURON_COUNT) then
                            STATE <= ADD_WEIGHTS;
                        else
                            if spike_bus_signal(index) = '1' then
                                neuron_address <= std_logic_vector(to_unsigned(index, ADDRESS_WIDTH + 1));
                                spike_bus_signal(index) <= '0';
                                STATE <= WAIT_BRAM;
                            else
                                index := index + 1;
                            end if;
                        end if;
                        
                     when WAIT_BRAM =>
                        STATE <= ASSERT_WEIGHT;
                        
                     when ASSERT_WEIGHT =>
                        weight_valid <= '1';
                        index := index + 1;
                        STATE <= BUS_COMPARE;
                    
                     when ADD_WEIGHTS =>
                        weight_valid <= '0';
                        bus_done <= '1';
                        STATE <= INITIAL;
            end case;
        end if;
	end process SEQ_PROC;          

end synapse_FSM_arch;
