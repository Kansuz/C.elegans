----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 03:19:44 PM
-- Design Name: 
-- Module Name: weight_matrix - weight_matrix_arch
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

entity weight_matrix is
    generic(
        DATA_LENGTH: integer := 3;
        NEURON_COUNT: integer := 2
    );
    port(
        rst, clk, matrix_enable: in std_logic;
        address: in std_logic_vector((NEURON_COUNT - 1) downto 0);
        data_output: out std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0)
    );
end weight_matrix;

architecture weight_matrix_arch of weight_matrix is

    subtype row_type is std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);
    type matrix_type is array (0 to NEURON_COUNT - 1) of row_type;

    constant weights : matrix_type := (
        0 => "011" & "111", 
        1 => "111" & "001"  
    );
    
begin
    process (clk) is
        variable v_sum : std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);
        variable low, high : integer;
        begin
            if rising_edge(clk) then
                if rst = '1' then 
                    data_output <= (others => '0'); 
                    v_sum := (others => '0'); 
                
                elsif matrix_enable = '1' then
                    v_sum := (others => '0'); 
                    for i in 0 to NEURON_COUNT - 1 loop
                        if address(i) = '1' then
                            for seg in 0 to NEURON_COUNT - 1 loop
                                low  := seg * DATA_LENGTH;
                                high := (seg + 1) * DATA_LENGTH - 1;
                        
                                v_sum(high downto low) := 
                                    std_logic_vector(unsigned(v_sum(high downto low)) + unsigned(weights(i)(high downto low)));
--                            data_output <= weights(i);
                            end loop;
                        end if;
                    end loop;
                    data_output <= v_sum;
                end if;
            end if;
    end process; 
    
end weight_matrix_arch;
