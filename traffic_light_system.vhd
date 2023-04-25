library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_system is 
	port (
		reset 		: in std_logic;
		clk			: in std_logic;
		rc			: out std_logic;
		yc			: out std_logic;
		gc			: out std_logic;
		rp			: out std_logic;
		gp			: out std_logic;
		display1	: out std_logic_vector (6 downto 0);
		display0	: out std_logic_vector (6 downto 0)
	);
end traffic_light_system;

architecture Structural of traffic_light_system is

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

	component bcd_to_7seg is 
		port(
			digit	: in 	std_logic_vector (3 downto 0);
			display	: out 	std_logic_vector (6 downto 0)
		);
	end component;

	-- pomocni signali koje koristimo, jer signali time_d1 i time_d2 ne mogu da se koriste kao ulazi jer su vec definisani kao izlazni signali komponenti
	signal data1 : std_logic_vector(3 downto 0);
	signal data2 : std_logic_vector(3 downto 0);

begin

	TRAFFIC_LIGHT_INST: traffic_light port map (reset,clk,rc,yc,gc,rp,gp,data1, data2);
	BCD_TO_7SEG_INST1: bcd_to_7seg port map (data1,display1);
	BCD_TO_7SEG_INST2: bcd_to_7seg port map (data2,display0);

end architecture Structural;