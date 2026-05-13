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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity neuron_tb is
generic(
       VECTOR_WIDTH_DOWN : integer := -8;
       VECTOR_WIDTH_UP : integer := 7;
       ADDRESS_WIDTH: integer := 8;
       THRESHOLD_VALUE : real := -30.0; 
       MEMBRANE_POTENCJAL_VALUE: real := -50.0;
       LEAK: real := 5.0;
       MEMBRANE_MAX_VALUE: real := 40.0;
       MEMBRANE_MIN_VALUE: real := -90.0;
       THRESHOLD_MAX_VALUE: real := 0.0
    );
end neuron_tb;

architecture neuron_tb_arch of neuron_tb is
component top_neuron is
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
end component;

signal clk, rst, spike: std_logic;
signal input_neurons: sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal neuron_address: std_logic_vector(8 downto 0);


signal membrane_value:  sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal leak_monitor_value:  sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal threshold_monitor_value:  sfixed(VECTOR_WIDTH_UP downto VECTOR_WIDTH_DOWN);
signal neuron_id: std_logic_vector(8 downto 0);

constant clk_period: time:= 50 ns;

begin

    uut: top_neuron port map(
    neuron_id => neuron_id,
    clk => clk,
    rst => rst,
    input_neurons => input_neurons,
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
            wait for clk_period;
            
            while now < 1 ms loop
            
            rst <= '0';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 50 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(5.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(3.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(8.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 50 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(15.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(3.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(0.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
            wait for 100 ns;
            
            rst <= '0';
            input_neurons <= to_sfixed(3.0,VECTOR_WIDTH_UP,VECTOR_WIDTH_DOWN);
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
                write (write_line, to_real(membrane_value));
                write (write_line, string'(" threshold:"));
                write (write_line, to_real(threshold_monitor_value));
                write (write_line, string'(" leak:"));
                write (write_line, to_real(leak_monitor_value));
                writeline(output_file, write_line);
            end loop;
         wait;
    end process;
end neuron_tb_arch;
