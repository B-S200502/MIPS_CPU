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
            -- New test program inspired by TED instructions

            when "00000" => instruction <= "00100000000010000000000000001010"; -- addi r4, r0, 10
            when "00001" => instruction <= "00100000000010010000000000000101"; -- addi r5, r0, 5
            when "00010" => instruction <= "00000000101010010110000000100000"; -- add  r6, r5, r5
            when "00011" => instruction <= "00000000110001000111000000100010"; -- sub  r7, r6, r4
            when "00100" => instruction <= "00010000111001000000000000000011"; -- beq  r7, r4, +3

            when "00101" => instruction <= "00100000100010000000000000000001"; -- addi r4, r4, 1
            when "00110" => instruction <= "00001000000000000000000000000010"; -- jump to 2

            when "00111" => instruction <= "10101100000010010000000000000100"; -- sw   r9, 4(r0)
            when "01000" => instruction <= "10001100000010100000000000000100"; -- lw   r10,4(r0)

            when "01001" => instruction <= "00110001010010100000000000001111"; -- andi r10,r10,0xF
            when "01010" => instruction <= "00110101010010100000000000000001"; -- ori  r10,r10,0x1

            when "01011" => instruction <= "00000001010010100101100000100110"; -- xor  r11,r10,r10
            when "01100" => instruction <= "00000001011010110101100000100111"; -- nor  r11,r11,r11

            when others =>
                instruction <= "00000000000000000000000000000000"; -- don't care

        end case;
    end process;
end i_arch;
