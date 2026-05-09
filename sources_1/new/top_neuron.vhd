----------------------------------------------------------------------------------
-- Company: 
-- Engineer:
-- 
-- Create Date: 12.11.2025 21:12:57
-- Design Name: 
-- Module Name: top_neuron - top_neuron_arch
-- Project Name: Magisterka
-- Target Devices: NexysDDR4
-- Tool Versions: 
-- Description: Implementation of a single spiking neuron.
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
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use ieee.math_real.all;

entity top_neuron is
    generic(
        VECTOR_WIDTH_DOWN : integer := -8;
        VECTOR_WIDTH_UP : integer := 7;
        THRESHOLD_VALUE : real:=-55.0; --(-55mV)
        MEMBRANE_POTENCJAL_VALUE: real:=-70.0; --(-70mV)
        LEAKAGE: real:=5.0
    );
    port (
        neuron_id: in std_logic_vector(8 downto 0);
        clk: in std_logic;
        rst: in std_logic;
        input_neurons: in sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        spike: out std_logic;
        neuron_address: out std_logic_vector(8 downto 0);
        
        membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN)
    );
end top_neuron;

architecture top_neuron_arch of top_neuron is
    signal spike_signal: std_logic;
    signal threshold_init: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN):= to_sfixed(THRESHOLD_VALUE,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
    signal threshold: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
    signal membrane_potential: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
    signal membrane_potential_init: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN):= to_sfixed(MEMBRANE_POTENCJAL_VALUE,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
    signal leakage_signal: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN):= to_sfixed(LEAKAGE, VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
    signal current_leak: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);

    
begin

    membrane_potential_monitor <= membrane_potential;
    leak_monitor <= current_leak;
    threshold_monitor <= threshold;
    spike <= spike_signal;
    
    process(rst, clk)
        variable membrane_copy: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        variable threshold_copy: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        variable leak_init: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        variable current_leak: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);

--        variable leak_copy: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);

    begin
--          membrane_potential_monitor <= membrane_potential;
--          leak_monitor <= current_leak;
--          threshold_monitor <= threshold;
--          spike <= spike_signal;
          
	      if clk'event and clk = '1' then
	      
		      if rst = '1' then
		        spike_signal <= '0';
			    membrane_potential <= membrane_potential_init;
			    threshold <= threshold_init;
			    leak_init := leakage_signal;
--			    leak_init := resize(shift_right(membrane_potential_init, 4), leak_init);
			    current_leak <= leak_init;
			    
			  else 
                 
                 if spike_signal = '1' then
                    spike_signal <= '0';
                    membrane_potential <= membrane_potential_init;
                    threshold <= resize(threshold - shift_right(threshold, 3), threshold);  
                    current_leak <= leak_init; 
                    neuron_address <= (others => '0');
                 else 
--                     current_leak := resize((current_leak - shift_right(current_leak, 3)), current_leak); 
                                         
                     membrane_copy := resize(membrane_potential + input_neurons, membrane_potential);
                     
                     current_leak <= resize(shift_right(membrane_potential - membrane_potential_init, 4), current_leak);
                     
                     if membrane_copy >= threshold then
                         spike_signal <= '1';
--                         membrane_potential <= resize(membrane_copy + leak_init, membrane_potential);
                         membrane_potential <= membrane_copy;
--                         neuron_address <= std_logic_vector(to_unsigned((NEURON_ID), neuron_address'length));
                           neuron_address <= neuron_id;

                     else
                        spike_signal <= '0';
                        membrane_potential <= resize(membrane_copy - current_leak, membrane_potential);
                            if threshold > threshold_init then
                                threshold_copy :=  resize(threshold + shift_right(threshold, 5), threshold);
                                    if threshold_copy < threshold_init then
                                        threshold <= threshold_init;
                                    else
                                        threshold <= threshold_copy;
                                    end if;
                            end if;
                     end if;
                 end if;
		      end if;
	      end if;
    end process;

end top_neuron_arch;
