library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity alu is
port(x, y : std_logic_vector(31 downto 0);
    add_sub : in std_logic;
    logic_func : in std_logic_vector(1 downto 0);
    func : in std_logic_vector (1 downto 0); 
    output : out std_logic_vector (31 downto 0);
    overflow : out std_logic;
    zero : out std_logic);
end alu;

architecture alu of alu is

--connections
signal logic_output : std_logic_vector(31 downto 0);
constant zero_concatenation : std_logic_vector(30 downto 0) := (others => '0');
signal add_sub_output : std_logic_vector(31 downto 0);
signal x_lessthan_y : std_logic_vector(31 downto 0);

begin

x_lessthan_y <= std_logic_vector( signed(x) - signed(y));

--Adder SUbtractor Unit
adder_subtract: process(x, y, add_sub)
begin
	if (add_sub = '0') then
		add_sub_output<= std_logic_vector( signed(x) + signed(y));
	else
		add_sub_output<= std_logic_vector( signed(x) - signed(y));
        end if;
end process;

--Logic Unit
logic_unit: process(x, y, logic_func)
begin
	if (logic_func= "00") then
		logic_output <= (x AND y);
	elsif (logic_func= "01") then 
		logic_output <= (x OR y);
	elsif (logic_func= "10") then
		logic_output<= (x XOR y);
	else 
		logic_output<= (x NOR y);
	end if;
end process;

--Zero Unit
zero_unit: process(add_sub_output)
constant zeros : std_logic_vector(31 downto 0) := (others => '0');
begin
	if (add_sub_output=zeros) then
		zero <= '1';
	else 
	   
		zero <= '0';
	end if;
end process;

--Overflow Unit
overflow_unit: process(x, y, add_sub, add_sub_output)
begin
 	if(add_sub = '0') then 
		overflow <= (x(31) AND y(31) AND NOT add_sub_output(31)) OR (NOT x(31) AND NOT y(31) AND add_sub_output(31));
 	else
		overflow <= (NOT x(31) AND y(31) AND add_sub_output(31)) OR (x(31) AND NOT y(31) AND NOT add_sub_output(31));
 	end if;
end process;

--MUX
main: process(y, add_sub_output, logic_output, func)
begin
	if(func="00") then
		output <= y;
	elsif(func="01") then 
		output <= zero_concatenation & x_lessthan_y(31);
	elsif(func="10") then
		output <= add_sub_output;
	else
		output <= logic_output;
	end if;
end process;
end alu;
