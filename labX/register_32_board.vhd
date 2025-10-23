library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity regfile is
port( 	din_in : in std_logic_vector(3 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	write : in std_logic;
	read_a_in : in std_logic_vector(1 downto 0);
	read_b_in : in std_logic_vector(1 downto 0);
	write_address_in : in std_logic_vector(1 downto 0);
	out_a_out : out std_logic_vector(3 downto 0);
	out_b_out : out std_logic_vector(3 downto 0));
end regfile ;

architecture register_32 of regfile is

	type register_array is array(0 to 3) of std_logic_vector(3 downto 0);
	signal reg : register_array; 
	


begin
	out_a_out <= reg(TO_INTEGER(unsigned(read_a_in)));
	out_b_out <= reg(TO_INTEGER(unsigned(read_b_in)));

process(clk,reset)
begin
	if(reset = '1') then
		reg <= (others => (others => '0'));
	elsif (clk' event and clk = '1') then
		if(write = '1') then
		reg(TO_INTEGER(unsigned(write_address_in))) <= din_in;
		end if;
	end if;
end process;
end register_32;
