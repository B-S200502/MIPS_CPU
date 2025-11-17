library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity i_cache is
	port(	input_address    : in std_logic_vector(4 downto 0);
      		instruction      : out std_logic_vector(31 downto 0));
end i_cache;

architecture i_cache of i_cache is

begin
	process(input_address)
	begin
		case input_address is
		      when "00000"  => instruction <= "00100000000000130000000000000000";
		      when "00001"  => instruction <= "00100000000000010000000000000000";
		      when "00010"  => instruction <= "00100000000000100000000000000101";
		      when "00011"  => instruction <= "00000000001000100000100000100000";
		      when "00100"  => instruction <= "00100000010000101111111111111111";
		      when "00101"  => instruction <= "00010000010000110000000000000001";
		      when "00110"  => instruction <= "00001000000000000000000000000011";
		      when "00111"  => instruction <= "10101100000000010000000000000000";
		      when "01000"  => instruction <= "10001100000001000000000000000000";
		      when "01001"  => instruction <= "00110000100001000000000000001010";
		      when "01010"  => instruction <= "00110100100001000000000000000001";
		      when "01011"  => instruction <= "00111000100001000000000000001011";
		      when "01100"  => instruction <= "00111000100001000000000000000000";
		      when  others  => instruction <= "00000000000000000000000000000000";
		end case;
	end process;
end i_cache;
