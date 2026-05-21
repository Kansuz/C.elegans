----------------------------------------------------------------------------------
-- Company: 
-- Engineer:
-- 
-- Create Date: 12.11.2025 21:12:57
-- Design Name: 
-- Module Name: top_neuron - top_neuron_arch
-- Project Name: Master Thesis
-- Target Devices: NexysDDR4
-- Tool Versions: 
-- Description: Implementation of a single spiking neuron.
-- 
-- Dependencies: 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use ieee.math_real.all;
use work.values_pkg.all;

entity neuron is
    port (
        neuron_id: in std_logic_vector(ADDRESS_WIDTH downto 0);
        clk: in std_logic;
        rst: in std_logic;
        input_neurons: in sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        bus_done: in std_logic;
        weight_valid: in std_logic;
        spike: out std_logic;
        neuron_address: out std_logic_vector(ADDRESS_WIDTH downto 0);
        
        membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN)
    );
end neuron;

architecture neuron_arch of neuron is
    signal spike_signal: std_logic;
    signal threshold_init: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN):= to_sfixed(THRESHOLD_VALUE,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
    signal threshold: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
    signal membrane_potential: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
    signal membrane_potential_init: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN):= to_sfixed(MEMBRANE_POTENCJAL_VALUE,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
    signal leak_init: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN):= to_sfixed(LEAKAGE, VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
    signal current_leak_signal : sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--    signal current_leak: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
    
    constant MEMBRANE_MAX : sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN) := to_sfixed(MEMBRANE_MAX_VALUE, VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
    constant MEMBRANE_MIN : sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN) := to_sfixed(MEMBRANE_MIN_VALUE, VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
    constant THRESHOLD_MAX : sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN) := to_sfixed(THRESHOLD_MAX_VALUE, VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);

begin

    membrane_potential_monitor <= membrane_potential;
    leak_monitor <= current_leak_signal;
    threshold_monitor <= threshold;
    spike <= spike_signal;
    
    process(rst, clk)
        variable membrane_copy: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        variable threshold_copy: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        variable current_leak: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);


    begin
	      if rising_edge(clk) then
	      
		      if rst = '1' then
		        spike_signal <= '0';
			    membrane_potential <= membrane_potential_init;
			    threshold <= threshold_init;
			    current_leak := leak_init;
			    neuron_address <= (others => '0');
			    
			  else 
                 if spike_signal = '1' then
                    spike_signal <= '0';
                    membrane_potential <= membrane_potential_init;
                    neuron_address <= (others => '0');
                    threshold <= resize(threshold - shift_right(threshold, 3), threshold);
                    if threshold > THRESHOLD_MAX then
                        threshold <= THRESHOLD_MAX;
                    end if;
--                    current_leak := leak_init; 
                 else
                    membrane_copy := membrane_potential;
                    if weight_valid = '1' then
                        membrane_copy := resize(membrane_potential + input_neurons, membrane_potential);
                    end if;
                    if membrane_copy > MEMBRANE_MAX then
                        membrane_copy := MEMBRANE_MAX;
                    elsif membrane_copy < MEMBRANE_MIN then
                        membrane_copy := MEMBRANE_MIN;
                    end if;
                     
                    current_leak := resize(shift_right(membrane_potential - membrane_potential_init, 4), current_leak);

                    if bus_done = '1' then
                         if membrane_copy >= threshold then
                             spike_signal <= '1';
                             membrane_potential <= membrane_copy;
                             neuron_address <= neuron_id; --pomyslec czy potrzebuje
    
                         else
                            spike_signal <= '0';
                            membrane_potential <= resize(membrane_copy - current_leak, membrane_potential);
                            neuron_address <= (others => '0'); --pomyslec czy potrzebuje
                                if threshold > threshold_init then
                                    threshold_copy :=  resize(threshold + shift_right(threshold, 5), threshold);
                                        if threshold_copy < threshold_init then
                                            threshold <= threshold_init;
                                        else
                                            threshold <= threshold_copy;
                                        end if;
                                end if;
                         end if;
                    else
                        membrane_potential <= membrane_copy;
                        spike_signal       <= '0';
                        neuron_address     <= (others => '0'); --pomyslec czy potrzebuje
                    end if;
                 end if;
		      end if;
		      current_leak_signal <= current_leak;
	      end if;
    end process;

end neuron_arch;
