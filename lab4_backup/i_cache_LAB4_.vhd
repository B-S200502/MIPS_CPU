library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity i_cache is
    port(
        address_in    : in  std_logic_vector(4 downto 0);
        instruction_out : out std_logic_vector(31 downto 0)
    );
end i_cache;

architecture arch of i_cache is
begin
    process(address)
    begin
        case address is

            when "00000" => instruction_out <= "00100000000010000000000000001010"; -- addi r4, r0, 10
            when "00001" => instruction_out <= "00100000000010010000000000000101"; -- addi r5, r0, 5
            when "00010" => instruction_out <= "00000000101010010110000000100000"; -- add r6, r5, r5
            when "00011" => instruction_out <= "00000000110001000111000000100010"; -- sub r7, r6, r4
            when "00100" => instruction_out <= "00010000111001000000000000000011"; -- beq r7, r4, +3
            when "00101" => instruction_out <= "00100000100010000000000000000001"; -- addi r4, r4, 1
            when "00110" => instruction_out <= "00001000000000000000000000000010"; -- j 2
            when "00111" => instruction_out <= "10101100000010010000000000000100"; -- sw r9, 4(r0)
            when "01000" => instruction_out <= "10001100000010100000000000000100"; -- lw r10, 4(r0)
            when "01001" => instruction_out <= "00110001010010100000000000001111"; -- andi r10, r10, 0x000F
            when "01010" => instruction_out <= "00110101010010100000000000000001"; -- ori r10, r10, 0x0001
            when "01011" => instruction_out <= "00000001010010100101100000100110"; -- xor r11, r10, r10
            when "01100" => instruction_out <= "00000001011010110101100000100111"; -- nor r11, r11, r11
            when "01101" => instruction_out <= "00111100000011000000000000000001"; -- lui r12, 1
            when "01110" => instruction_out <= "00101000011011010000000000001010"; -- slti r13, r3, 10
            when "01111" => instruction_out <= "00000001101011000110000000100100"; -- and r12, r13, r12
            when "10000" => instruction_out <= "00000001100011000111000000100101"; -- or r14, r12, r12
            when "10001" => instruction_out <= "00000001110011100111100000100110"; -- xor r15, r14, r14
            when "10010" => instruction_out <= "00000001110011110111100000100111"; -- nor r15, r15, r15
            when "10011" => instruction_out <= "00000100000011110000000000000001"; -- bltz r15, +1

            when others =>
                instruction_out <= "00000000000000000000000000000000"; -- nop

        end case;
    end process;
end arch;
