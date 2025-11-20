library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity d_cache is
port(
	din : in std_logic_vector(31 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	write : in std_logic;
	address : in std_logic_vector(4 downto 0);
	d_out : out std_logic_vector(31 downto 0)
	);
end d_cache;

architecture data_cache_architecture of d_cache is
	type registers is array(31 downto 0) of std_logic_vector(31 downto 0);
	signal cache : registers := (others => (others => '0'));

begin

	-- Synchronous write, asynchronous read process
	data_cache_process : process(reset, clk)
	begin
		if reset = '1' then
			cache <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if write = '1' then
				-- Only write if address is valid
				if (address(0) /= 'U' and address(0) /= 'X' and address(0) /= 'Z') then
					cache(to_integer(unsigned(address))) <= din;
				end if;
			end if;
		end if;
	end process;

	-- Safe read with undefined handling
	read_proc: process(address, cache)
	begin
		if (address(0) = 'U' or address(0) = 'X' or address(0) = 'Z') then
			d_out <= (others => '0');
		else
			d_out <= cache(to_integer(unsigned(address)));
		end if;
	end process;

end data_cache_architecture;