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
    signal tb_ula_sel  : std_logic_vector(3 downto 0)  := (others => '0');
    
    -- Outputs
    signal tb_ula_out  : std_logic_vector(31 downto 0);
    signal tb_beq_out  : std_logic; 
    
begin

    -- Instanciamento da ULA (U2):
    U2_test: entity work.ula(Behavioral)
        port map(
            ula_in0 => tb_ula_in0,
            ula_in1 => tb_ula_in1,
            ula_sel => tb_ula_sel,
            ula_out => tb_ula_out,     
            beq_out => tb_beq_out       
        );

    -- Processo de estímulo:
    stim_proc: process
    begin
        tb_ula_in0 <= x"0000000F";
        tb_ula_in1 <= x"00000005";
        
        tb_ula_sel <= "0000";   -- BEQ
        wait for 100 ns;
        
        tb_ula_sel <= "0001";   -- ADD
        wait for 100 ns;
        
        tb_ula_sel <= "0010";   -- SUB
        wait for 100 ns;
        
        tb_ula_sel <= "0011";   -- AND
        wait for 100 ns;
        
        tb_ula_sel <= "0100";   -- OR
        wait for 100 ns;
        
    end process;
    
end Behavioral;
