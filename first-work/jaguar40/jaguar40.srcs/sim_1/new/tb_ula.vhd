----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gonçalves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO COMPONENTE ULA:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ula is
end tb_ula;

architecture Behavioral of tb_ula is
    
    -- Inputs
    signal tb_ula_in0  : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_ula_in1  : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_ula_sel  : std_logic_vector(2 downto 0)  := (others => '0');
    
    -- Outputs
    signal tb_ula_out  : std_logic_vector(31 downto 0);
    
begin

    -- Instanciamento da ULA (U2):
    U2_test: entity work.ula(Behavioral)
        port map(
            ula_in0 => tb_ula_in0,
            ula_in1 => tb_ula_in1,
            ula_sel => tb_ula_sel,
            ula_out => tb_ula_out            
        );

    -- Processo de estímulo:
    stim_proc: process
    begin
    
        -- Teste
    
    end process;
    
end Behavioral;
