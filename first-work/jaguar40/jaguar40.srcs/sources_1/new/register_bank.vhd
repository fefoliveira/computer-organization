----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Fernando de Souza Oliveira e Marcos Emerim Goncalves
-- Module Name: register_bank - Behavioral
-- Project Name: jaguar40
-- Description: Computer Organization first work
----------------------------------------------------------------------------------
--  CRIACAO DO BANCO DE REGISTRADORES:


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_bank is
    port(
        Rd_addr   : in  std_logic_vector(3 downto 0);  -- Endereco de 4 bits do registrador escolhido para ser o Rd
        R1_addr   : in  std_logic_vector(3 downto 0);  -- Endereco de 4 bits do registrador escolhido para ser o R1
        R2_addr   : in  std_logic_vector(3 downto 0);  -- Endereco de 4 bits do registrador escolhido para ser o R2
        R1_read   : out std_logic_vector(31 downto 0); -- Leitura do valor de R1 que vai direto pra ULA ou pra memória (caso seja um LOAD)
        R2_read   : out std_logic_vector(31 downto 0); -- Leitura do valor de R2 que vai direto apenas pra ULA
        Rd_write  : in  std_logic_vector(31 downto 0); -- Valor a ser escrito no registrador Rd
        reg_write : in  std_logic
    );
end register_bank;

architecture Behavioral of register_bank is

    -- Criacao dos 16 registradores de 32 bits
    type reg_bank_type is array(0 to 15) of 
        std_logic_vector(31 downto 0);
    
        -- Valor inicial de todos os registradores
        signal reg_bank : reg_bank_type := (x"00000000", -- r0
                                            x"11111111", -- r1
                                            x"22222222", -- r2
                                            x"33333333", -- r3
                                            x"44444444", -- r4
                                            x"55555555", -- r5
                                            x"66666666", -- r6
                                            x"77777777", -- r7
                                            x"88888888", -- r8
                                            x"99999999", -- r9
                                            x"AAAAAAAA", -- r10
                                            x"BBBBBBBB", -- r11
                                            x"CCCCCCCC", -- r12
                                            x"DDDDDDDD", -- r13
                                            x"EEEEEEEE", -- r14
                                            x"FFFFFFFF"  -- r15
                                            );
begin

    process(reg_write)  -- Pulsa apenas quando o reg_write muda (sinal que vem da Unidade de Controle)
    begin
        if reg_write = '1' then
            reg_bank(to_integer(unsigned(Rd_addr))) <= Rd_write;
        end if;
    end process;

    -- Define qual serao os R1 e R2 que serao lidos pelas entradas da ULA
    R1_read <= reg_bank(to_integer(unsigned(R1_addr)));
    R2_read <= reg_bank(to_integer(unsigned(R2_addr)));

end Behavioral;
