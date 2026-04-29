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
        ADDRESS_LENGTH: natural := 2;
        DATA_LENGTH: natural := 3;
        NEURON_COUNT: natural := 2
    );
    port(
        clk, matrix_enable: in std_logic;
        address: in std_logic_vector((NEURON_COUNT - 1) downto 0);
        data_output: out std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0)
    );
end weight_matrix;

architecture weight_matrix_arch of weight_matrix is
    subtype row_type is std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);
    type matrix_type is array (0 to NEURON_COUNT - 1) of row_type;

    constant weights : matrix_type := (
        0 => "011" & "101", 
        1 => "111" & "001"  
    );
    
begin
    process (clk) is
        begin
            if rising_edge(clk) then
                if matrix_enable = '1' then
                    for i in 0 to NEURON_COUNT - 1 loop
                        if address(i) = '1' then
                            data_output(i*DATA_LENGTH-1 downto i) <= weights(i);
                        end if;
                    end loop;
                end if;
            end if;
    end process; 
    
end weight_matrix_arch;
