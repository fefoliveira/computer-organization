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
        clk             : in std_logic;
        reset           : in std_logic;
        opcode          : in  std_logic_vector(4 downto 0); -- Opcode da instrucao (31-27)
        jmp             : out std_logic; -- Flag pro JMP
        beq             : out std_logic; -- Flah pro BEQ
        ula_op          : out std_logic_vector(3 downto 0); -- Operacao da ULA
        mem_read        : out std_logic; -- Flag de leitura da memoria
        mem_write       : out std_logic; -- Flag de escrita na memoria
        reg_write_data  : out std_logic; -- Flag de escrita no registrador Rd feita pelo LOAD
        reg_write_ula   : out std_logic; -- Flag de escrita no registrador Rd feita pela ULA
        pc_enable_flag  : out std_logic; -- Flag que permite que o PC conte  
        intermed_reg_on : out std_logic; -- Flag que habilita a escrita no registrador intermediario do fetch
        intermed_reg_ula_on : out std_logic   -- Flag que habilita a escrita no registrador intermediario da ULA
    );
end control_unit;


architecture Behavioral of control_unit is

    type state is (IF_for_all, ID_for_all, MEMWB_LOAD, EXEC_ULA, WB_ULA);
    signal current_state : state := IF_for_all;

begin
    
    process(clk, opcode)
    begin
        
        if rising_edge(clk) then 
            case current_state is
            
                when IF_for_all =>
                    case opcode is
                        when "00010" =>
                            current_state <= ID_for_all;
                        when "00011" =>
                            current_state <= ID_for_all;
                        when "00110" =>
                            current_state <= ID_for_all;
                        when others => 
                            current_state <= ID_for_all;
                    end case;  
                          
                when ID_for_all =>
                    if opcode = "00010" or opcode = "00011" then
                        current_state <= MEMWB_LOAD;
                    elsif opcode = "00100" or opcode = "00101" or opcode = "00110" or opcode = "00111" then
                        current_state <= EXEC_ULA;  
                    else
                        current_state <= IF_for_all;
                    end if;
                    
                when MEMWB_LOAD =>
                    current_state <= IF_for_all;
                    
                when EXEC_ULA =>
                    if opcode = "00100" or opcode = "00101" or opcode = "00110" or opcode = "00111" then 
                        current_state <= WB_ULA;
                    else 
                        current_state <= IF_for_all;
                    end if;
                when WB_ULA =>  
                    current_state <= IF_for_all;
             end case;
        end if;
    end process;
    
    process(current_state, opcode)     -- Maquina de estados!
    begin
        
        case current_state is
        
            when IF_for_all =>
                jmp             <= '0';
                beq             <= '0';
                ula_op          <= "0000";
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                reg_write_ula   <= '0';
                pc_enable_flag  <= '1';
                intermed_reg_on <= '1';
                intermed_reg_ula_on <= '0'; 
                
            when ID_for_all =>
                jmp             <= '0';
                beq             <= '0';
                ula_op          <= "0000";
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                reg_write_ula   <= '0';
                pc_enable_flag  <= '0';
                intermed_reg_on <= '0';
                intermed_reg_ula_on <= '0'; 
                
            when MEMWB_LOAD =>
                jmp             <= '0';
                beq             <= '0';
                ula_op          <= "0000";
                reg_write_ula   <= '0';
                pc_enable_flag  <= '0';
                intermed_reg_on <= '0';
                intermed_reg_ula_on <= '0'; 
                case opcode is
                    when "00010" =>
                        mem_read        <= '1';
                        mem_write       <= '0';
                        reg_write_data  <= '1';
                    when "00011" => 
                        mem_read        <= '0';
                        mem_write       <= '1';
                        reg_write_data  <= '0';
                    when others =>
                        mem_read        <= '0';
                        mem_write       <= '0';
                        reg_write_data  <= '0';    
                end case; 
                
            when EXEC_ULA =>
                jmp             <= '0';
                beq             <= '0';
                reg_write_ula   <= '0';
                pc_enable_flag  <= '0';
                intermed_reg_on <= '0';
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                case opcode is
                    when "00001" => -- BEQ
                        ula_op  <= "0000";
                        intermed_reg_ula_on <= '0';
                    when "00100" => -- AND
                        ula_op  <= "0001";
                        intermed_reg_ula_on <= '1';        
                    when "00101" => -- OR
                        ula_op  <= "0010";
                        intermed_reg_ula_on <= '1';
                    when "00110" => -- ADD
                        ula_op  <= "0011";
                        intermed_reg_ula_on <= '1';      
                    when "00111" => -- SUB
                        ula_op  <= "0100";
                        intermed_reg_ula_on <= '1';  
                    when others =>
                        ula_op  <= "0000";
                        intermed_reg_ula_on <= '1';         
                end case; 
                
            when WB_ULA =>  
                jmp             <= '0';
                beq             <= '0';
                reg_write_ula   <= '1';
                pc_enable_flag  <= '0';
                intermed_reg_on <= '0';
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                ula_op          <= "0000";
                intermed_reg_ula_on <= '0';     
                
                        
         end case;
        
