library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity cpu is
    port ( reset	        : in std_logic;
	   clk  	        : in std_logic; 
	   rs_out, rt_out	: out std_logic_vector(3 downto 0) := (others => '0');
	   pc_out		: out std_logic_vector(3 downto 0) := (others => '0');
	   overflow, zero	: out std_logic); 
end cpu;

architecture cpu of cpu is

--ALU Component 
component alu
port( x,y	    : in std_logic_vector(31 downto 0);
      add_sub       : in std_logic;
      logic_func    : in std_logic_vector(1 downto 0);
      func	    : in std_logic_vector(1 downto 0);
      output	    : out std_logic_vector(31 downto 0);
      overflow      : out std_logic;
      zero	    : out std_logic);
end component;

--Register File Component 
component register_32
port( din	        : in std_logic_vector(31 downto 0);
      reset	        : in std_logic;
      clk	        : in std_logic;
      write	    	: in std_logic;
      read_a	   	: in std_logic_vector(4 downto 0);
      read_b	    	: in std_logic_vector(4 downto 0);
      write_address 	: in std_logic_vector(4 downto 0);
      out_a	        : out std_logic_vector(31 downto 0);
      out_b	        : out std_logic_vector(31 downto 0));
end component;

--Next Address Component 
component next_address
port( rt,rs	    	: in std_logic_vector(31 downto 0);
      pc		: in std_logic_vector(31 downto 0);
      target_address	: in std_logic_vector(25 downto 0);
      branch_type	: in std_logic_vector(1 downto 0);
      pc_sel	    	: in std_logic_vector(1 downto 0);
      next_pc	    	: out std_logic_vector(31 downto 0));
end component;

--PC Register Component 
component pc_register
port( address   : in std_logic_vector(31 downto 0);
      reset	: in std_logic;
      clk	: in std_logic;
      pc_out	: out std_logic_vector(31 downto 0));
end component;

--Instruction Memory Component
component i_cache
port( input_address : in std_logic_vector(4 downto 0);
      instruction   : out std_logic_vector(31 downto 0));
end component;

--Data Cache Component 
component d_cache
port( d_in	   : in std_logic_vector(31 downto 0);
      data_write   : in std_logic;
      clk	   : in std_logic;
      reset        : in std_logic;
      destination_reg : in std_logic_vector(4 downto 0);
      d_out	   : out std_logic_vector(31 downto 0));
end component;

--Sign Extension Component 
component sign_extension
port( input   : in std_logic_vector(15 downto 0);
      func    : in std_logic_vector(1 downto 0);
      output  : out std_logic_vector(31 downto 0));
end component;

--Configuration
for PC              : pc_register use entity WORK.pc_register(pc_register);
for ICache         : i_cache use entity WORK.i_cache(i_cache);
for NextAddress    : next_address use entity WORK.next_address(next_address);
for R_File          : register_32 use entity WORK.register_32(register_32);
for SignExtension  : sign_extension use entity WORK.sign_extension(sign_extension);
for A_L_U             : alu use entity WORK.alu(alu);
for DCache         : d_cache use entity WORK.d_cache(d_cache);

--Internal signals
signal current_pc, next_pc, instruction_out, data_out, reg_a_data, reg_b_data, alu_result, sign_ext_out, alu_operand_b, reg_in : std_logic_vector(31 downto 0) := X"00000000";
signal dest_reg_addr : std_logic_vector(4 downto 0) := (others => '0');
signal pc_select, branch_type, alu_control, logic_func : std_logic_vector(1 downto 0) := "00";
signal add_sub_ctrl, data_write_enable, reg_write, reg_dst, alu_src, write_back_select : std_logic := '0';

--Opcode func control signal for the Control Unit
signal opcode , func : std_logic_vector(5 downto 0) := (others => '0');
signal ctrl_sig      : std_logic_vector(13 downto 0);

begin 

