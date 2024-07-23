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
        clk       : in std_logic;
        reset     : in std_logic;
        Rd_addr   : in  std_logic_vector(3 downto 0);  -- Endereco de 4 bits do registrador escolhido para ser o Rd
        R1_addr   : in  std_logic_vector(3 downto 0);  -- Endereco de 4 bits do registrador escolhido para ser o R1
        R2_addr   : in  std_logic_vector(3 downto 0);  -- Endereco de 4 bits do registrador escolhido para ser o R2
        R1_read   : out std_logic_vector(31 downto 0); -- Leitura do valor de R1 que vai direto pra ULA ou pra mem�ria (caso seja um LOAD)
        R2_read   : out std_logic_vector(31 downto 0); -- Leitura do valor de R2 que vai direto apenas pra ULA
        Rd_write_data   : in  std_logic_vector(31 downto 0); -- Valor a ser escrito no registrador Rd pelo LOAD
        Rd_write_ula    : in  std_logic_vector(31 downto 0); -- Valor a ser escrito no registrador Rd pela ULA
        reg_write_data  : in  std_logic; -- Flag pra escrita do LOAD no Rd
        reg_write_ula   : in  std_logic;  -- Flag pra escrita do ULA no Rd
        r1_rd_changed   : in std_logic
    );
end register_bank;

architecture Behavioral of register_bank is
                     
    type reg_bank_type is array(0 to 15) of 
        std_logic_vector(31 downto 0);
    signal reg_bank  : reg_bank_type;
    constant reg_qtd : integer := 16;
    signal R1_addr_aux : std_logic_vector(3 downto 0);
                     
begin
    process(clk, r1_rd_changed)
    begin
        if rising_edge(clk) then
            if(reset = '1') then
                -- Criacao dos 16 registradores de 32 bits, todos com valor inicial zerado
                for i in 0 to reg_qtd-1 loop
                    reg_bank(i) <= x"00000000";
                end loop;
            else
        	if reg_write_data = '1' then
            		reg_bank(to_integer(unsigned(Rd_addr))) <= Rd_write_data;
        	elsif reg_write_ula = '1' then
            		reg_bank(to_integer(unsigned(Rd_addr))) <= Rd_write_ula;
        	end if;
            end if;
        end if;
        
        if r1_rd_changed = '1' then
            R1_addr_aux <= Rd_addr;
        else
            R1_addr_aux <= R1_addr;
        end if;
    
        end process;

    -- Define qual serao os R1 e R2 que serao lidos pelas entradas da ULA
    R1_read <= reg_bank(to_integer(unsigned(R1_addr_aux)));
    R2_read <= reg_bank(to_integer(unsigned(R2_addr)));
    
end Behavioral;