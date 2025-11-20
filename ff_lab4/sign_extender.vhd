library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

-- Sign extension unit: extends 16-bit immediate to 32-bit based on func
entity sign_ext is
	port(
		func      : in  std_logic_vector(1 downto 0);
		immediate : in  std_logic_vector(15 downto 0);
		output    : out std_logic_vector(31 downto 0)
	);
end sign_ext;

architecture arch of sign_ext is
begin

	sign_extension_process : process(func, immediate)
	begin
		case(func) is
			-- "00": Load upper immediate
			when "00" => 
				output(31 downto 16) <= immediate;
				output(15 downto 0)  <= (others => '0');
			
			-- "01" or "10": Arithmetic sign extension
			when "01" | "10" => 
				output(31 downto 16) <= (others => immediate(15));
				output(15 downto 0)  <= immediate;
			
			-- "11": Logical zero extension
			when "11" => 
				output(31 downto 16) <= (others => '0');
				output(15 downto 0)  <= immediate;
			
			when others => 
				output <= (others => '0');
		end case;
	end process;

end arch;
