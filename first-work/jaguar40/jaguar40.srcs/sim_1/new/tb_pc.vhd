----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: tb_pc - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO PROGRAM COUNTER (PC):

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_pc is
end tb_pc;

architecture Behavioral of tb_pc is
    
    -- Inputs
    signal tb_clk : std_logic := '0';
    signal tb_reset : std_logic := '0';
    signal tb_next_addr : std_logic_vector(11 downto 0);
    signal tb_branch_flag : std_logic;

    -- Output
    signal tb_current_addr : std_logic_vector(11 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Criacao do clock
    clk_process: process
    begin
        while True loop
            tb_clk <= '0';
            wait for clk_period/2;
            tb_clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Instanciamento do PC (U4)
    U4_test: entity work.pc(Behavioral)
    port map (
        clk => tb_clk,
        reset => tb_reset,
        current_addr => tb_current_addr,
        next_addr => tb_next_addr,
        branch_flag => tb_branch_flag
    );

    -- Processo de estimulo
    stim_process: process
    begin
        
        -- Reset do PC
        tb_reset <= '1';
        wait for 20 ns;
        tb_reset <= '0';

        -- Teste sem desvio, apenas incremento de proxima linha
        tb_next_addr <= (others => '0');
        tb_branch_flag <= '0';
        wait for 25 ns;

        -- Teste com desvio para um novo endereco
        tb_next_addr <= x"010";
        tb_branch_flag <= '1';
        wait for 25 ns;

        -- Teste de incremento pós desvio
        tb_branch_flag <= '0';
        wait for 25 ns;

        -- Mais um desvio para outro endereco
        tb_next_addr <= x"020";
        tb_branch_flag <= '1';
        wait for 25 ns;

        -- Incremento após o segundo desvio
        tb_branch_flag <= '0';
        wait for 25 ns;

        wait;
        
    end process;

end Behavioral;
