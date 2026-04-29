----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 12:06:51 AM
-- Design Name: 
-- Module Name: weight_matrix_tb - weight_matrix_tb_arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity weight_matrix_tb is
    generic (
        ADDRESS_LENGTH: natural := 2;
        DATA_LENGTH: natural := 3;
        NEURON_COUNT: natural := 2
    );
end weight_matrix_tb;

architecture weight_matrix_tb_arch of weight_matrix_tb is

component weight_matrix is
    port(
        clk: in std_logic;
        matrix_enable: in std_logic_vector;
        address: in std_logic_vector((NEURON_COUNT- 1) downto 0);
        data_output: out std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0)
    );
end component;

signal clk, matrix_enable: std_logic;
signal address: std_logic_vector(((NEURON_COUNT *ADDRESS_LENGTH) - 1) downto 0);
signal data_output: std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);

constant clk_period: time:= 50 ns;

begin
    uut: top_neuron port map(
    clk => clk,
    matrix_enable => matrix_enable,
    address => address,
    data_output => data_output);
    
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
            wait for clk_period;
            
            rst <= '0';
            address <= '0110';
            wait for 50 ns;
    
    end process; 
end weight_matrix_tb_arch;
