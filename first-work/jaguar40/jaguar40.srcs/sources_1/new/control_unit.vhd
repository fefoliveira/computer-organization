---------------------------------------------------------------------------------- 
-- Company: UERGS                                                                  
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Gon�alves                         
-- Module Name: control_unit - Behavioral                                                
-- Project Name: jaguar40                                                     
-- Description: Computer Organization first work                                   
---------------------------------------------------------------------------------- 
-- UNIDADE DE CONTROLE:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
    Port (
        clk             : in std_logic;
        reset           : in std_logic;
        opcode          : in  std_logic_vector(4 downto 0); -- Opcode da instrucao (31-27)
        jmp             : out std_logic; -- Flag pro JMP
        beq             : out std_logic; -- Flag pro BEQ
        ula_op          : out std_logic_vector(3 downto 0); -- Operacao da ULA
        mem_read        : out std_logic; -- Flag de leitura da memoria
        mem_write       : out std_logic; -- Flag de escrita na memoria
        reg_write_data  : out std_logic; -- Flag de escrita no registrador Rd feita pelo LOAD
        reg_write_ula   : out std_logic; -- Flag de escrita no registrador Rd feita pela ULA
        pc_enable_flag  : out std_logic; -- Flag que permite que o PC conte  
        intermed_reg_on : out std_logic; -- Flag que habilita a escrita no registrador intermediario do fetch
        intermed_reg_ula_on : out std_logic;   -- Flag que habilita a escrita no registrador intermediario da ULA
        ula_r1_sel      : out std_logic; -- Flag que seleciona a entrada do registrador R1
        r1_rd_changed   : out std_logic
    );
end control_unit;

architecture Behavioral of control_unit is

    type state is (IF_for_all, ID_for_all, MEMWB_LOAD, EXEC_ULA, WB_ULA, EXEC_JMP);
    signal current_state : state := IF_for_all;
    signal loop_counter : integer := 0;  -- Adicionar um sinal para contar repetições do ADDTW

