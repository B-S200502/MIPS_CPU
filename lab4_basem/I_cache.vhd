-- File is split into 5 groups for the sake of modelsim tests
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity i_cache is
    port( input_address : in std_logic_vector(4 downto 0);
          instruction   : out std_logic_vector(31 downto 0));
end i_cache;

architecture i_cache of i_cache is
begin
    process(input_address)
    begin
        case input_address is

            --  GROUP 1: BASIC ALU + ADDI TESTS
            when "00000" => instruction <= "00100000000000110000000000000000"; -- addi r3,r0,0?
            when "00001" => instruction <= "00100000000000010000000000000000"; -- addi r1,r0,0?
            when "00010" => instruction <= "00100000000000100000000000000101"; -- addi r2,r0,5
            when "00011" => instruction <= "00000000001000100000100000100000"; -- add r1,r1,r2
            when "00100" => instruction <= "00100000010000101111111111111111"; -- addi r2,r2,-1

            --  GROUP 2: BRANCH TESTS (BEQ / BNE / BLTZ)
            when "00101" => instruction <= "00010000010000110000000000000001"; -- beq r2,r3,label
            when "00110" => instruction <= "00010100010000110000000000000001"; -- bne r2,r3,label
            when "00111" => instruction <= "00000100010000000000000000000001"; -- bltz r2,label

            --  GROUP 3: JUMP TESTS
            when "01000" => instruction <= "00001000000000000000000000000011"; -- j pc=3
            when "01001" => instruction <= "00000000001000000000000000001000"; -- jr r1

            --  GROUP 4: LOGICAL IMMEDIATES (ANDI ORI XORI)
            when "01010" => instruction <= "00110000100001000000000000001010"; -- andi r4,r4,0x0A
            when "01011" => instruction <= "00110100100001000000000000000001"; -- ori r4,r4,1
            when "01100" => instruction <= "00111000100001000000000000001011"; -- xori r4,r4,11

            --  GROUP 5: LOAD / STORE
            when "01101" => instruction <= "10101100000000010000000000000000"; -- sw r1,0(r0)
            when "01110" => instruction <= "10001100000001000000000000000000"; -- lw r4,0(r0)

            -- DEFAULT
            when others => instruction <= (others => '0');

        end case;
    end process;
end i_cache;
