----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2026 12:20:25 AM
-- Design Name: 
-- Module Name: weight_memory - weight_memory_arch
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

entity weight_memory is
    port (
        clk: in std_logic;
        neuron_address: in std_logic_vector(ADDRESS_WIDTH downto 0); 
        data_out: out std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0)
    );
end weight_memory;

architecture weight_memory_arch of weight_memory is
    type ram_type is array (0 to SENSOR_COUNT + NEURON_COUNT-1) of std_logic_vector(MEMORY_ROW_WIDTH-1 downto 0);
    
    --0 ALML (sensor)
    --1 PVCR
    --2 AVBL
    --3 AVDR
    --4 AVAR
    
    signal RAM : ram_type := (
         0 => std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  -- ALML (sensor)
              std_logic_vector(to_signed(1, WEIGHT_WIDTH)) &  -- N_ID3 (AVAR) 
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  -- N_ID2 (AVDR)
              std_logic_vector(to_signed(-2, WEIGHT_WIDTH)) & -- N_ID1 (AVBL) 
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)),   -- N_ID0 (PVCR)
                 
         1 => std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(7, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(1, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(8, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)),   
                 
         2 => std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(7, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(2, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)),   
                 
         3 => std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(15, WEIGHT_WIDTH)) & 
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(1, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)),   
                 
         4 => std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(2, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(0, WEIGHT_WIDTH)) &  
              std_logic_vector(to_signed(0, WEIGHT_WIDTH))    
    );
    
    attribute ram_style : string;
    attribute ram_style of RAM : signal is "block";

begin
    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= RAM(to_integer(unsigned(neuron_address)));
        end if;
    end process;
end weight_memory_arch;