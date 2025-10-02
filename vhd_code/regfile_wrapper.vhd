-- regfile_wrapper.vhd (snippet)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile_wrapper is
  port(
    din_in            : in  std_logic_vector(3 downto 0);
    reset             : in  std_logic;
    clk               : in  std_logic;
    write             : in  std_logic;
    read_a_in         : in  std_logic_vector(1 downto 0);
    read_b_in         : in  std_logic_vector(1 downto 0);
    write_address_in  : in  std_logic_vector(1 downto 0);
    out_a_out         : out std_logic_vector(3 downto 0);
    out_b_out         : out std_logic_vector(3 downto 0)
  );
end regfile_wrapper;

architecture behavior of regfile_wrapper is
  -- Internal 32/5-bit signals
  signal din_32        : std_logic_vector(31 downto 0);
  signal out_a_32      : std_logic_vector(31 downto 0);
  signal out_b_32      : std_logic_vector(31 downto 0);
  signal write_addr_32 : std_logic_vector(4 downto 0);
  signal read_a_32     : std_logic_vector(4 downto 0);
  signal read_b_32     : std_logic_vector(4 downto 0);

  -- Declare the core as a component
  component regfile is
    port(
      din           : in  std_logic_vector(31 downto 0);
      reset         : in  std_logic;
      clk           : in  std_logic;
      write         : in  std_logic;
      read_a        : in  std_logic_vector(4 downto 0);
      read_b        : in  std_logic_vector(4 downto 0);
      write_address : in  std_logic_vector(4 downto 0);
      out_a         : out std_logic_vector(31 downto 0);
      out_b         : out std_logic_vector(31 downto 0)
    );
  end component;
begin
  -- Zero-extend to 32/5 bits
  din_32        <= (31 downto 4 => '0') & din_in;
  write_addr_32 <= (4 downto 2 => '0') & write_address_in;
  read_a_32     <= (4 downto 2 => '0') & read_a_in;
  read_b_32     <= (4 downto 2 => '0') & read_b_in;

  -- Instantiate core
  u_regfile : regfile
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

  out_a_out <= out_a_32(3 downto 0);
  out_b_out <= out_b_32(3 downto 0);
end behavior;
