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
use IEEE.NUMERIC_STD.ALL;

entity ula is
    Port ( 
            ula_in0     : in std_logic_vector(31 downto 0);     -- Primeira entrada (32 bits)
            ula_in1     : in std_logic_vector(31 downto 0);     -- Segunda entrada  (32 bits)
            ula_sel     : in std_logic_vector(3 downto 0);      -- Seletor          (3  bits - até 7 opções de operação)
            ula_out     : out std_logic_vector(31 downto 0);    -- Saída            (32 bits)
            beq_out     : out std_logic                         -- Saída "Zero"     (1 bit)
    );
end ula;

architecture Behavioral of ula is

    signal result   : std_logic_vector(31 downto 0); -- Variável temporária pro resutlado
    signal beq      : std_logic_vector(31 downto 0); -- Variável temporária pro beq_out
        
begin

    process (ula_in0, ula_in1, ula_sel)
    begin

        case ula_sel is
        
            when "0000" =>   -- BEQ
                beq <= std_logic_vector(unsigned(ula_in0) - unsigned(ula_in1));  -- Como os valores são vetores lógicos, é necessário convertelos para unsigned e depois reconverte-los em std_logic_vector
            when "0001" =>   -- ADD
                result <= std_logic_vector(unsigned(ula_in0) + unsigned(ula_in1));
            when "0010" =>   -- SUB
                result <= std_logic_vector(unsigned(ula_in0) - unsigned(ula_in1));
            when "0011" =>   -- AND
                result <= ula_in0 and ula_in1;
            when "0100" =>   -- OR
                result <= ula_in0 or ula_in1;    

        end case;          
    end process;

    ula_out <= result;
    beq_out <= '1' when beq = x"00000000" else
               '0';

end Behavioral;
