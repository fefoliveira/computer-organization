---------------------------------------------------------------------------------- 
-- Company: UERGS                                                                  
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gonçalves                         
-- Module Name: memory - Behavioral                                                
-- Project Name: jaguar40                                                     
-- Description: Computer Organization first work                                   
---------------------------------------------------------------------------------- 
-- UNIDADE DE CONTROLE:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity control_unit is
    Port (
        opcode      : in  std_logic_vector(4 downto 0); -- Opcode da instrucao (31-27)
        jmp         : out std_logic; -- Flag pro JMP
        beq         : out std_logic; -- Flah pro BEQ
        ula_op      : out std_logic_vector(3 downto 0); -- Operacao da ULA
        mem_read    : out std_logic; -- Flag de leitura da memoria
        mem_write   : out std_logic; -- Flag de escrita na memoria
        reg_write_data  : out std_logic;  -- Flag de escrita no registrador Rd feita pelo LOAD
        reg_write_ula  : out std_logic;  -- Flag de escrita no registrador Rd feita pela ULA
        pc_enable_flag  : out std_logic
    );
end control_unit;


architecture Behavioral of control_unit is

begin
    
    process(opcode)     -- Maquina de estados!
    begin
        
        pc_enable_flag <= '1';
        
        case opcode is
        
            when "00000" =>  -- JMP
                jmp         <= '1';
                beq         <= '0';
                ula_op      <= "XXXX";
                mem_read    <= '0';
                mem_write   <= '0';
                reg_write_data <= '0';
                reg_write_ula <= '0';
                pc_enable_flag <= '1';
                                
            when "00001" =>  -- BEQ
                jmp         <= '0';
                beq         <= '1';
                ula_op      <= "0000";
                mem_read    <= '0';
                mem_write   <= '0';
                reg_write_data <= '0';
                reg_write_ula <= '0';
                pc_enable_flag <= '1';
                
            when "00010" =>  -- LOAD
                jmp         <= '0';
                beq         <= '0';
                ula_op      <= "XXXX";
                mem_read    <= '1';
                mem_write   <= '0';
                reg_write_data <= '1';
                reg_write_ula <= '0';
                pc_enable_flag <= '1';
                
            when "00011" =>  -- STR
                jmp         <= '0';
                beq         <= '0';
                ula_op      <= "XXXX";
                mem_read    <= '0';
                mem_write   <= '1';
                reg_write_data <= '0';
                reg_write_ula <= '0';
                pc_enable_flag <= '1';
                
            when "00100" =>  -- AND
                jmp         <= '0';
                beq         <= '0';
                ula_op      <= "0001";
                mem_read    <= 'X';
                mem_write   <= 'X';
                reg_write_data <= '0';
                reg_write_ula <= '1';
                pc_enable_flag <= '1';
                
            when "00101" =>  -- OR
                jmp         <= '0';
                beq         <= '0';
                ula_op      <= "0010";
                mem_read    <= 'X';
                mem_write   <= 'X';
                reg_write_data <= '0';
                reg_write_ula <= '1';
                pc_enable_flag <= '1';
                
            when "00110" =>  -- ADD
                jmp         <= '0';
                beq         <= '0';
                ula_op      <= "0011";
                mem_read    <= 'X';
                mem_write   <= 'X';
                reg_write_data <= '0';
                reg_write_ula <= '1';
                pc_enable_flag <= '1';
                
            when "00111" =>  -- SUB
                jmp         <= '0';
                beq         <= '0';
                ula_op      <= "0100";
                mem_read    <= 'X';
                mem_write   <= 'X';
                reg_write_data <= '0';
                reg_write_ula <= '1';
                pc_enable_flag <= '1';
            
            when others =>  -- HLT
                jmp         <= 'X';
                beq         <= 'X';
                ula_op      <= "XXXX";
                mem_read    <= 'X';
                mem_write   <= 'X';
                reg_write_data <= 'X';
                reg_write_ula <= 'X';
                pc_enable_flag <= '0';
            
        end case;
    end process;
           
end Behavioral;