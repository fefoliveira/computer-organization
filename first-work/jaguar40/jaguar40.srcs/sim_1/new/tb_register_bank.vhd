----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gon�alves
-- Create Date: 01.05.2024 17:46:43
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO BANCO DE REGISTRADORES:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
        
        tb_Rd_addr <= "0000";
        tb_R1_addr <= "0001";
        tb_R2_addr <= "0010";
        wait for 25 ns;

        tb_reg_write <= '1';
        tb_Rd_write <= tb_R1_read and tb_R2_read;
        wait for 25 ns;
        
        wait;
        
    end process;

end Behavioral;
