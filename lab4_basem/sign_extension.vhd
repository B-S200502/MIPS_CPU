library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity sign_extension is
	port(	input   : in std_logic_vector(15 downto 0);
		func 	: in std_logic_vector(1 downto 0);
		output  : out std_logic_vector(31 downto 0));
end sign_extension;

architecture sign_extension of sign_extension is

begin
	process(input, func)
	begin 
		case func is
			when "00"
				=> output <= input(15 downto 0) & X"0000";
			when "01" | "10" 
				=> output <= (31 downto 16 => input(15)) & input(15 downto 0);
			when "11"
				=> output <= X"0000" & input(15 downto 0);
			when others =>
		end case;
	end process;
end sign_extension;
