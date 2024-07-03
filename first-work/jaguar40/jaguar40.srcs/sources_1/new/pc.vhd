----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: pc - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- PROGRAM COUNTER (PC):

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
    Port (
        clk             : in std_logic; -- Sinal de clock
        reset           : in std_logic; -- Sinal de reset
        current_addr    : out std_logic_vector(11 downto 0); -- Linha atual
        next_addr       : in std_logic_vector(11 downto 0);  -- Proxima linha (que vai esperar um endereco pro desvio)     
        enable_flag     : in std_logic;
        jmp_cu_flag     : in std_logic;                         -- Flag de JMP que vem da unidade de controle
        beq_cu_flag     : in std_logic;                         -- Flag de BEQ que vem da unidade de controle
        beq_ula_flag    : in std_logic                         -- Flag de BEQ que vem da ULA    
    );
end pc;

architecture Behavioral of pc is
    
    signal current_addr_aux : std_logic_vector(11 downto 0) := x"000"; -- Sinal auxiliar para a soma do endereco da proxima linha
    signal branch_aux1      : std_logic;
    signal branch_aux2      : std_logic;
begin

    branch_aux1 <= beq_cu_flag and beq_ula_flag;
        branch_aux2 <= branch_aux1 or jmp_cu_flag;

    process(clk, reset)
    begin
        if reset = '1' then
            current_addr_aux <= x"000"; -- Reseta o contador
        elsif rising_edge(clk) then
            if(enable_flag = '1') then
            
                if(branch_aux2 = '1') then
                    current_addr_aux <= next_addr;
                elsif(beq_cu_flag = '0') then
                    current_addr_aux <= std_logic_vector(unsigned(current_addr_aux) + 1);    
                end if;
                
            end if;
        end if;
    end process;

    current_addr <= current_addr_aux; -- Converte o valor auxiliar para a saida

end Behavioral;
