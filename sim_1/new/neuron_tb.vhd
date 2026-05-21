----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2025 21:30:47
-- Design Name: 
-- Module Name: neuron_tb - neuron_tb_arch
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
use IEEE.fixed_pkg.all;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use work.values_pkg.all;

entity neuron_tb is
end neuron_tb;

architecture neuron_tb_arch of neuron_tb is
component neuron is
    port (
        neuron_id: in std_logic_vector(8 downto 0);
        clk: in std_logic;
        rst: in std_logic;
        bus_done: in std_logic;
        weight_valid: in std_logic;
        input_neurons: in sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        spike: out std_logic;
        neuron_address: out std_logic_vector(8 downto 0);
        
        membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
        threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN)
    );
end component;

signal clk, rst, spike, bus_done, weight_valid: std_logic;
signal input_neurons: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal neuron_address: std_logic_vector(8 downto 0);


signal membrane_value: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal leak_monitor_value: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal threshold_monitor_value: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal neuron_id: std_logic_vector(8 downto 0);

constant clk_period: time:= 50 ns;

begin

    uut: neuron port map(
    neuron_id => neuron_id,
    clk => clk,
    rst => rst,
    input_neurons => input_neurons,
    bus_done => bus_done,
    weight_valid => weight_valid,
    spike => spike,
    neuron_address => neuron_address,
    membrane_potential_monitor => membrane_value,
    leak_monitor => leak_monitor_value,
    threshold_monitor => threshold_monitor_value);
    
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
            neuron_id <= "000000001";
            weight_valid <= '0';
            bus_done <= '0';
            wait for clk_period;
            
            while now < 1 ms loop
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '0';
            wait for 50 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(5.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(3.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(8.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 50 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(15.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '0';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(3.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            rst <= '0';
            weight_valid <= '1';
            input_neurons <= to_sfixed(3.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            bus_done <= '1';
            wait for 100 ns;
            
            end loop;
            wait;
    end process; 
    
    write_process: process
        file output_file: text open write_mode is "neuron_simulation_output.txt";
        variable write_line: line;
        
        begin
            wait until rst = '0';
            wait for clk_period;
            
            while true loop
                wait until rising_edge(clk); 
                write(write_line, spike);
                write (write_line, string'(":"));
                write (write_line, to_integer(membrane_value));
                write (write_line, string'(" threshold:"));
                write (write_line, to_integer(threshold_monitor_value));
                write (write_line, string'(" leak:"));
                write (write_line, to_real(leak_monitor_value));
                writeline(output_file, write_line);
            end loop;
         wait;
    end process;
end neuron_tb_arch;
