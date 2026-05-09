----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2026 12:06:43 AM
-- Design Name: 
-- Module Name: top_module_tb - top_module_tb_arch
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
use STD.TEXTIO.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module_tb is
    generic(
        NEURON_ID : integer := 1;
        VECTOR_WIDTH_DOWN : integer := -8;
        VECTOR_WIDTH_UP : integer := 7;
        THRESHOLD_VALUE : real:=-55.0; --(-55mV)
        MEMBRANE_POTENCJAL_VALUE: real:=-70.0; --(-70mV)
        LEAKAGE: real:=5.0;
        
        NEURON_COUNT: natural := 2;
        DATA_LENGTH: natural := 3
    );
end top_module_tb;

architecture top_module_tb_arch of top_module_tb is
    component top_module is 
        port (
            clk: in std_logic;
            rst: in std_logic;
            external_input: in sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
            
            spike_monitor: out std_logic;
            data_output_monitor: out std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);
            membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
            leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
            threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
            
--            neuron_address_monitor: out std_logic_vector(8 downto 0)
            neuron_address_monitor: out std_logic_vector((NEURON_COUNT - 1) downto 0)

        );
    end component;
    
signal clk, rst, spike_monitor: std_logic;
signal external_input: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);


signal membrane_value:  sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal leak_monitor_value:  sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal threshold_monitor_value:  sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal data_output_monitor: std_logic_vector(((NEURON_COUNT * DATA_LENGTH) - 1) downto 0);
--signal neuron_address_monitor: std_logic_vector(8 downto 0);
signal neuron_address_monitor: std_logic_vector((NEURON_COUNT - 1) downto 0);

constant clk_period: time:= 50 ns;

begin
    uut: top_module port map(
        clk => clk,
        rst => rst,
        external_input => external_input,
        spike_monitor => spike_monitor,
        data_output_monitor => data_output_monitor,
        membrane_potential_monitor => membrane_value,
        leak_monitor => leak_monitor_value,
        threshold_monitor => threshold_monitor_value,
        neuron_address_monitor => neuron_address_monitor);
    
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
        
        while now < 1 ms loop
        
        rst <= '0';
        external_input <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 50 ns;
        
        rst <= '0';
        external_input <= to_sfixed(5.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 100 ns;
        
        rst <= '0';
        external_input <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 100 ns;
        
        rst <= '0';
        external_input <= to_sfixed(3.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 100 ns;
        
        rst <= '0';
        external_input <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 100 ns;
        
        rst <= '0';
        external_input <= to_sfixed(8.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 100 ns;
        
        rst <= '0';
        external_input <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 50 ns;
        
        rst <= '0';
        external_input <= to_sfixed(15.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 100 ns;
        
        rst <= '0';
        external_input <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
        wait for 100 ns;
    
        end loop;
        wait;
    end process; 
    
    write_process: process
        file output_file: text open write_mode is "neuron_simulation_output_top.txt";
        variable write_line: line;
        
        begin
            wait until rst = '0';
            wait for clk_period;
            
            while true loop
                wait until rising_edge(clk); 
                write(write_line, spike_monitor);
                write (write_line, string'(":"));
                write (write_line, to_integer(membrane_value));
                write (write_line, string'(" threshold:"));
                write (write_line, to_integer(threshold_monitor_value));
                write (write_line, string'(" leak:"));
                write (write_line, to_integer(leak_monitor_value));
                writeline(output_file, write_line);
            end loop;
         wait;
    end process;

end top_module_tb_arch;
