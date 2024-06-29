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
        next_addr       : in std_logic_vector(11 downto 0)  -- Proxima linha (que vai esperar um endereco pro desvio)
        --branch_flag     : in std_logic -- Flag para permitir que o proximo endereco seja o do desvio e nao o sequencial ao atual => Serve para simular o MUX em um testbench unico                        
    );
end pc;

architecture Behavioral of pc is
    
    signal current_addr_internal : unsigned(11 downto 0) := (others => '0'); -- Sinal auxiliar para a soma do endereco da proxima linha

begin

    process(clk, reset)
    begin
        if reset = '1' then
            current_addr_internal <= (others => '0'); -- Reseta o contador
        elsif rising_edge(clk) then
            --if branch_flag = '1' then
                current_addr_internal <= unsigned(next_addr);
            --end if;
        end if;
    end process;

    current_addr <= std_logic_vector(current_addr_internal); -- Converte o valor auxiliar para a saida

end Behavioral;
