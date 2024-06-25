----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: tb_control_unit - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- TESTBENCH DA UNIDADE DE CONTROLE:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_control_unit is
end tb_control_unit;

architecture Behavioral of tb_control_unit is
    
    -- Input
    signal tb_opcode   : std_logic_vector(4 downto 0);
    
    -- Outputs
    signal tb_jmp          : std_logic;
    signal tb_beq          : std_logic;
    signal tb_ula_op       : std_logic_vector(3 downto 0);
    signal tb_mem_read     : std_logic;
    signal tb_mem_write    : std_logic;
    signal tb_reg_write    : std_logic;
    
begin

    -- Instanciamento da unidade de controle (U5):
    U5_test: entity work.control_unit(Behavioral)
        port map(
            opcode      => tb_opcode,
            jmp         => tb_jmp,
            beq         => tb_beq,
            ula_op      => tb_ula_op,
            mem_read    => tb_mem_read, 
            mem_write   => tb_mem_write,
            reg_write   => tb_reg_write
        );

    -- Processo de estimulo:
    stim_proc: process
    begin
        
        tb_opcode <= "00000";   -- JMP
        wait for 50ns;
        
        tb_opcode <= "00001";   -- BEQ
        wait for 50ns;
        
        tb_opcode <= "00010";   -- LOAD
        wait for 50ns;
        
        tb_opcode <= "00011";   -- STR
        wait for 50ns;
        
        tb_opcode <= "00100";   -- AND
        wait for 50ns;
        
        tb_opcode <= "00101";   -- OR
        wait for 50ns;
        
        tb_opcode <= "00110";   -- ADD
        wait for 50ns;
        
        tb_opcode <= "00111";   -- SUB
        wait for 50ns;
        
        tb_opcode <= "11111";   -- HLT
        wait for 50ns;
        
    end process;
    
end Behavioral;
