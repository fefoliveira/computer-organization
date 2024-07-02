----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: tb_jaguar40 - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO ARQUIVO DE TOPO:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_jaguar40 is
end tb_jaguar40;

architecture behavior of tb_jaguar40 is

    -- Inputs
    signal tb_clk   : std_logic := '0';
    signal tb_reset : std_logic := '0';

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instanciamento do arquio de topo (U1):
    U1: entity work.jaguar40
    port map (
        clk   => tb_clk,
        reset => tb_reset
    );

    -- Definicao do processo de clock:
    clk_process : process
    begin
        tb_clk <= '0';
        wait for clk_period/2;
        tb_clk <= '1';
        wait for clk_period/2;
    end process;

    -- Processo de estimulo
    stim_proc: process
    begin
        tb_reset <= '1';
        wait for clk_period/2 + 2.5ns;  

        tb_reset <= '0';
        wait for clk_period*10;
        
        wait;
    end process;

end behavior;
