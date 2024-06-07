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
    signal pc_next   : std_logic_vector(11 downto 0) := x"0000";
    signal address   : std_logic_vector(11 downto 0) := x"0000";
    signal mux_out   : std_logic_vector(11 downto 0) := x"0000";
    signal mux_sel   : std_logic := '0';

    -- Instanceamento da ULA
    signal R1_read   : std_logic_vector(31 downto 0) := x"00000000";
    signal R2_read   : std_logic_vector(31 downto 0) := x"00000000";
    signal ula_op    : std_logic_vector(3 downto 0)  := "0000";
    signal Rd_write  : std_logic_vector(31 downto 0) := x"00000000";
    signal beq_out   : std_logic := '0';

    -- Instanceamento do Banco de Registradores
    signal Rd_addr   : std_logic_vector(3 downto 0)  := x"00000000";
    signal R1_addr   : std_logic_vector(3 downto 0)  := x"00000000";
    signal R2_addr   : std_logic_vector(3 downto 0)  := x"00000000";
    signal reg_write : std_logic := '0';

begin

    U1: entity work.Mux(Behavioral)
        port map(
            mux_in0 =>  pc_next,    -- Entrada do endereço da próxima linha do PC
            mux_in1 =>  address,    -- Entrada do endereço de desvio da instrução
            mux_sel =>  mux_sel,    -- Selecao de entrada (resultado da AND e da OR)
            mux_out =>  mux_out     -- Saida do Mux que vai direto pro PC
        );
        
    U2: entity work.ULA(Behavioral)
        port map(
            ula_in0 =>  R1_read,    -- Leitura do registrador 1
            ula_in1 =>  R2_read,    -- Leitura do registrador 2
            ula_op  =>  ula_op,     -- Seletor de operacao da ULA
            ula_out =>  Rd_write,   -- Saida da operação da ULA
            beq_out =>  beq_out  -- Saída do comparador de igualdade (vai ir direto pra AND com o BEQ da Unidade de controle)
        );

    U3: entity work.register_bank(Behavioral)
        port map(
            Rd_addr   => Rd_addr,   -- Endereco do registrador de destino
            R1_addr   => R1_addr,   -- Endereco do registrador 1
            R2_addr   => R2_addr,   -- Endereco do registrador 2
            reg_write => reg_write,  -- Sinal de escrita no banco de registradores que vem da unidade de controle
            R1_read   => R1_read,   -- Leitura do registrador 1
            R2_read   => R2_read,    -- Leitura do registrador 2
            Rd_write  => Rd_write   -- Escrita no registrador de destino
        );
          

end Behavioral;
