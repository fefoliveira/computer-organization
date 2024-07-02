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
        instr_mem_out_opcode: out std_logic_vector(4 downto 0);     -- Parcela da palavra que representa a saida do opcode
        instr_mem_out_Rd    : out std_logic_vector(3 downto 0);     -- Parcela da palavra que representa a saida pro Rd no banco de registradores
        instr_mem_out_R1    : out std_logic_vector(3 downto 0);     -- Parcela da palavra que representa a saida pro R1 no banco de registradores
        instr_mem_out_R2    : out std_logic_vector(3 downto 0);     -- Parcela da palavra que representa a saida pro R2 no banco de registradores
        instr_mem_out_addr  : out std_logic_vector(11 downto 0);    -- Saida da parcela da palavra que representa o endereco de desvio na instr_mem ou de destino na data_mem
        
        -- Memoria de dados:
        data_write_on       : in  std_logic;    -- Sinal para escrita na memoria de dados
        data_read_on        : in  std_logic;    -- Sinal para leitura da memoria de dados
        data_mem_addr       : in  std_logic_vector(11 downto 0);    -- Endereço a ser acessado (tanto pra escrita do STR quanto pra leitura do LOAD)
        data_mem_in         : in  std_logic_vector(31 downto 0);    -- Entrada que sera escrita quando for um STR (valor do R1)
        data_mem_out        : out std_logic_vector(31 downto 0)     -- Saida da data_mem que sera escrita no Rd quando for um LOAD (valor que vai pro Rd)
    );
end memory;

architecture Behavioral of memory is

    constant mem_size : integer := 4096; -- Tamanho da memória (4096 linhas)
    subtype palavra is std_logic_vector(31 downto 0); -- Define que a palavra tem 32 bits
    type memory is array (0 to mem_size-1) of palavra; -- Define que a memória terá 4096 linhas com 32 bits cada (tamanho da palavra)
    
    -- Definicao das intrucoes:
    signal instr_mem : memory := (
        "000100000XXXXXXXXXXX000000000000", 
        "000100001XXXXXXXXXXX000000000001", 
        "00110001000010000XXXXXXXXXXXXXXX", 
        "00111001100100001XXXXXXXXXXXXXXX", 
        "00100010000100001XXXXXXXXXXXXXXX", 
        "00101010100100001XXXXXXXXXXXXXXX", 
        "00101010100100001XXXXXXXXXXXXXXX", 
        "00001XXXX00100001XXX000000010100", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00001XXXX00000011XXX000000010100", 
        "00110011001010010XXXXXXXXXXXXXXX", 
        "00011XXXX0110XXXXXXX000000000100", 
        "00000XXXXXXXXXXXXXXX000000011110", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        others => "00000000000000000000000000000000"
    );
    
    -- Definicao da memoria de instrucoes:
    signal data_mem  : memory := (
        x"00000001",
        x"00000002",
        x"00000003",
        x"00000001",
        others => x"00000000"
    );
    
    signal data_mem_out_aux : std_logic_vector(31 downto 0);

begin 
    process(clk, reset, data_mem_addr, data_read_on, data_write_on)    
    begin
        if rising_edge(clk) then -- So reseta, escreve ou lê em uma mudança de clock
        
                -- Escrita na memoria de dados (STR):
                if data_write_on = '1' then
                    data_mem(to_integer(unsigned(data_mem_addr))) <= data_mem_in;
                end if;
    
        end if;
        
        -- Leitura da memoria de dados (LOAD):
        if data_read_on = '1' then
            data_mem_out_aux <= data_mem(to_integer(unsigned(data_mem_addr)));
        end if;
        
        -- Leitura da memoria de instrucoes:
        instr_mem_out_opcode <= instr_mem(to_integer(unsigned(instr_mem_in)))(31 downto 27);
        instr_mem_out_Rd <= instr_mem(to_integer(unsigned(instr_mem_in)))(26 downto 23);
        instr_mem_out_R1 <= instr_mem(to_integer(unsigned(instr_mem_in)))(22 downto 19);
        instr_mem_out_R2 <= instr_mem(to_integer(unsigned(instr_mem_in)))(18 downto 15);
        instr_mem_out_addr <= instr_mem(to_integer(unsigned(instr_mem_in)))(11 downto 0);
        
    end process;
    
    data_mem_out <= data_mem_out_aux;

end Behavioral;
