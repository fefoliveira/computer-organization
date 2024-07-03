----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: intermed_register - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- REGISTRADOR INTERMEDIARIO PARA A SAIDA DA ULA:


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;

entity intermed_register_ula is
    Port(
        clk         : in std_logic;
        write_on    : in std_logic;
        ula_in      : in std_logic_vector(31 downto 0);
        ula_out     : out std_logic_vector(31 downto 0)
        
    );
end intermed_register_ula;

architecture Behavioral of intermed_register_ula is
    signal data_out : std_logic_vector(31 downto 0);

    begin
    process(clk, write_on, ula_in)
    begin
        if rising_edge(clk) then
            if write_on = '1' then
                 data_out <= ula_in;
            end if;
        end if; 
    end process;
    
    ula_out <= data_out;
    
end Behavioral;