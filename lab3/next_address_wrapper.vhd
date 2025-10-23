library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity next_address_wrapper is
	port (
    		rt_in            : in std_logic_vector(1 downto 0);
    		rs_in            : in std_logic_vector(1 downto 0);
    		pc_in            : in std_logic_vector(2 downto 0);
    		target_address_in: in std_logic_vector(2 downto 0);
    		branch_type      : in std_logic_vector(1 downto 0);
    		pc_sel           : in std_logic_vector(1 downto 0);
    		next_pc_out      : out std_logic_vector(2 downto 0));
end next_address_wrapper;

architecture next_address of next_address_wrapper is
    signal rt, rs, pc, target_address, next_pc: std_logic_vector(31 downto 0);
    signal pc_temp: std_logic_vector(31 downto 0);
begin

	rt(1 downto 0) <= rt_in(1) & rt_in(0);
	rs(1 downto 0) <= rs_in(1) & rs_in(0);
	pc(2 downto 0) <= pc_in(2) & pc_in(1) & pc_in(0);
	target_address(2 downto 0) <= target_address_in(2) & target_address_in(1) & target_address_in(0);
	rt(31 downto 2) <= (others => '0');
	rs(31 downto 2) <= (others => '0');
	pc(31 downto 3) <= (others => '0');
	target_address(25 downto 3) <= (others => '0');
	next_pc_out(2 downto 0) <= next_pc (2 downto 0);

process(rt, rs, pc, pc_sel, branch_type, target_address, pc_temp)
begin    
	
	case branch_type is

		when "00" => 
			pc_temp <= pc + X"00000001";
        	when "01" =>
            		if(rs = rt) then 
                		pc_temp <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0));
            		else
                		pc_temp <= pc + X"00000001";
            		end if;
        	when "10" => 
            		if(rs /= rt) then 
               			 pc_temp <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0));
            		else
                		pc_temp <= pc + X"00000001";
            		end if;
        	when "11" => 
            		if(rs < 0) then 
                		pc_temp <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0));
            		else
                		pc_temp <= pc + X"00000001";        
			end if;
        	when others =>
			pc_temp <= pc;
	end case;

	if(pc_sel = "00") then
        	next_pc <= pc_temp;
	elsif(pc_sel = "01") then
		next_pc <= "000000" & target_address(25 downto 0);
	elsif(pc_sel = "10") then
		next_pc <= rs;
	else
		next_pc <= pc;
    	end if;
    
end process;
end next_address;
