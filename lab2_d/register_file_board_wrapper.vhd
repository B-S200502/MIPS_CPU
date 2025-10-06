library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity register_file_board_wrapper is

port(

        din_in : in std_logic_vector(3 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        write : in std_logic;
        read_a_in : in std_logic_vector(1 downto 0);
        read_b_in : in std_logic_vector(1 downto 0);
        write_address_in : in std_logic_vector(1 downto 0);
        out_a_out : out std_logic_vector(3 downto 0);
        out_b_out : out std_logic_vector(3 downto 0));

end register_file_board_wrapper ;

architecture register_file_board_wrapper_arch of register_file_board_wrapper is

        type type_register_array is array (0 to 31) of std_logic_vector (31 downto 0);

        signal register_array : type_register_array;

        signal din_modified : std_logic_vector (31 downto 0);

        -- Assign Port inputs to internal signals

begin

        din_modified (3 downto 0) <= din_in (3) & din_in (2) & din_in (1) & din_in (0);
        din_modified (31 downto 4) <= (others => '0');


        -- Asynchronous Reset and Synchronous Write

        write_to_register_process : process (reset, clk, write)

begin
        if (reset = '1') then

                for i in 0 to 31 loop

                        register_array(i) <= "00000000000000000000000000000000";
                end loop;

        elsif (write = '1' and rising_edge(clk)) then
		register_array(to_integer(unsigned(write_address_in))) <= din_modified;
        end if;
end process;


        -- Asynchronous Read

        read_from_register_process : process (read_a_in, read_b_in, register_array)

        variable temporary_variable : std_logic_vector (31 downto 0);

begin
        temporary_variable := register_array(to_integer(unsigned(read_a_in)));

        out_a_out <= temporary_variable (3) & temporary_variable (2) & temporary_variable (1) & temporary_variable (0);

        temporary_variable := register_array(to_integer(unsigned(read_b_in)));

        out_b_out <= temporary_variable (3) & temporary_variable (2) & temporary_variable (1) & temporary_variable (0);

end process;

end register_file_board_wrapper_arch;
