-- regfile.vhd
-- 32 x 32 register file: two asynchronous read ports, one synchronous write port
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile is
  port(
    din           : in  std_logic_vector(31 downto 0);
    reset         : in  std_logic;                      -- async, active-high
    clk           : in  std_logic;                      -- rising-edge clock
    write         : in  std_logic;                      -- write enable
    read_a        : in  std_logic_vector(4 downto 0);
    read_b        : in  std_logic_vector(4 downto 0);
    write_address : in  std_logic_vector(4 downto 0);
    out_a         : out std_logic_vector(31 downto 0);
    out_b         : out std_logic_vector(31 downto 0)
  );
end regfile;

architecture arch of regfile is
  type t_register_array is array (0 to 31) of std_logic_vector(31 downto 0);
  signal register_array : t_register_array := (others => (others => '0'));
begin
  -- asynchronous reset, synchronous write
  write_process : process(clk, reset)
  begin
    if reset = '1' then
      register_array <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if write = '1' then
        register_array(to_integer(unsigned(write_address))) <= din;
      end if;
    end if;
  end process;

  -- asynchronous reads (combinational)
  out_a <= register_array(to_integer(unsigned(read_a)));
  out_b <= register_array(to_integer(unsigned(read_b)));
end arch;
