----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: tb_memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DO COMPONENTE MEMORY:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_memory is
end tb_memory;

architecture Behavioral of tb_memory is

    -- Inputs
    signal tb_clk                 : std_logic := '0';
    signal tb_reset               : std_logic := '0';
    signal tb_instr_mem_in        : std_logic_vector(11 downto 0) := (others => '0');
    signal tb_data_write_on       : std_logic := '0';
    signal tb_data_read_on        : std_logic := '0';
    signal tb_data_mem_addr       : std_logic_vector(11 downto 0) := (others => '0');
    signal tb_data_mem_in         : std_logic_vector(31 downto 0) := (others => '0');

    -- Outputs
    signal tb_instr_mem_out_opcode: std_logic_vector(4 downto 0);
    signal tb_instr_mem_out_Rd    : std_logic_vector(3 downto 0);
    signal tb_instr_mem_out_R1    : std_logic_vector(3 downto 0);
    signal tb_instr_mem_out_R2    : std_logic_vector(3 downto 0);
    signal tb_instr_mem_out_addr  : std_logic_vector(11 downto 0);
    signal tb_data_mem_out        : std_logic_vector(31 downto 0);

    -- Definicao do periodo de clock
    constant clk_period : time := 10 ns;

begin

    -- Instanceamento da memoria (U6)
    U6: entity work.memory(Behavioral)
    Port map (
        clk => tb_clk,
        reset => tb_reset,
        instr_mem_in => tb_instr_mem_in,
        instr_mem_out_opcode => tb_instr_mem_out_opcode,
        instr_mem_out_Rd => tb_instr_mem_out_Rd,
        instr_mem_out_R1 => tb_instr_mem_out_R1,
        instr_mem_out_R2 => tb_instr_mem_out_R2,
        instr_mem_out_addr => tb_instr_mem_out_addr,
        data_write_on => tb_data_write_on,
        data_read_on => tb_data_read_on,
        data_mem_addr => tb_data_mem_addr,
        data_mem_in => tb_data_mem_in,
        data_mem_out => tb_data_mem_out
    );

    -- Definicao do processo de clock:
    clk_process :process
    begin
        tb_clk <= '0';
        wait for clk_period/2;
        tb_clk <= '1';
        wait for clk_period/2;
    end process;

    -- Processo de estimulo:
    stim_proc: process
    begin
        -- Inicializa a memoria
        tb_reset <= '1';
        wait for clk_period*2;
        tb_reset <= '0';
        wait for clk_period*2;

        -- Escreve algo na memoria de dados
        tb_data_write_on <= '1';
        tb_data_mem_addr <= x"000";
        tb_data_mem_in <= x"AAAAAAAA";
        wait for clk_period;
        tb_data_write_on <= '0';
        wait for clk_period;

        -- Le algo da memoria de dados
        tb_data_read_on <= '1';
        tb_data_mem_addr <= x"000";
        wait for clk_period;
        tb_data_read_on <= '0';
        wait for clk_period;

        -- Testes na memoria de instrucoes para ver se esta dividindo a instrucoes corretamente
        tb_instr_mem_in <= x"000";
        wait for clk_period;
        tb_instr_mem_in <= x"00F";
        wait for clk_period;
        
        wait;
    end process;

end Behavioral;