begin

    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IF_for_all;
            loop_counter <= 0;  -- Resetar o contador no reset
        elsif rising_edge(clk) then 
            case current_state is
                when IF_for_all =>
                    current_state <= ID_for_all;
                          
                when ID_for_all =>
                    if opcode = "00010" or opcode = "00011" then
                        current_state <= MEMWB_LOAD;
                    elsif opcode = "00001" or opcode = "00100" or opcode = "00101" or opcode = "00110" or opcode = "00111" or opcode = "01000" or opcode = "01001" then
                        current_state <= EXEC_ULA;
                    elsif opcode = "00000" then
                        current_state <= EXEC_JMP;
                    end if;
                    
                when MEMWB_LOAD =>
                    current_state <= IF_for_all;
                    
                when EXEC_ULA =>
                    if opcode = "00100" or opcode = "00101" or opcode = "00110" or opcode = "00111" or opcode = "01000" or opcode = "01001" then 
                        current_state <= WB_ULA;
                    else 
                        current_state <= IF_for_all;
                    end if;
                
                when WB_ULA =>
                    if opcode = "01000" then
                        if loop_counter < 1 then
                            loop_counter <= loop_counter + 1;
                            current_state <= EXEC_ULA;  -- Continuar no loop
                        else
                            loop_counter <= 0;  -- Resetar o contador para futuras repetições
                            current_state <= IF_for_all;  -- Sair do loop
                        end if;
                    elsif opcode = "01001" then
                        current_state <= MEMWB_LOAD;
                    else
                        current_state <= IF_for_all;
                    end if;
                
                when EXEC_JMP =>
                    current_state <= IF_for_all;
                    
             end case;
        end if;
    end process;

    process(current_state, opcode)     -- Maquina de estados!
    begin
        
        case current_state is
        
            when IF_for_all =>
                beq             <= '0';
                ula_op          <= "0000";
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                reg_write_ula   <= '0';
                pc_enable_flag  <= '1';
                intermed_reg_on <= '1';
                intermed_reg_ula_on <= '0';
                ula_r1_sel      <= '0';
                r1_rd_changed <= '0';
                case opcode is 
                    when "00000" => 
                        jmp <= '1';
                    when others =>
                        jmp <= '0';
                end case;
                
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
                ula_r1_sel      <= '0'; 
                r1_rd_changed <= '0';
                
            when MEMWB_LOAD =>
                jmp             <= '0';
                beq             <= '0';
                ula_op          <= "0000";
                reg_write_ula   <= '0';
                pc_enable_flag  <= '0';
                intermed_reg_on <= '0';
                intermed_reg_ula_on <= '0'; 
                ula_r1_sel      <= '0';
                case opcode is
                    when "00010" =>
                        mem_read        <= '1';
                        mem_write       <= '0';
                        reg_write_data  <= '1';
                        r1_rd_changed   <= '0';
                    when "00011" => 
                        mem_read        <= '0';
                        mem_write       <= '1';
                        reg_write_data  <= '0';
                        r1_rd_changed   <= '0';
                    when "01001" =>
                        mem_read        <= '0';
                        mem_write       <= '1';
                        reg_write_data  <= '0';
                        r1_rd_changed   <= '1';
                    when others =>
                        mem_read        <= '0';
                        mem_write       <= '0';
                        reg_write_data  <= '0';    
                end case; 
                
            when EXEC_ULA =>
                jmp             <= '0';
                reg_write_ula   <= '0';
                intermed_reg_on <= '0';
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                pc_enable_flag  <= '0';
                r1_rd_changed <= '0';
                case opcode is
                    when "00001" => -- BEQ
                        ula_op  <= "0000";
                        beq     <= '1';
                        intermed_reg_ula_on <= '0';
                        pc_enable_flag  <= '1';
                    when "00100" => -- AND
                        ula_op  <= "0001";
                        beq     <= '0';
                        intermed_reg_ula_on <= '1';
                    when "00101" => -- OR
                        ula_op  <= "0010";
                        beq     <= '0';
                        intermed_reg_ula_on <= '1';
                    when "00110" => -- ADD
                        ula_op  <= "0011";
                        beq     <= '0';    
                        intermed_reg_ula_on <= '1';
                    when "00111" => -- SUB
                        ula_op  <= "0100";
                        beq     <= '0';
                        intermed_reg_ula_on <= '1';
                    when "01000" => -- ADDTW
                        ula_op  <= "0011";
                        beq     <= '0';    
                        intermed_reg_ula_on <= '1';
                    when "01001" => -- ADDS
                        ula_op  <= "0011";
                        beq     <= '0';    
                        intermed_reg_ula_on <= '1';
                    when others =>
                        ula_op  <= "0000";
                        beq     <= '0';       
                        intermed_reg_ula_on <= '1';
                        ula_r1_sel <= '0';
                end case; 
                
            when WB_ULA =>  
                jmp             <= '0';
                beq             <= '0';
                pc_enable_flag  <= '0';
                intermed_reg_on <= '0';
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                ula_op          <= "0000";
                intermed_reg_ula_on <= '0';   
                r1_rd_changed <= '0';
                if opcode = "01000" then  
                    if loop_counter < 1 then
                        reg_write_ula <= '0';
                        ula_r1_sel <= '1';
                    else
                        reg_write_ula <= '1';
                        ula_r1_sel <= '0';
                    end if;
                else
                    reg_write_ula <= '1';
                    ula_r1_sel <= '0';
                end if;                
            
            when EXEC_JMP =>
                jmp             <= '1';
                beq             <= '0';
                reg_write_ula   <= '0';
                pc_enable_flag  <= '0';
                intermed_reg_on <= '0';
                mem_read        <= '0';
                mem_write       <= '0';
                reg_write_data  <= '0';
                ula_op          <= "0000";
                intermed_reg_ula_on <= '0';      
                ula_r1_sel      <= '0'; 
                r1_rd_changed <= '0';                 
                
         end case;
    end process;
           
end Behavioral;
