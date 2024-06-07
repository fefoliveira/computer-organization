----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gon�alves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO ARQUIVO DE TOPO:


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_jaguar40 is
end tb_jaguar40;

architecture Behavioral of tb_jaguar40 is

    -- Inputs:
    signal tb_clk       : std_logic := '0';
    signal tb_reset     : std_logic := '0';
    constant clk_period : time := 20 ns;

    -- Outputs:
    -- nenhum, por enquanto
begin

    -- Processo de clock:
    clk_process: process
    begin
        tb_clk <= '0';
        wait for clk_period/2;
        
        tb_clk <= '1';
        wait for clk_period/2;
    end process;
    
    U0_test: entity work.jaguar40(Behavioral)
        port map(
            clk => tb_clk,
            reset => tb_reset
        );

    -- Processo de estimulo:
    stim_proc: process
    begin
    
        wait for 400 ns;
    
    end process;
 
end Behavioral;
