library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity cpu is
	port(
		reset : in std_logic;
		clk : in std_logic;
		rs_out, rt_out : out std_logic_vector(3 downto 0);
		pc_out : out std_logic_vector(3 downto 0);
		overflow, zero : out std_logic
	);
end cpu;

architecture rtl of cpu is

    component next_address
        port(
			rt, rs : in std_logic_vector(31 downto 0);
			pc : in std_logic_vector(31 downto 0);
			target_address : in std_logic_vector(25 downto 0);
			branch_type : in std_logic_vector(1 downto 0);
			pc_sel : in std_logic_vector(1 downto 0);
			next_pc : out std_logic_vector(31 downto 0));
    end component;

    component pc
        port (
			din : in std_logic_vector(31 downto 0);
			reset : in std_logic;
			clk : in std_logic;
			dout: out std_logic_vector(31 downto 0)
        );
    end component;

    component i_cache
        port( 
			address_in : in std_logic_vector(4 downto 0);
			instruction_out : out std_logic_vector(31 downto 0));
    end component;

    component regfile
        port( 
			din : in std_logic_vector(31 downto 0);
			reset : in std_logic;
			clk : in std_logic;
			write : in std_logic;
			read_a : in std_logic_vector(4 downto 0);
			read_b : in std_logic_vector(4 downto 0);
			write_address : in std_logic_vector(4 downto 0);
			out_a : out std_logic_vector(31 downto 0);
			out_b : out std_logic_vector(31 downto 0));
    end component;

    component alu
        port(
			x, y : in std_logic_vector(31 downto 0);
			add_sub : in std_logic;
			logic_func : in std_logic_vector(1 downto 0);
			func : in std_logic_vector(1 downto 0);
			output : out std_logic_vector(31 downto 0);
			overflow : out std_logic;
			zero : out std_logic);
    end component;

    component d_cache
        port( 
			din : in std_logic_vector(31 downto 0);
			reset : in std_logic;
			clk : in std_logic;
			write : in std_logic;
			address : in std_logic_vector(4 downto 0);
			d_out : out std_logic_vector(31 downto 0));
    end component;

    component sign_ext
        port (
			func      : in  std_logic_vector(1 downto 0);
			immediate : in  std_logic_vector(15 downto 0);
			output    : out std_logic_vector(31 downto 0)
        );
    end component;

    component control_unit
        port (
			op: in std_logic_vector(5 downto 0);
			fn: in std_logic_vector(5 downto 0);
			reg_write : out std_logic;
			reg_dst : out std_logic;
			reg_in_src : out std_logic;
			alu_src : out std_logic;
			add_sub : out std_logic;
			logic_func : out std_logic_vector(1 downto 0);
			func : out std_logic_vector(1 downto 0);
			data_write : out std_logic;
			branch_type : out std_logic_vector(1 downto 0);
			pc_sel : out std_logic_vector(1 downto 0)
        );
    end component;

    signal sig_next_pc : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_pc_dout : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_instruction_out : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_din : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_reg_address : std_logic_vector(4 downto 0) := (others => '0');
    signal sig_out_a : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_out_b : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_alusrc_out : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_alu_output : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_d_out : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_extender_out : std_logic_vector(31 downto 0) := (others => '0');
    signal sig_reg_in_src_out : std_logic_vector(31 downto 0) := (others => '0');

    signal sig_reg_write : std_logic := '0';
    signal sig_reg_dst : std_logic := '0';
    signal sig_reg_in_src : std_logic := '0';
    signal sig_alu_src : std_logic := '0';
    signal sig_add_sub : std_logic := '0';
    signal sig_logic_func : std_logic_vector(1 downto 0) := (others => '0');
    signal sig_func : std_logic_vector(1 downto 0) := (others => '0');
    signal sig_data_write : std_logic := '0';
    signal sig_branch_type : std_logic_vector(1 downto 0) := (others => '0');
    signal sig_pc_sel : std_logic_vector(1 downto 0) := (others => '0');

begin

    program_counter : pc port map(
        din => sig_next_pc,
        reset => reset,
        clk => clk,
        dout => sig_pc_dout);

    instructions : i_cache port map(
        address_in => sig_pc_dout(4 downto 0),
        instruction_out => sig_instruction_out);

    registers_f : regfile port map(
        din => sig_reg_in_src_out,
        reset => reset,
        clk => clk,
        write => sig_reg_write,
        read_a => sig_instruction_out(25 downto 21),
        read_b => sig_instruction_out(20 downto 16),
        write_address => sig_reg_address,
        out_a => sig_out_a,
        out_b => sig_out_b);

    alu_comp : alu port map(
        x => sig_out_a,
        y => sig_alusrc_out,
        add_sub => sig_add_sub,
        logic_func => sig_logic_func,
        func => sig_func,
        output => sig_alu_output,
        overflow => overflow,
        zero => zero);

    datacache : d_cache port map(
        din => sig_out_b,
        reset => reset,
        clk => clk,
        write => sig_data_write,
        address => sig_alu_output(4 downto 0),
        d_out => sig_d_out);

    sign : sign_ext port map(
        func      => sig_func,
        immediate => sig_instruction_out(15 downto 0),
        output    => sig_extender_out);
    
    next_pc : next_address port map(
        rt => sig_out_b,
        rs => sig_out_a,
        pc => sig_pc_dout,
        target_address => sig_instruction_out(25 downto 0),
        branch_type => sig_branch_type,
        pc_sel => sig_pc_sel,
        next_pc => sig_next_pc);

    controller : control_unit port map(
        op => sig_instruction_out(31 downto 26),
        fn => sig_instruction_out(5 downto 0),
        reg_write => sig_reg_write,
        reg_dst => sig_reg_dst,
        reg_in_src => sig_reg_in_src,
        alu_src => sig_alu_src,
        add_sub => sig_add_sub,
        logic_func => sig_logic_func,
        func => sig_func,
        data_write => sig_data_write,
        branch_type => sig_branch_type,
        pc_sel => sig_pc_sel);

    sig_reg_address <= sig_instruction_out(20 downto 16) when (sig_reg_dst = '0') else
                       sig_instruction_out(15 downto 11);

    sig_alusrc_out <= sig_out_b when (sig_alu_src = '0') else
                      sig_extender_out;

    sig_reg_in_src_out <= sig_d_out when (sig_reg_in_src = '0') else
                          sig_alu_output;

    rs_out <= sig_out_a(3 downto 0);
    rt_out <= sig_out_b(3 downto 0);
    pc_out <= sig_pc_dout(3 downto 0);

end rtl;
