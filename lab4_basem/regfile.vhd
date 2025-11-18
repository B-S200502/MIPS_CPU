library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;


entity register_32 is
port(     din : in std_logic_vector(31 downto 0);
    reset : in std_logic;
    clk : in std_logic;
    write : in std_logic;
    read_a : in std_logic_vector(4 downto 0);
    read_b : in std_logic_vector(4 downto 0);
    write_address : in std_logic_vector(4 downto 0);
    out_a : out std_logic_vector(31 downto 0);
    out_b : out std_logic_vector(31 downto 0));
end register_32 ;

architecture register_32 of register_32 is

    type register_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal reg : register_array;

begin
    out_a <= reg(TO_INTEGER(unsigned(read_a)));
    out_b <= reg(TO_INTEGER(unsigned(read_b)));

process(clk,reset)
begin
    if(reset = '1') then
        reg <= (others => (others => '0'));
    elsif (clk' event and clk = '1') then
        if(write = '1') then
        reg(TO_INTEGER(unsigned(write_address))) <= din;
        end if;
    end if;
end process;
end register_32;
