library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile is
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
end regfile;

architecture Behavioral of regfile is
    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_array;  -- Don't initialize here - let reset handle it
begin

    -- Asynchronous read process (matches reference implementation)
    read_process : process(read_a, read_b, registers)
    begin
        -- Read register A (R0 is always 0)
        if (read_a = "00000") then
            out_a <= (others => '0');
        else
            out_a <= registers(to_integer(unsigned(read_a)));
        end if;
        
        -- Read register B (R0 is always 0)
        if (read_b = "00000") then
            out_b <= (others => '0');
        else
            out_b <= registers(to_integer(unsigned(read_b)));
        end if;
    end process;

    -- Asynchronous reset and synchronous write (matches reference implementation)
    write_process : process(clk, reset)
    begin
        if reset = '1' then
            -- Initialize all registers to 0
            for i in 0 to 31 loop
                registers(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            -- Write to register (never write to R0)
            if write = '1' and write_address /= "00000" then
                registers(to_integer(unsigned(write_address))) <= din;
            end if;
        end if;
    end process;

end Behavioral;