--        pc_enable_flag <= '1';
        
--        case opcode is
        
--            when "00000" =>  -- JMP
--                jmp         <= '1';
--                beq         <= '0';
--                ula_op      <= "XXXX";
--                mem_read    <= '0';
--                mem_write   <= '0';
--                reg_write_data <= '0';
--                reg_write_ula <= '0';
--                pc_enable_flag <= '1';
                                
--            when "00001" =>  -- BEQ
--                jmp         <= '0';
--                beq         <= '1';
--                ula_op      <= "0000";
--                mem_read    <= '0';
--                mem_write   <= '0';
--                reg_write_data <= '0';
--                reg_write_ula <= '0';
--                pc_enable_flag <= '1';
                
--            when "00010" =>  -- LOAD
--                jmp         <= '0';
--                beq         <= '0';
--                ula_op      <= "XXXX";
--                mem_read    <= '1';
--                mem_write   <= '0';
--                reg_write_data <= '1';
--                reg_write_ula <= '0';
--                pc_enable_flag <= '1';
                
--            when "00011" =>  -- STR
--                jmp         <= '0';
--                beq         <= '0';
--                ula_op      <= "XXXX";
--                mem_read    <= '0';
--                mem_write   <= '1';
--                reg_write_data <= '0';
--                reg_write_ula <= '0';
--                pc_enable_flag <= '1';
                
--            when "00100" =>  -- AND
--                jmp         <= '0';
--                beq         <= '0';
--                ula_op      <= "0001";
--                mem_read    <= 'X';
--                mem_write   <= 'X';
--                reg_write_data <= '0';
--                reg_write_ula <= '1';
--                pc_enable_flag <= '1';
                
--            when "00101" =>  -- OR
--                jmp         <= '0';
--                beq         <= '0';
--                ula_op      <= "0010";
--                mem_read    <= 'X';
--                mem_write   <= 'X';
--                reg_write_data <= '0';
--                reg_write_ula <= '1';
--                pc_enable_flag <= '1';
                
--            when "00110" =>  -- ADD
--                jmp         <= '0';
--                beq         <= '0';
--                ula_op      <= "0011";
--                mem_read    <= 'X';
--                mem_write   <= 'X';
--                reg_write_data <= '0';
--                reg_write_ula <= '1';
--                pc_enable_flag <= '1';
                
--            when "00111" =>  -- SUB
--                jmp         <= '0';
--                beq         <= '0';
--                ula_op      <= "0100";
--                mem_read    <= 'X';
--                mem_write   <= 'X';
--                reg_write_data <= '0';
--                reg_write_ula <= '1';
--                pc_enable_flag <= '1';
            
--            when others =>  -- HLT
--                jmp         <= 'X';
--                beq         <= 'X';
--                ula_op      <= "XXXX";
--                mem_read    <= 'X';
--                mem_write   <= 'X';
--                reg_write_data <= 'X';
--                reg_write_ula <= 'X';
--                pc_enable_flag <= '0';
            
--        end case;
    end process;
           
end Behavioral;