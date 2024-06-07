----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gon�alves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO COMPONENTE MUX (2 pra 1):

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux is
end tb_mux;

architecture Behavioral of tb_mux is
    
    -- Inputs
    signal tb_mux_in0  : std_logic_vector(11 downto 0) := (others => '0');
    signal tb_mux_in1  : std_logic_vector(11 downto 0) := (others => '0');
    signal tb_mux_sel  : std_logic := '0';
    
    -- Outputs
    signal tb_mux_out  : std_logic_vector(11 downto 0);
    
begin

    -- Instanciamento do mux (U1):
    U1_test: entity work.mux(Behavioral)
        port map(
            mux_in0 => tb_mux_in0,
            mux_in1 => tb_mux_in1,
            mux_sel => tb_mux_sel,
            mux_out => tb_mux_out            
        );

    -- Processo de est�mulo:
    stim_proc: process
    begin
        tb_mux_in0 <= x"00F";
        tb_mux_in1 <= x"F00";
        
        tb_mux_sel <= '0';
        wait for 100 ns;
        
        tb_mux_sel <= '1';
        wait for 100 ns;
        
        tb_mux_sel <= '0';
        wait for 100 ns;
    
    end process;
    
end Behavioral;
