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
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;

entity memory is
	Port(		
        clk                 : in  std_logic; -- Clock
        reset               : in  std_logic; -- Reset que zera toda a memória
        write_on            : in  std_logic; -- Flag de ativação da escrita ou leitura na memória
        mem_addr            : in  std_logic_vector(11  downto 0); -- Endereço a ser acessado (tanto pra escrita quanto pra leitura)
        mem_in              : in  std_logic_vector(31 downto 0);  -- Entrada que será escrita
        mem_out             : out std_logic_vector(31 downto 0)   -- Saída da leitura
        );
end memory;

architecture Behavioral of memory is

    constant mem_size : integer := 4096; -- Tamanho da memória (4096 linhas)
    signal init_complete : STD_LOGIC := '0'; -- Sinal que dirá se o "for" de criação das 4096 terminou
	subtype palavra is std_logic_vector(31 downto 0); -- Define que a palavra tem 32 bits
	type memory is array (0 to mem_size-1) of palavra; -- Define que a memória terá 4096 linhas com 32 bits cada (tamanho da palavra)
	signal mem : memory;

begin 

process(clk, reset, write_on, mem_addr, mem_in)	
begin
	if rising_edge(clk) then -- Só reseta, escreve ou lê em uma mudança de clock
        if(reset = '1') then
                -- Reseta a memória e o contador quando reset = '1'
                for i in 0 to mem_size-1 loop
                 mem(i) <= x"00000000"; -- o "x" na frente define que são 8 digitos hexadecimais, que correspondem aos 32 digitos em binário
                end loop;
        else
            -- Leitura da memória:
            if((write_on = '0'))then 
                    mem_out(31 downto 0) <= mem(to_integer(unsigned(mem_addr)));
            -- Escrita na memória:
            elsif ((write_on = '1')) then 		
                mem(to_integer(unsigned(mem_addr))) <= mem_in(31 downto 0);
            end if;
        end if;		
	end if;
end process;

end Behavioral;