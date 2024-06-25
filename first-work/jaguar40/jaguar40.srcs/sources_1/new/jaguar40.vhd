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
    signal instr_addr   : std_logic_vector(11 downto 0) := x"000";
    signal mux_sel      : std_logic := '0';

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
    signal pc_branch_flag   : std_logic;  -- Correção do nome da flag
    
    -- Instanceamento  da unidade de controle
    signal instr_opcode     : std_logic_vector(4 downto 0);
    signal jmp_flag         : std_logic;
    signal beq_flag         : std_logic;
    signal mem_read         : std_logic;
    signal mem_write        : std_logic;

begin

    U1: entity work.Mux(Behavioral)
        port map(
            mux_in0 =>  pc_next_addr,   -- Entrada do endereco da proxima linha do PC
            mux_in1 =>  instr_addr,     -- Entrada do endereco de desvio da instrucao
            mux_sel =>  mux_sel,        -- Selecao de entrada (resultado da AND e da OR)
            mux_out =>  pc_current_addr -- Saida do Mux que vai direto pro PC
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
            clk          => clk,             -- Clock geral do processador
            reset        => reset,           -- Reset
            current_addr => pc_current_addr, -- Endereço atual do PC
            next_addr    => pc_next_addr,    -- Proximo endereco do PC (sequencia do anterior ou desvio)
            branch_flag  => pc_branch_flag   -- Flag que permite que o proximo endereco do PC seja um desvio
        );
        
    U5: entity work.control_unit(Behavioral)
        port map(
            opcode      => instr_opcode,
            jmp         => jmp_flag,
            beq         => beq_flag,
            ula_op      => ula_op,
            mem_read    => mem_read, 
            mem_write   => mem_write,
            reg_write   => reg_write
        );    

end Behavioral;
