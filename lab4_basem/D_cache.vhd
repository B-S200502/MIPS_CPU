library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity d_cache is
	port(	d_in      : in std_logic_vector(31 downto 0);
		data_write: in std_logic;
		clk       : in std_logic;
		reset     : in std_logic;
		destination_reg  : in std_logic_vector(4 downto 0);
		d_out     : out std_logic_vector(31 downto 0));
end d_cache;

architecture d_cache of d_cache is

type memory_location is array(0 to 31) of std_logic_vector(31 downto 0);
signal cache_memory : memory_location;

begin
	d_out <= cache_memory (TO_INTEGER(unsigned(destination_reg)));

process(d_in, reset, clk, data_write, destination_reg)
begin
	if(reset ='1') then
		for i in cache_memory'range loop
			cache_memory(i) <= (others => '0');
		end loop;
	elsif (rising_edge(clk)) then
		if(data_write = '1') then
			cache_memory(TO_INTEGER(unsigned(destination_reg))) <= d_in;
		end if;
	end if;
end process;
end d_cache;
