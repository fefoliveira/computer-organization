----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gon�alves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- CRIA��O DO COMPONENTE ULA:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula is
    Port ( 
            ula_in0     : in std_logic_vector(31 downto 0);     -- Primeira entrada (32 bits)
            ula_in1     : in std_logic_vector(31 downto 0);     -- Segunda entrada  (32 bits)
            ula_op     : in std_logic_vector(3 downto 0);      -- Seletor          (4  bits - at� 15 op��es de opera��o)
            ula_out     : out std_logic_vector(31 downto 0);    -- Sa�da            (32 bits)
            beq_out     : out std_logic                         -- Flag "Zero"      (1 bit)
    );
end ula;

architecture Behavioral of ula is

    signal result   : std_logic_vector(31 downto 0); -- Vari�vel tempor�ria pro resutlado
    signal beq      : std_logic_vector(31 downto 0); -- Vari�vel tempor�ria pro beq_out
        
begin

    process (ula_in0, ula_in1, ula_op)
    begin

        case ula_op is
        
            when "0000" =>   -- BEQ
                beq <= std_logic_vector(unsigned(ula_in0) - unsigned(ula_in1)); -- Como os valores s�o vetores l�gicos, � necess�rio convertelos para unsigned e depois reconverte-los em std_logic_vector
            when "0001" =>   -- ADD
                result <= std_logic_vector(unsigned(ula_in0) + unsigned(ula_in1));
            when "0010" =>   -- SUB
                result <= std_logic_vector(unsigned(ula_in0) - unsigned(ula_in1));
            when "0011" =>   -- AND
                result <= ula_in0 and ula_in1;
            when "0100" =>   -- OR
                result <= ula_in0 or ula_in1;    
            when others => null;
                result <= x"00000000";

        end case;          
    end process;

    ula_out <= result;
    beq_out <= '1' when beq = x"00000000" else
               '0';

end Behavioral;
