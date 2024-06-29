----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: memory - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
--  CRIACAO DA MEMÓRIA:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    Port(
        clk                 : in  std_logic;    -- Clock
        reset               : in  std_logic;    -- Reset que zera toda a memoria
        
        -- Memoria de instrucoes:
        instr_mem_in        : in  std_logic_vector(11 downto 0);    -- Entrada do endereco que estara a instrucao da vez
        instr_mem_out_opcode: out std_logic_vector(4 downto 0);     -- Saida da parcela da palavra que representa o opcode
        instr_mem_out_Rd    : out std_logic_vector(3 downto 0);     -- Saida da parcela da palavra que representa o Rd
        instr_mem_out_R1    : out std_logic_vector(3 downto 0);     -- Saida da parcela da palavra que representa o R1
        instr_mem_out_R2    : out std_logic_vector(3 downto 0);     -- Saida da parcela da palavra que representa o R2
        instr_mem_out_addr  : out std_logic_vector(11 downto 0);    -- Saida da parcela da palavra que representa o endereco de desvio na instr_mem ou de destino na data_mem
        
        -- Memoria de dados:
        data_write_on            : in  std_logic;    -- Sinal para escrita na memoria de dados
        data_read_on             : in  std_logic;    -- Sinal para leitura da memoria de dados
        data_mem_addr       : in  std_logic_vector(11 downto 0);    -- Endereço a ser acessado (tanto pra escrita do STR quanto pra leitura do LOAD)
        data_mem_in         : in  std_logic_vector(31 downto 0);    -- Entrada que sera escrita quando for um STR
        data_mem_out        : out std_logic_vector(31 downto 0)     -- Saida da data_mem que sera escrita no Rd quando for um LOAD
    );
end memory;

architecture Behavioral of memory is

    constant mem_size : integer := 4096; -- Tamanho da memória (4096 linhas)
    subtype palavra is std_logic_vector(31 downto 0); -- Define que a palavra tem 32 bits
    type memory is array (0 to mem_size-1) of palavra; -- Define que a memória terá 4096 linhas com 32 bits cada (tamanho da palavra)
    signal instr_mem : memory;
    signal data_mem        : memory;

begin 

process(clk, reset)    
begin
    if rising_edge(clk) then -- So reseta, escreve ou lê em uma mudança de clock
        if(reset = '1') then -- Reseta a memória quando reset = '1'
            -- Criacao da memoria de instrucoes:
            for i in 0 to mem_size-1 loop
                instr_mem(i) <= x"00000000"; -- o "x" na frente define que são 8 digitos hexadecimais, que correspondem aos 32 digitos em binário
            end loop;
            
            -- Para o testbench:
            instr_mem(0)    <= "000100000XXXXXXXXXXX000000000000";            -- Descricao da instrucao:  00010                 -> opcode do LOAD
                                                                            --                          0000                    -> endereco do Rd
                                                                            --                          XXXXXXXXXXX             -> don't care de 19 bits
                                                                            --                          000000000000            -> endereco a ser carregado da memoria de dados
                                                                            
            instr_mem(15)   <= "000110001XXXXXXXXXXX000000000001";            -- Descricao da instrucao:  00011                 -> opcode do STR
                                                                            --                          0000                    -> endereco do Rd
                                                                            --                          XXXXXXXXXXX             -> don't care de 19 bits
                                                                            --                          000000000001            -> endereco a ser carregado na memoria de dados
            
            -- Criacao da memoria de dados:
            for i in 0 to mem_size-1 loop
                data_mem(i) <= x"00000000";
            end loop;
        else
            -- Leitura da memoria de instrucoes:
            instr_mem_out_opcode <= instr_mem(to_integer(unsigned(instr_mem_in)))(31 downto 27);
            instr_mem_out_Rd <= instr_mem(to_integer(unsigned(instr_mem_in)))(26 downto 23);
            instr_mem_out_R1 <= instr_mem(to_integer(unsigned(instr_mem_in)))(22 downto 19);
            instr_mem_out_R2 <= instr_mem(to_integer(unsigned(instr_mem_in)))(18 downto 15);
            instr_mem_out_addr <= instr_mem(to_integer(unsigned(instr_mem_in)))(11 downto 0);

            -- Escrita na memoria de dados (STR):
            if data_write_on = '1' then
                data_mem(to_integer(unsigned(data_mem_addr))) <= data_mem_in;
            end if;

            -- Leitura da memoria de dados (LOAD):
            if data_read_on = '1' then
                data_mem_out <= data_mem(to_integer(unsigned(data_mem_addr)));
            end if;
        end if;        
    end if;
end process;

end Behavioral;
