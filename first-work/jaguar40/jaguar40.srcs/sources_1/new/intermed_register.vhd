----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: intermed_register - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- REGISTRADOR INTERMEDIARIO:


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;

entity intermed_register is
    Port(
        clk                   : std_logic;
        write_on              : in std_logic;
        
        -- Entradas:
        instr_mem_in_opcode   : in std_logic_vector(4 downto 0);     
        instr_mem_in_Rd       : in std_logic_vector(3 downto 0);     
        instr_mem_in_R1       : in std_logic_vector(3 downto 0);     
        instr_mem_in_R2       : in std_logic_vector(3 downto 0);     
        instr_mem_in_addr     : in std_logic_vector(11 downto 0);
        
        -- Saidas:
        instr_mem_out_opcode  : out std_logic_vector(4 downto 0);     
        instr_mem_out_Rd      : out std_logic_vector(3 downto 0);     
        instr_mem_out_R1      : out std_logic_vector(3 downto 0);     
        instr_mem_out_R2      : out std_logic_vector(3 downto 0);     
        instr_mem_out_addr    : out std_logic_vector(11 downto 0)
    );
end intermed_register;

architecture Behavioral of intermed_register is
    signal opcode_in_aux    : std_logic_vector(4 downto 0);
    signal Rd_in_aux        : std_logic_vector(3 downto 0);
    signal R1_in_aux        : std_logic_vector(3 downto 0);
    signal R2_in_aux        : std_logic_vector(3 downto 0);
    signal addr_in_aux      : std_logic_vector(11 downto 0);

    begin
    process(clk, write_on, instr_mem_in_opcode, instr_mem_in_Rd, instr_mem_in_R1, instr_mem_in_R2, instr_mem_in_addr)
    begin
        if rising_edge(clk) then
            if write_on = '1' then
                 opcode_in_aux   <= instr_mem_in_opcode;
                 Rd_in_aux       <= instr_mem_in_Rd;
                 R1_in_aux       <= instr_mem_in_R1;
                 R2_in_aux       <= instr_mem_in_R2;
                 addr_in_aux     <= instr_mem_in_addr;
            end if;
        end if; 
    end process;
    
    instr_mem_out_opcode   <= opcode_in_aux;
    instr_mem_out_Rd       <= Rd_in_aux;
    instr_mem_out_R1       <= R1_in_aux;
    instr_mem_out_R2       <= R2_in_aux;
    instr_mem_out_addr     <= addr_in_aux;
    
end Behavioral;