library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity i_cache is
    port(
        address     : in  std_logic_vector(4 downto 0);
        instruction : out std_logic_vector(31 downto 0)
    );
end i_cache;

architecture i_arch of i_cache is
begin
    process(address)
    begin
        case address is
            -- Inspired by the code Ted gave 
            when "00000" => instruction <= "00111100000000000000000000000000"; -- lui   r0, 0
            when "00001" => instruction <= "00000000001000100001100000100000"; -- add   r3, r1, r2
            when "00010" => instruction <= "00000000001000100001100000100010"; -- sub   r3, r1, r2
            when "00011" => instruction <= "00000000001000100001100000101010"; -- slt   r3, r1, r2
            when "00100" => instruction <= "00100000001000100000000000001010"; -- addi  r1, r1, 10
            when "00101" => instruction <= "00101000001000100000000000001010"; -- slti  r1, r1, 10
            when "00110" => instruction <= "00000000001000100001100000100100"; -- and   r3, r1, r2
            when "00111" => instruction <= "00000000001000100001100000100101"; -- or    r3, r1, r2
            when "01000" => instruction <= "00000000001000100001100000100110"; -- xor   r3, r1, r2
            when "01001" => instruction <= "00000000001000100001100000100111"; -- nor   r3, r1, r2
            when "01010" => instruction <= "00110000001000100000000000001111"; -- andi  r1, r1, 0xF
            when "01011" => instruction <= "00110100001000100000000000000001"; -- ori   r1, r1, 1
            when "01100" => instruction <= "00111000001000100000000000001111"; -- xori  r1, r1, 0xF
            when "01101" => instruction <= "10001100001000100000000000000100"; -- lw    r1, 4(r0)
            when "01110" => instruction <= "10101100001000100000000000000100"; -- sw    r1, 4(r0)
            when "01111" => instruction <= "00001000000000000000000000000100"; -- j     4
            when "10000" => instruction <= "00000000001000000000000000001000"; -- jr    r1
            when "10001" => instruction <= "00000100001000000000000000000010"; -- bltz  r1, +2
            when "10010" => instruction <= "00010000001000100000000000000010"; -- beq   r1, r1, +2
            when "10011" => instruction <= "00010100001000100000000000000010"; -- bne   r1, r1, +2

            when others => instruction <= "00000000000000000000000000000000"; -- don't care

        end case;
    end process;
end i_arch;
