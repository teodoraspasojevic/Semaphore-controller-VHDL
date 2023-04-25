library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_tb is 
end traffic_light_tb;

architecture Test of traffic_light_tb is 

component traffic_light is 
	port (
		reset 	: in std_logic;
		clk		: in std_logic;
		rc		: out std_logic;
		yc		: out std_logic;
		gc		: out std_logic;
		rp		: out std_logic;
		gp		: out std_logic;
		time_d1	: out std_logic_vector (3 downto 0);
		time_d2	: out std_logic_vector (3 downto 0)
	);
end component;
	
	constant C_CLK_PERIOD: time := 125 ms;
	signal clk : std_logic := '1';
	signal reset, rc,yc,gc,rp,gp : std_logic;
	signal time_d1	: std_logic_vector (3 downto 0) := "1010";
	signal time_d2	: std_logic_vector (3 downto 0) := "1010";
	
	
begin

	traffic_light_INST	: traffic_light port map (
		clk 	=> clk,
		reset	=> reset,
		rc		=> rc,
		yc		=> yc,
		gc		=> gc,
		rp		=> rp,
		gp		=> gp,
		time_d1 => time_d1,
		time_d2 => time_d2
	);
	
	-- umesto da pisemo poseban proces za generisanje signala takta, ovako mozemo naizmenicno menjati vrednost signala takta
	clk <= not clk after C_CLK_PERIOD/2;
		
	STIMULUS: process
	begin
		
		reset <= '1';
		
		wait for 3*C_CLK_PERIOD;
		
		reset <= '0';
		
		wait;
	end process STIMULUS; 	

end architecture Test;