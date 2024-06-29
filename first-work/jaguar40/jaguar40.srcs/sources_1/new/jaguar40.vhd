----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: jaguar40 - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
-- ARQUIVO DE TOPO:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jaguar40 is
    Port ( 
            clk     : in std_logic;
            reset   : in std_logic
    );
end jaguar40;

architecture Behavioral of jaguar40 is

    -- Instanceamento do MUX
    signal addr_from_instr  : std_logic_vector(11 downto 0) := x"000";
    signal mux_sel          : std_logic := '0';
    signal jmp_flag         : std_logic;
    signal beq_flag         : std_logic;

    -- Instanceamento da ULA
    signal R1_read   : std_logic_vector(31 downto 0) := x"00000000";
    signal R2_read   : std_logic_vector(31 downto 0) := x"00000000";
    signal ula_op    : std_logic_vector(3 downto 0)  := "0000";
    signal Rd_write  : std_logic_vector(31 downto 0) := x"00000000";
    signal beq_out   : std_logic := '0';

    -- Instanceamento do Banco de Registradores
    signal Rd_addr   : std_logic_vector(3 downto 0)  := "0000";
    signal R1_addr   : std_logic_vector(3 downto 0)  := "0000";
    signal R2_addr   : std_logic_vector(3 downto 0)  := "0000";
    signal reg_write : std_logic := '0';
    
    -- Instanceamento do PC
    signal pc_next_addr     : std_logic_vector(11 downto 0) := x"000"; 
    signal pc_current_addr  : std_logic_vector(11 downto 0) := x"000";
    --signal pc_branch_flag   : std_logic;  -- Correção do nome da flag
    
    -- Instanceamento  da unidade de controle
    signal instr_opcode     : std_logic_vector(4 downto 0);
    signal mem_read         : std_logic;
    signal mem_write        : std_logic;
    

begin

    U1: entity work.Mux(Behavioral)
        port map(
            mux_in0         => pc_next_addr,    -- Entrada do endereco da proxima linha do PC
            mux_in1         => addr_from_instr, -- Entrada do endereco de desvio da instrucao
            mux_out         => pc_current_addr, -- Saida do Mux que vai direto pro PC
            jmp_cu_flag     => jmp_flag,        -- Flag de JMP que vem da unidade de controle
            beq_cu_flag     => beq_flag,        -- Flag de BEQ que vem da unidade de controle
            beq_ula_flag    => beq_out          -- Flag de BEQ que vem da ULA
        );
        
    U2: entity work.ULA(Behavioral)
        port map(
            ula_in0 =>  R1_read,    -- Leitura do registrador 1
            ula_in1 =>  R2_read,    -- Leitura do registrador 2
            ula_op  =>  ula_op,     -- Seletor de operacao da ULA
            ula_out =>  Rd_write,   -- Saida da operacao da ULA
            beq_out =>  beq_out     -- Saida do comparador de igualdade (vai ir direto pra AND com o BEQ da Unidade de controle)
        );

    U3: entity work.register_bank(Behavioral)
        port map(
            Rd_addr   => Rd_addr,   -- Endereco do registrador de destino
            R1_addr   => R1_addr,   -- Endereco do registrador 1
            R2_addr   => R2_addr,   -- Endereco do registrador 2
            reg_write => reg_write, -- Sinal de escrita no banco de registradores que vem da unidade de controle
            R1_read   => R1_read,   -- Leitura do registrador 1
            R2_read   => R2_read,   -- Leitura do registrador 2
            Rd_write  => Rd_write   -- Escrita no registrador de destino
        );
          
    U4: entity work.pc(Behavioral)
        port map(
            clk          => clk,                -- Clock geral do processador
            reset        => reset,              -- Reset
            current_addr => pc_current_addr,    -- Endereço atual do PC
            next_addr    => pc_next_addr        -- Proximo endereco do PC (sequencia do anterior ou desvio)
        );
        
    U5: entity work.control_unit(Behavioral)
        port map(
            opcode      => instr_opcode,    -- Opcode da instrucao que e lida da memoria   
            jmp         => jmp_flag,        -- Flag caso a instrucao seja JMP        
            beq         => beq_flag,        -- Flag caso a instrucao seja BEQ
            ula_op      => ula_op,          -- Codigo da operacao da ula
            mem_read    => mem_read,        -- Flag de leitura da memoria
            mem_write   => mem_write,       -- Flag de escrita na memoria
            reg_write   => reg_write,       -- Flag  de escrita no registrador Rd
            cu_reset    => reset            -- Flag do HLT que dara um reset na memoria
        );    
    
    U6: entity work.memory(Behavioral)
        port map(
            clk                     => clk,                 -- Clock geral do processador
            reset                   => reset,               -- Reset
            instr_mem_in            => pc_next_addr,        -- Endereco da memoria de instrucoes o qual tem a instrucao que sera executada no momento 
            instr_mem_out_opcode    => instr_opcode,        -- Parcela da palavra da instrucao na memoria que e o opcode que vai pra unidade de controle       
            instr_mem_out_Rd        => Rd_addr,             -- Parcela da palavra que representa a saida pro Rd no banco de registradores
            instr_mem_out_R1        => R1_addr,             -- Parcela da palavra que representa a saida pro R1 no banco de registradores       
            instr_mem_out_R2        => R2_addr,             -- Parcela da palavra que representa a saida pro R2 no banco de registradores       
            instr_mem_out_addr      => addr_from_instr,     -- Endereço de 12 bits da palavra da instrucao que vai tanto pro mux (para o desvio) quanto para a memoria de dados (para o endereco de escrita ou leitura do LOAD e STR)
            data_write_on           => mem_write,           -- Flag de escrita na memoria de dados (vem da unidade de controle)                                  
            data_read_on            => mem_read,            -- Flag de leitura da memoria de dados (vem da unidade de controle)                               
            data_mem_addr           => addr_from_instr,     -- Endereço de 12 bits da palavra da instrucao que vai tanto pro mux (para o desvio) quanto para a memoria de dados (para o endereco de escrita ou leitura do LOAD e STR) 
            data_mem_in             => R1_read,             -- Leitura do valor de R1 que vai pra memoria de dados quando for STR             
            data_mem_out            => Rd_write             -- Escrita do que vai pro Rd quando for LOAD
        );        

end Behavioral;
