-- regfile.vhd
-- 32 x 32 register file
-- two asynchronous read ports, one synchronous write port (active-high enable)
-- async active-high reset clears all registers to zero

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile is
  port(
    din           : in  std_logic_vector(31 downto 0);
    reset         : in  std_logic;                      -- async, active-high
    clk           : in  std_logic;                      -- rising-edge clock
    write         : in  std_logic;                      -- write enable, active-high
    read_a        : in  std_logic_vector(4 downto 0);   -- read address A
    read_b        : in  std_logic_vector(4 downto 0);   -- read address B
    write_address : in  std_logic_vector(4 downto 0);   -- write address
    out_a         : out std_logic_vector(31 downto 0);  -- read data A
    out_b         : out std_logic_vector(31 downto 0)   -- read data B
  );
end regfile;

architecture behavior of regfile is
  type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
  signal registers : reg_array := (others => (others => '0'));
begin

  -- Asynchronous reset, synchronous write
  process(clk, reset)
  begin
    if reset = '1' then
      registers <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if write = '1' then
        registers(to_integer(unsigned(write_address))) <= din;
      end if;
    end if;
  end process;

  -- Asynchronous reads
  out_a <= registers(to_integer(unsigned(read_a)));
  out_b <= registers(to_integer(unsigned(read_b)));

end behavior;
