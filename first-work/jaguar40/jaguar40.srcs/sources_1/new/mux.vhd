----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gon�alves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- CRIA��O DO COMPONENTE MUX (2 pra 1):

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Port ( 
            mux_in0     : in std_logic_vector(11 downto 0);     -- Primeira entrada (12 bits)
            mux_in1     : in std_logic_vector(11 downto 0);     -- Segunda entrada  (12 bits)
            mux_out     : out std_logic_vector(11 downto 0);    -- Sa�da           (12 bits)
            mux_sel     : in std_logic                          -- Seletor          (1  bit)
    );
end mux;

architecture Behavioral of mux is
        
begin

    mux_out <= mux_in0 when mux_sel = '0' else 
               mux_in1;

end Behavioral;
