library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
port(
    x, y : in std_logic_vector(31 downto 0);  
    add_sub : in std_logic;
    logic_func : in std_logic_vector(1 downto 0);
    func : in std_logic_vector(1 downto 0);
    output : out std_logic_vector(31 downto 0);
    overflow : out std_logic;
    zero : out std_logic);
end alu;

architecture behavioral of alu is
    signal add_sub_out : std_logic_vector(31 downto 0);
    signal logic_out : std_logic_vector(31 downto 0);
    signal final_out : std_logic_vector(31 downto 0);
begin

arithmetic : process(x, y, add_sub)
begin
    -- Handle undefined inputs gracefully
    if (x(0) = 'U' or y(0) = 'U' or add_sub = 'U') then
        add_sub_out <= (others => '0');
    elsif add_sub = '0' then
        add_sub_out <= std_logic_vector(signed(x) + signed(y));
    else
        add_sub_out <= std_logic_vector(signed(x) - signed(y));
    end if;
end process;

logic : process(x, y, logic_func)
begin
    -- Handle undefined inputs gracefully
    if (x(0) = 'U' or y(0) = 'U') then
        logic_out <= (others => '0');
    else
        case logic_func is
            when "00" => logic_out <= x and y;
            when "01" => logic_out <= x or y;
            when "10" => logic_out <= x xor y;
            when others => logic_out <= x nor y;
        end case;
    end if;
end process;

mux : process(func, y, add_sub_out, logic_out)
begin
    case func is
        when "00" => final_out <= y;
        when "01" => final_out <= (31 downto 1 => '0') & add_sub_out(31);
        when "10" => final_out <= add_sub_out;
        when others => final_out <= logic_out;
    end case;
end process;

zero_proc : process(add_sub_out)
begin
    if add_sub_out = (31 downto 0 => '0') then zero <= '1';
    else zero <= '0';
    end if;
end process;

overflow_proc : process(x, y, add_sub_out, add_sub)
begin
    if add_sub = '0' then 
        if ((x(31) = '0' and y(31) = '0' and add_sub_out(31) = '1') or (x(31) = '1' and y(31) = '1' and add_sub_out(31) = '0')) then 
            overflow <= '1';
        else 
            overflow <= '0';
        end if;
    else
        if ((x(31) = '0' and y(31) = '1' and add_sub_out(31) = '1') or (x(31) = '1' and y(31) = '0' and add_sub_out(31) = '0')) then 
            overflow <= '1';
        else 
            overflow <= '0';
        end if;
    end if;
end process;

output <= final_out;

end behavioral;
