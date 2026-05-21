----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2026 06:05:16 PM
-- Design Name: 
-- Module Name: values_pkg - Behavioral
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
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.fixed_pkg.all;

package values_pkg is
    --number of neurons
    constant NEURON_COUNT : integer := 4;
    constant SENSOR_COUNT : integer := 1;
    --up and down value for sfixed values
    constant VECTOR_WIDTH_DOWN : integer := -8;
    constant VECTOR_WIDTH_UP : integer := 7;
    constant SFIXED_WIDTH : integer := 16;
    --lenght of neuron value
    constant ADDRESS_WIDTH : integer := 8;
    --value of initial threshold 
    constant THRESHOLD_VALUE : real := -30.0; 
    --value of initial membrance potencial
    constant MEMBRANE_POTENCJAL_VALUE : real := -50.0;
    --value of initial leak (not used)
    constant LEAKAGE : real := 5.0;
    --prevents neuron from too high or too low values
    constant MEMBRANE_MAX_VALUE : real := 40.0;
    constant MEMBRANE_MIN_VALUE : real := -90.0;
    constant THRESHOLD_MAX_VALUE : real := 0.0;
    --width of weight values
    constant WEIGHT_WIDTH : integer := 8;
    --width of memory row = number of neurons * width of weight value
    constant MEMORY_ROW_WIDTH : integer := (NEURON_COUNT * WEIGHT_WIDTH) + (SENSOR_COUNT * WEIGHT_WIDTH);
    
end package;