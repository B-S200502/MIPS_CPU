library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
  port(
    x, y       : in  std_logic_vector(31 downto 0);  -- 32-bit inputs
    add_sub    : in  std_logic;                      -- 0 = add, 1 = sub
    logic_func : in  std_logic_vector(1 downto 0);   -- 00=AND, 01=OR, 10=XOR, 11=NOR
    func       : in  std_logic_vector(1 downto 0);   -- 00=lui, 01=setless, 10=arith, 11=logic
    output_out : out std_logic_vector(31 downto 0);  -- 32-bit output
    overflow   : out std_logic;                      -- overflow flag
    zero       : out std_logic                       -- zero flag
  );
end alu;

architecture behavior of alu is
  signal arith_result     : std_logic_vector(31 downto 0);
  signal logic_result     : std_logic_vector(31 downto 0);
  signal slt_result       : std_logic_vector(31 downto 0);
  signal temp_overflow    : std_logic;
  signal internal_result  : std_logic_vector(31 downto 0);
begin

  -- Arithmetic (add/sub) and overflow detection
  process(x, y, add_sub)
    variable temp       : signed(31 downto 0);
    variable x_signed   : signed(31 downto 0);
    variable y_signed   : signed(31 downto 0);
  begin
    x_signed := signed(x);
    y_signed := signed(y);

    if add_sub = '0' then
      temp := x_signed + y_signed;
      temp_overflow <= (x_signed(31) and y_signed(31) and not temp(31)) or
                       (not x_signed(31) and not y_signed(31) and temp(31));
    else
      temp := x_signed - y_signed;
      temp_overflow <= (x_signed(31) and not y_signed(31) and not temp(31)) or
                       (not x_signed(31) and y_signed(31) and temp(31));
    end if;

    arith_result <= std_logic_vector(temp);
  end process;

  -- Logic operations
  process(x, y, logic_func)
  begin
    case logic_func is
      when "00" => logic_result <= x and y;
      when "01" => logic_result <= x or y;
      when "10" => logic_result <= x xor y;
      when "11" => logic_result <= not(x or y);
      when others => logic_result <= (others => '0');
    end case;
  end process;

  -- Set Less Than (slt)
  process(x, y)
  begin
    if signed(x) < signed(y) then
      slt_result <= (others => '0');
      slt_result(0) <= '1';
    else
      slt_result <= (others => '0');
    end if;
  end process;

  -- Multiplexer for final output
  process(func, arith_result, logic_result, slt_result, y)
  begin
    case func is
      when "00" => internal_result <= y;            -- lui
      when "01" => internal_result <= slt_result;   -- set less than
      when "10" => internal_result <= arith_result; -- arithmetic
      when "11" => internal_result <= logic_result; -- logic
      when others => internal_result <= (others => '0');
    end case;

    -- flags
    overflow <= temp_overflow;
    if internal_result = (others => '0') then
      zero <= '1';
    else
      zero <= '0';
    end if;
  end process;

  -- output assignment
  output_out <= internal_result;

end behavior;
