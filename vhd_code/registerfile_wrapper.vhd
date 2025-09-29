-- regfile_wrapper.vhd
-- Board wrapper for 32x32 regfile: exposes 4 data bits and 2-bit addresses (R0..R3)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile_wrapper is
  port(
    din_in            : in  std_logic_vector(3 downto 0);  -- 4-bit data in
    reset             : in  std_logic;                     -- async, active-high
    clk               : in  std_logic;                     -- rising-edge clock
    write             : in  std_logic;                     -- write enable
    read_a_in         : in  std_logic_vector(1 downto 0);  -- read addr A (R0..R3)
    read_b_in         : in  std_logic_vector(1 downto 0);  -- read addr B (R0..R3)
    write_address_in  : in  std_logic_vector(1 downto 0);  -- write addr  (R0..R3)
    out_a_out         : out std_logic_vector(3 downto 0);  -- low nibble of read A
    out_b_out         : out std_logic_vector(3 downto 0)   -- low nibble of read B
  );
end regfile_wrapper;

architecture behavior of regfile_wrapper is
  -- Internal 32-bit buses
  signal din_32        : std_logic_vector(31 downto 0);
  signal out_a_32      : std_logic_vector(31 downto 0);
  signal out_b_32      : std_logic_vector(31 downto 0);
  signal write_addr_32 : std_logic_vector(4 downto 0);
  signal read_a_32     : std_logic_vector(4 downto 0);
  signal read_b_32     : std_logic_vector(4 downto 0);
begin
  -- Zero-extend board I/O to full 32/5-bit busses
  din_32        <= (31 downto 4 => '0') & din_in;
  write_addr_32 <= (4 downto 2 => '0') & write_address_in;
  read_a_32     <= (4 downto 2 => '0') & read_a_in;
  read_b_32     <= (4 downto 2 => '0') & read_b_in;

  -- Instantiate the full 32x32 regfile core
  u_regfile : entity work.regfile
    port map (
      din           => din_32,
      reset         => reset,
      clk           => clk,
      write         => write,
      read_a        => read_a_32,
      read_b        => read_b_32,
      write_address => write_addr_32,
      out_a         => out_a_32,
      out_b         => out_b_32
    );

  -- Expose only the low nibble to LEDs
  out_a_out <= out_a_32(3 downto 0);
  out_b_out <= out_b_32(3 downto 0);

end behavior;
