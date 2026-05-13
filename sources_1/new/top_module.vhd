----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2026 09:07:25 AM
-- Design Name: 
-- Module Name: top_module - top_module_arch
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
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use ieee.math_real.all;

entity top_module is
    generic(
       --sfixed size
       VECTOR_WIDTH_DOWN : integer := -8;
       VECTOR_WIDTH_UP : integer := 7;
       --neuron information
       ADDRESS_WIDTH: integer := 8;
       THRESHOLD_VALUE : real := -30.0; 
       MEMBRANE_POTENCJAL_VALUE: real := -50.0;
       LEAKAGE: real := 5.0;
       --prevents neuron from too high or too low values
       MEMBRANE_MAX_VALUE: real := 40.0;
       MEMBRANE_MIN_VALUE: real := -90.0;
       THRESHOLD_MAX_VALUE: real := 0.0;
        
        NEURON_COUNT : natural := 2;
        DATA_LENGTH: natural := 3
    );
    port (
        clk: in std_logic;
        rst: in std_logic;
        external_input: in sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        
        spike_monitor: out std_logic_vector(NEURON_COUNT-1 downto 0);
        data_output_monitor: out std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);
        membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        neuron_address_monitor: out std_logic_vector(8 downto 0)
        neuron_address_monitor: out std_logic_vector((NEURON_COUNT - 1) downto 0)
    );
end top_module;

architecture top_module_arch of top_module is
--component top_neuron is
--    generic(
--        VECTOR_WIDTH_DOWN : integer := -8;
--        VECTOR_WIDTH_UP : integer := 7;
--        THRESHOLD_VALUE : real:=-55.0; --(-55mV)
--        MEMBRANE_POTENCJAL_VALUE: real:=-70.0; --(-70mV)
--        LEAKAGE: real:=5.0
--    );
--    port (
--        neuron_id: in std_logic_vector(8 downto 0);
--        clk: in std_logic;
--        rst: in std_logic;
--        input_neurons: in sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        spike: out std_logic;
--        neuron_address: out std_logic_vector(8 downto 0);
        
--        membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN)
--    );
--end component;

--component weight_matrix is
--    generic(
--        ADDRESS_LENGTH: natural := 2;
--        DATA_LENGTH: natural := 3;
--        NEURON_COUNT: natural := 2
--    );
--    port(
--        rst, clk, matrix_enable: in std_logic;
--        address: in std_logic_vector((NEURON_COUNT - 1) downto 0);
--        data_output: out std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0)
--    );
--end component;

--signals
signal matrix_enable_signal: std_logic;
signal spike_address: std_logic_vector((NEURON_COUNT - 1) downto 0);
signal data_output_signal: std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);

type address_array is array (0 to NEURON_COUNT-1) of std_logic_vector(8 downto 0);
type input_array is array (0 to NEURON_COUNT) of sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);

signal neuron_address_signal : address_array;
signal input_signal : input_array;

begin
    
    data_output_monitor <= data_output_signal;
    neuron_address_monitor <= spike_address;
    input_signal(0) <= external_input;
    
    input_gen: for i in 0 to NEURON_COUNT-1 generate
        input_signal(i+1) <= to_sfixed(to_integer(unsigned(data_output_signal((i + 1) * DATA_LENGTH - 1 downto i*DATA_LENGTH))), VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
    end generate input_gen;
    
    neuron_gen: for i in 0 to 1 generate
        component_neuron: entity work.top_neuron 
        generic map (
            VECTOR_WIDTH_DOWN => VECTOR_WIDTH_DOWN,
            VECTOR_WIDTH_UP => VECTOR_WIDTH_UP, 
            ADDRESS_WIDTH => ADDRESS_WIDTH,
            THRESHOLD_VALUE => THRESHOLD_VALUE,
            MEMBRANE_POTENCJAL_VALUE => MEMBRANE_POTENCJAL_VALUE,
            LEAKAGE => LEAKAGE,
            MEMBRANE_MAX_VALUE => MEMBRANE_MAX_VALUE,
            MEMBRANE_MIN_VALUE => MEMBRANE_MIN_VALUE,
            THRESHOLD_MAX_VALUE => THRESHOLD_MAX_VALUE
        )
        port map(
            neuron_id => std_logic_vector(to_unsigned(i+1, 9)),
            clk => clk,
            rst => rst,
            input_neurons => input_signal(i),
            spike => spike_monitor(i),
            neuron_address => neuron_address_signal(i),
            membrane_potential_monitor => open,
            leak_monitor => open,
            threshold_monitor => open
    );
    end generate neuron_gen;
    
    component_weight_matrix: entity work.weight_matrix 
    generic map (
        DATA_LENGTH => DATA_LENGTH,
        NEURON_COUNT => NEURON_COUNT
    )
    port map(
        rst => rst,
        clk => clk,
        matrix_enable => matrix_enable_signal,
        address => spike_address,
        data_output => data_output_signal
    );
    
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                spike_address <= (others => '0');
                matrix_enable_signal <= '0';
            else
                spike_address <= (others => '0');
                    for i in 0 to NEURON_COUNT-1 loop 
                        if to_integer(unsigned(neuron_address_signal(i))) /= 0 then
                            matrix_enable_signal <= '1';
                            spike_address((to_integer(unsigned(neuron_address_signal(i))))-1) <= '1';
                        end if;
                    end loop;                    
                end if;
            end if;
    end process;
end top_module_arch;


--for i in 0 to NEURON_COUNT-1 loop
--    input_signal(i+1) <= to_sfixed((data_output_signal((i + 1) * DATA_LENGTH - 1) downto (i*DATA_LENGTH)),VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
--end loop;