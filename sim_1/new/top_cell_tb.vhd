----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/18/2026 02:46:08 PM
-- Design Name: 
-- Module Name: top_cell_tb - top_cell_tb_arch
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
use work.values_pkg.all;
use IEEE.numeric_std.all;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity top_cell_tb is
end top_cell_tb;

architecture top_cell_tb_arch of top_cell_tb is

component top_cell is 
    port(
        rst, clk: in std_logic;
        external_spike_bus_signal: in std_logic_vector(SENSOR_COUNT-1 downto 0);
        
--        membrane_potential_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        leak_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--        threshold_monitor: out sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);

        membrane_potential_monitor: out std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);
        leak_monitor: out std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);
        threshold_monitor: out std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);

        bus_done_monitor: out std_logic
    );
end component;

signal rst, clk: std_logic;
signal external_spike_bus_signal: std_logic_vector(SENSOR_COUNT-1 downto 0);

--signal membrane_potential_monitor_signal: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--signal leak_monitor_signal: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
--signal threshold_monitor_signal: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);

signal membrane_potential_monitor_signal: std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);
signal leak_monitor_signal: std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);
signal threshold_monitor_signal: std_logic_vector(SFIXED_WIDTH*NEURON_COUNT-1 downto 0);

signal bus_done_monitor_signal: std_logic;

constant clk_period: time:= 50 ns;

begin
    uut: top_cell port map(
    clk => clk,
    rst => rst,
    external_spike_bus_signal => external_spike_bus_signal,
    membrane_potential_monitor => membrane_potential_monitor_signal,
    leak_monitor => leak_monitor_signal,
    threshold_monitor => threshold_monitor_signal,
    bus_done_monitor => bus_done_monitor_signal
    );
    
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
            external_spike_bus_signal(0) <= '0';
            wait for clk_period;
            
            while now < 1 ms loop
            
            rst <= '0';
            external_spike_bus_signal(0) <= '1';
            wait until rising_edge(clk) and bus_done_monitor_signal = '1';
            external_spike_bus_signal(0) <= '0'; 
            wait until rising_edge(clk);
            
            rst <= '0';
            external_spike_bus_signal(0) <= '1';
            wait until rising_edge(clk) and bus_done_monitor_signal = '1';
            external_spike_bus_signal(0) <= '0'; 
            wait until rising_edge(clk);
            
            rst <= '0';
            external_spike_bus_signal(0) <= '1';
            wait until rising_edge(clk) and bus_done_monitor_signal = '1';
            external_spike_bus_signal(0) <= '0'; 
            wait until rising_edge(clk);
            
            rst <= '0';
            external_spike_bus_signal(0) <= '1';
            wait until rising_edge(clk) and bus_done_monitor_signal = '1';
            external_spike_bus_signal(0) <= '0'; 
            wait until rising_edge(clk);
            
            rst <= '0';
            external_spike_bus_signal(0) <= '1';
            wait until rising_edge(clk) and bus_done_monitor_signal = '1';
            external_spike_bus_signal(0) <= '0'; 
            wait until rising_edge(clk);
            
            rst <= '0';
            external_spike_bus_signal(0) <= '1';
            wait until rising_edge(clk) and bus_done_monitor_signal = '1';
            external_spike_bus_signal(0) <= '0'; 
            wait until rising_edge(clk);
            
            end loop;
            wait;
    end process; 
    
--     write_process: process
--        file output_file: text open write_mode is "neuron_simulation_output_top.txt";
--        variable write_line: line;
        
--        begin
--            wait until rst = '0';
--            wait for clk_period;
            
--            while true loop
--                wait until rising_edge(clk); 
--                write(write_line, bus_done_monitor_signal);
--                write (write_line, string'(":"));
--                write (write_line, to_integer(membrane_potential_monitor_signal));
--                write (write_line, string'(" threshold:"));
--                write (write_line, to_integer(threshold_monitor_signal));
--                write (write_line, string'(" leak:"));
--                write (write_line, to_real(leak_monitor_signal));
--                writeline(output_file, write_line);
--            end loop;
--         wait;
--    end process;

    write_process: process
        file output_file: text open write_mode is "neuron_simulation_output_top.txt";
        variable write_line: line;
        variable current_val_sfixed : sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
    begin
        wait until rst = '0';
        wait for clk_period;
        
        while true loop
            wait until rising_edge(clk); 
            
            write(write_line, string'("BUS_DONE="));
            write(write_line, bus_done_monitor_signal);
            write(write_line, string'(" | "));
            
            for i in 0 to NEURON_COUNT-1 loop
                write(write_line, string'("N_ID"));
                write(write_line, i);
                write(write_line, string'(": "));
                
                current_val_sfixed := to_sfixed(membrane_potential_monitor_signal((i+1)*SFIXED_WIDTH-1 downto 
                i*SFIXED_WIDTH), VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
                
                write(write_line, string'("V="));
                write(write_line, to_integer(current_val_sfixed));
                
                current_val_sfixed := to_sfixed(threshold_monitor_signal((i+1)*SFIXED_WIDTH-1 downto 
                i*SFIXED_WIDTH), VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
                
                write(write_line, string'(" T= "));
                write(write_line, to_integer(current_val_sfixed));
                
                current_val_sfixed := to_sfixed(leak_monitor_signal((i+1)*SFIXED_WIDTH-1 downto 
                i*SFIXED_WIDTH), VECTOR_WIDTH_UP, VECTOR_WIDTH_DOWN);
                write(write_line, string'(" L="));
                write(write_line, to_integer(current_val_sfixed));
                
                if i /= NEURON_COUNT-1 then
                    write(write_line, string'(" ; "));
                end if;
            end loop;
            
            writeline(output_file, write_line);
        end loop;
        wait;
    end process;

end top_cell_tb_arch;
