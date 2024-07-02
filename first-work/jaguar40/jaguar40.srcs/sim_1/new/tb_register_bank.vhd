----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: tb_register_bank - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO BANCO DE REGISTRADORES:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_register_bank is
end tb_register_bank;

architecture Behavioral of tb_register_bank is

    -- Inputs:
    signal tb_Rd_addr   : std_logic_vector(3 downto 0)  := (others => '0');
    signal tb_R1_addr   : std_logic_vector(3 downto 0)  := (others => '0');
    signal tb_R2_addr   : std_logic_vector(3 downto 0)  := (others => '0');
    signal tb_Rd_write  : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_reg_write : std_logic := '0';
    
    -- Outputs:
    signal tb_R1_read   : std_logic_vector(31 downto 0);
    signal tb_R2_read   : std_logic_vector(31 downto 0);
    
begin
   
    -- Instanciamento do Banco de Registradores (U3):
    U3_test: entity work.register_bank(Behavioral)
    port map(
        Rd_addr   => tb_Rd_addr,
        R1_addr   => tb_R1_addr,
        R2_addr   => tb_R2_addr,
        R1_read   => tb_R1_read,
        R2_read   => tb_R2_read,
        Rd_write  => tb_Rd_write,
        reg_write => tb_reg_write
        );
        
    -- Processo de estimulo:
    stim_proc: process
    begin
        
        -- Leitura de todos os registradores (teste do r1_read e r2_read)
        for i in 0 to 15 loop -- For para atribuir um a um os enderecos de cada registrados, para mostrar seus valores iniciais na simulacao
            tb_R1_addr <= std_logic_vector(to_unsigned(I, 4));
            tb_R2_addr <= std_logic_vector(to_unsigned(I+1, 4));
            wait for 25ns;
        end loop;
        
        -- Escrita no Rd
        tb_Rd_addr <= "0000";
        -- tb_Rd_write <= tb_R1_read and tb_R2_read;
        tb_Rd_write <= x"FEFEFEFE";
        wait for 50 ns;

        tb_reg_write <= '1';
        wait for 5ns;
        
        tb_reg_write <= '0';
        wait for 5ns;
        
    end process;

end Behavioral;