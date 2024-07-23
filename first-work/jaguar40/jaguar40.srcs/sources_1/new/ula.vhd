----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: ula - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- CRIACAO DO COMPONENTE ULA:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula is
    Port ( 
            ula_in0     : in std_logic_vector(31 downto 0);     -- Primeira entrada (32 bits)
            ula_in1     : in std_logic_vector(31 downto 0);     -- Segunda entrada  (32 bits)
            ula_op      : in std_logic_vector(3 downto 0);      -- Seletor          (4  bits - ate 15 possiveis operacoes)
            ula_out     : out std_logic_vector(31 downto 0);    -- Saida            (32 bits)
            beq_out     : out std_logic;                 -- Flag "Zero"      (1 bit)
            ula_out_r1  : in std_logic_vector(31 downto 0);      -- Entrada da sida pro ADDS
            ula_r1_sel  : in std_logic        
    );
end ula;

architecture Behavioral of ula is

    signal result   : std_logic_vector(31 downto 0); -- Variavel temporaria pro resutlado
    signal beq      : std_logic_vector(31 downto 0); -- Variavel temporaria pro beq_out
    signal in0_aux  : std_logic_vector(31 downto 0); -- Variavel temporaria pro beq_out
        
begin

    process (ula_in0, ula_in1, ula_op, ula_out_r1, ula_r1_sel)
    begin
        
        if ula_r1_sel = '1' then
            in0_aux <= ula_out_r1;
        else    
        in0_aux <= ula_in0;
        end if;

        case ula_op is
        
            when "0000" =>   -- BEQ
                beq <= std_logic_vector(unsigned(in0_aux) - unsigned(ula_in1)); -- Como os valores sao vetores logicos, e necessario convertelos para unsigned e depois reconverte-los em std_logic_vector
            when "0001" =>   -- AND
                result <= in0_aux and ula_in1;
            when "0010" =>   -- OR
                 result <= in0_aux or ula_in1;  
            when "0011" =>   -- ADD
                 result <= std_logic_vector(unsigned(in0_aux) + unsigned(ula_in1));
            when "0100" =>   -- SUB
                 result <= std_logic_vector(unsigned(in0_aux) - unsigned(ula_in1));
            when others =>
                result <= x"FEFEFEFE";

        end case;          
    end process;

    ula_out <= result;
    beq_out <= '1' when beq = x"00000000" else
               '0';

end Behavioral;
