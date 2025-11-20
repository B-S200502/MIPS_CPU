library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity i_cache is
    port(
        address_input     : in  std_logic_vector(4 downto 0);
        instruction_out : out std_logic_vector(31 downto 0)
    );
end i_cache;

architecture arch of i_cache is
begin
    process(address_input)
    begin
        case address_input is

            -- 1) LUI → load the number 0 into a register (0 × 65536 = 0)
            when "00000" => instruction_out <= "00100000000010000000000000001010"; -- load 10

            -- 2) ADDI → 0 + 10 = 10
            when "00001" => instruction_out <= "00100000000010010000000000000101"; -- load 5

            -- 3) ADD → 5 + 5 = 10
            when "00010" => instruction_out <= "00000000101010010110000000100000"; -- 5+5

            -- 4) SUB → (result from step 3) − 10 = 0
            when "00011" => instruction_out <= "00000000110001000111000000100010"; -- 10-10

            -- 5) BEQ → checks if two numbers are equal (0 == 10 → false)
            when "00100" => instruction_out <= "00010000111001000000000000000011"; -- compare 0 & 10

            -- 6) ADDI → 10 + 1 = 11
            when "00101" => instruction_out <= "00100000100010000000000000000001"; -- 10+1

            -- 7) JUMP → go back to address 2 (loop)
            when "00110" => instruction_out <= "00001000000000000000000000000010"; -- jump to 2

            -- 8) SW → store the number 5 into memory location 4
            when "00111" => instruction_out <= "10101100000010010000000000000100"; -- mem[4] ← 5

            -- 9) LW → load memory[4] (expected 5) into a register
            when "01000" => instruction_out <= "10001100000010100000000000000100"; -- load mem[4]

            -- 10) ANDI → take number AND 15 (keeps only bottom 4 bits)
            when "01001" => instruction_out <= "00110001010010100000000000001111"; -- value & 15

            -- 11) ORI → set the lowest bit (value OR 1)
            when "01010" => instruction_out <= "00110101010010100000000000000001"; -- value | 1

            -- 12) XOR → value XOR itself → always 0
            when "01011" => instruction_out <= "00000001010010100101100000100110"; -- value xor value

            -- 13) NOR → NOT(value OR value) → numeric inversion of LSB bits
            when "01100" => instruction_out <= "00000001011010110101100000100111"; -- numeric NOR

            -- 14) ADDI → add 7 to a number
            when "01101" => instruction_out <= "00100000000010000000000000000111"; -- +7

            -- 15) ADD → 7 + 3 = 10
            when "01110" => instruction_out <= "00000000100000110000100000100000"; -- 7+3

            -- 16) SLT → compare 3 < 10 → true → 1
            when "01111" => instruction_out <= "00000000011010100001000000101010"; -- 3<10 → 1

            -- 17) AND → bitwise AND: 10 & 6 = 2
            when "10000" => instruction_out <= "00000000101001100001100000100100"; -- 10&6

            -- 18) OR → bitwise OR: 10 | 6 = 14
            when "10001" => instruction_out <= "00000000101001100001100000100101"; -- 10|6

            -- 19) XOR → 10 xor 6 = 12
            when "10010" => instruction_out <= "00000000101001100001100000100110"; -- 10 xor 6

            -- 20) NOR → NOT(10 | 6) → invert lower bits
            when "10011" => instruction_out <= "00000000101001100001100000100111"; -- ~(10|6)

            when others =>
                instruction_out <= "00000000000000000000000000000000";

        end case;
    end process;
end arch;
