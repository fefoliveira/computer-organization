----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gonçalves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- CRIAÇÃO DO COMPONENTE ULA:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ula is
    Port ( 
            ula_in0     : in std_logic_vector(31 downto 0);     -- Primeira entrada (32 bits)
            ula_in1     : in std_logic_vector(31 downto 0);     -- Segunda entrada  (32 bits)
            ula_out     : out std_logic_vector(31 downto 0);    -- Saída            (32 bits)
            ula_sel     : in std_logic_vector(2 downto 0);      -- Seletor          (3  bits - até 7 opções de operação)
            beq_out     : out std_logic                         -- Saída da operação "BEQ" 
    );
end ula;

architecture Behavioral of ula is
        
begin

    -- Lógica da ULA

end Behavioral;