--Control Unit of the CPU
	process(instruction_out, clk, reset, opcode, func, ctrl_sig)
	begin
		opcode	 <= instruction_out(31 downto 26);
		func	 <= instruction_out(5 downto 0);
		case opcode is
			when "000000" =>
				if (func = "100000") then 
					ctrl_sig <= "11100000100000"; -- add
				elsif (func = "100010") then 
					ctrl_sig <= "11101000100000"; -- sub
				elsif (func = "101010") then
					ctrl_sig <= "11100000010000"; -- slt
				elsif (func = "100100") then 
					ctrl_sig <= "11101000110000"; -- and
				elsif (func = "100101") then 
					ctrl_sig <= "11100001110000"; -- or
				elsif (func = "100110") then 
					ctrl_sig <= "11100010110000"; -- xor
				elsif (func = "100111") then 
					ctrl_sig <= "11100011110000"; -- nor
				elsif (func = "001000") then 
					ctrl_sig <= "00000000000010"; -- jr
				else end if;
			when "000001" => 
				ctrl_sig <= "00000000001100"; -- bltz
			when "000010" => 
				ctrl_sig <= "00000000000001"; -- j
			when "000100" => 
				ctrl_sig <= "00000000000100"; -- beq
			when "000101" => 
				ctrl_sig <= "00000000001000"; -- bne
			when "001000" => 
				ctrl_sig <= "10110000100000"; -- addi
			when "001010" => 
				ctrl_sig <= "10110000010000"; -- slti
			when "001100" => 
				ctrl_sig <= "10110000110000"; -- andi
			when "001101" => 
				ctrl_sig <= "10110001110000"; -- ori
			when "001110" => 
				ctrl_sig <= "10110010110000"; -- xori
			when "001111" => 
				ctrl_sig <= "10110000000000"; -- lui
			when "100011" => 
				ctrl_sig <= "10010010100000"; -- lw
			when "101011" => 
				ctrl_sig <= "00010100100000"; -- sw
			when others =>
		end case;

		pc_select         <= ctrl_sig(1 downto 0);
		branch_type       <= ctrl_sig(3 downto 2);
		alu_control       <= ctrl_sig(5 downto 4);
		logic_func        <= ctrl_sig(7 downto 6);
		data_write_enable <= ctrl_sig(8);
		add_sub_ctrl      <= ctrl_sig(9);
		alu_src           <= ctrl_sig(10);
		write_back_select <= ctrl_sig(11);
		reg_dst	          <= ctrl_sig(12);
		reg_write         <= ctrl_sig(13);
		
	end process;

--Component Mapping
PC: pc_register port map(address => next_pc,
		         reset   => reset,
		         clk     => clk,
		         pc_out  => current_pc);

ICache: i_cache port map(input_address => current_pc(4 downto 0),
		          instruction   => instruction_out);

NextAddress: next_address port map(rt             => reg_b_data,
				    rs             => reg_a_data,
				    pc             => current_pc,
				    target_address => instruction_out(25 downto 0), 
				    branch_type    => branch_type,
				    pc_sel         => pc_select,
				    next_pc        => next_pc);

R_File: register_32 port map(din 	   => reg_in,
		             reset 	   => reset,
		             clk           => clk,
		             write         => reg_write, 
		             read_a        => instruction_out(25 downto 21),
		             read_b        => instruction_out(20 downto 16),
		             write_address => dest_reg_addr,
		             out_a 	   => reg_a_data,
		             out_b 	   => reg_b_data);

SignExtension: sign_extension port map(input  => instruction_out(15 downto 0),
			                func   => alu_control,
			                output => sign_ext_out);

A_L_U: alu port map(x          => reg_a_data, 
		  y          => alu_operand_b,
		  add_sub    => add_sub_ctrl,
		  logic_func => logic_func, 
		  func       => alu_control,
		  output     => alu_result, 
		  overflow   => overflow,
		  zero       => zero);

DCache: d_cache port map(d_in 		  => reg_b_data,
		          reset 	  => reset,
		          clk 		  => clk, 
		          destination_reg => alu_result(4 downto 0),
		          data_write 	  => data_write_enable,
		          d_out 	  => data_out);

--MUX Logic
dest_reg_addr <= instruction_out(20 downto 16) when (reg_dst = '0') else
	         instruction_out(15 downto 11) when (reg_dst = '1');

alu_operand_b <= reg_b_data when (alu_src = '0') else 
		 sign_ext_out when (alu_src = '1');

reg_in <= data_out when (write_back_select = '0') else 
	  alu_result when (write_back_select = '1');

rs_out	<= reg_a_data(3 downto 0);
rt_out	<= reg_b_data(3 downto 0);
pc_out	<= current_pc(3 downto 0);

end cpu;
