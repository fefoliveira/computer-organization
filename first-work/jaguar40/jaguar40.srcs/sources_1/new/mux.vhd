----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: mux - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- CRIACAO DO COMPONENTE MUX (2 pra 1):

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux is
    Port ( 
            mux_in0         : in std_logic_vector(11 downto 0);     -- Primeira entrada (12 bits)
            mux_in1         : in std_logic_vector(11 downto 0);     -- Segunda entrada  (12 bits)
            mux_out         : out std_logic_vector(11 downto 0);    -- Saida            (12 bits)
            jmp_cu_flag     : in std_logic;                         -- Flag de JMP que vem da unidade de controle
            beq_cu_flag     : in std_logic;                         -- Flag de BEQ que vem da unidade de controle
            beq_ula_flag    : in std_logic                          -- Flag de BEQ que vem da ULA
    );
end mux;

architecture Behavioral of mux is
        
        signal aux      : std_logic;
        signal mux_sel  : std_logic;
        
begin
    
    aux <= beq_cu_flag and beq_ula_flag;
    mux_sel  <= aux or jmp_cu_flag;
    
    mux_out <= mux_in0 when mux_sel = '0' else 
               mux_in1;

end Behavioral;
