library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        x_in, y_in   : in  std_logic_vector(3 downto 0);
        add_sub      : in  std_logic;                  -- 0 = add, 1 = sub
        logic_func   : in  std_logic_vector(1 downto 0); -- 00=AND, 01=OR, 10=XOR, 11=NOR
        func         : in  std_logic_vector(1 downto 0); -- 00=LUI, 01=SLT, 10=ARITH, 11=LOGIC
        output_out   : out std_logic_vector(3 downto 0);
        overflow     : out std_logic;
        zero         : out std_logic
    );
end alu;

architecture behavior of alu is
    signal arith_result     : std_logic_vector(3 downto 0);
    signal logic_result     : std_logic_vector(3 downto 0);
    signal slt_result       : std_logic_vector(3 downto 0);
    signal temp_overflow    : std_logic;
    signal internal_result  : std_logic_vector(3 downto 0);
    signal x, y             : std_logic_vector(3 downto 0);
begin
    -- Map inputs
    x <= x_in;
    y <= y_in;

    -- Arithmetic unit
    process(x, y, add_sub)
        variable temp      : signed(3 downto 0);
        variable x_signed  : signed(3 downto 0);
        variable y_signed  : signed(3 downto 0);
    begin
        x_signed := signed(x);
        y_signed := signed(y);

        if add_sub = '0' then
            temp := x_signed + y_signed;
            temp_overflow <= (x_signed(3) and y_signed(3) and not temp(3)) or
                             ((not x_signed(3)) and (not y_signed(3)) and temp(3));
        else
            temp := x_signed - y_signed;
            temp_overflow <= (x_signed(3) and (not y_signed(3)) and (not temp(3))) or
                             ((not x_signed(3)) and y_signed(3) and temp(3));
        end if;

        arith_result <= std_logic_vector(temp);
    end process;

    -- Logic unit
    process(x, y, logic_func)
    begin
        case logic_func is
            when "00"   => logic_result <= x and y;
            when "01"   => logic_result <= x or y;
            when "10"   => logic_result <= x xor y;
            when "11"   => logic_result <= not (x or y);  -- NOR
            when others => logic_result <= (others => '0');
        end case;
    end process;

    -- Set Less Than unit
    process(x, y)
    begin
        if signed(x) < signed(y) then
            slt_result <= (others => '0');
            slt_result(0) <= '1';
        else
            slt_result <= (others => '0');
        end if;
    end process;

    -- Main output multiplexer + flags
    process(func, arith_result, logic_result, slt_result, y)
    begin
        case func is
            when "00"   => internal_result <= y;            -- LUI (pass y)
            when "01"   => internal_result <= slt_result;   -- SLT
            when "10"   => internal_result <= arith_result; -- Arithmetic
            when "11"   => internal_result <= logic_result; -- Logic
            when others => internal_result <= (others => '0');
        end case;

        -- Overflow comes from arithmetic process
        overflow <= temp_overflow;

        -- Zero flag
        if internal_result = "0000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;

    -- Drive the output
    output_out <= internal_result;

end behavior;
