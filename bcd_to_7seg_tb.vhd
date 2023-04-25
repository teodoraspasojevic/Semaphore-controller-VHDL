library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_7seg_tb is 
end bcd_to_7seg_tb;

architecture Test of bcd_to_7seg_tb is 
	component bcd_to_7seg is 
		port(
			digit	: in 	std_logic_vector (3 downto 0);
			display	: out 	std_logic_vector (6 downto 0)
		);
	end component;

	signal digit	: std_logic_vector (3 downto 0) := "0000";
	signal display	: std_logic_vector (6 downto 0);
	
begin

	bcd_to_7seg_INST	: bcd_to_7seg port map (
		digit 	=> digit,
		display	=> display
	);

	STIMULUS: process
	begin
		digit <= "0000";
		wait for 1 ns;
		digit <= "0001";
		wait for 1 ns;
		digit <= "0010";
		wait for 1 ns;
		digit <= "0011";
		wait for 1 ns;
		digit <= "0100";
		wait for 1 ns;
		digit <= "0101";
		wait for 1 ns;
		digit <= "0110";
		wait for 1 ns;
		digit <= "0111";
		wait for 1 ns;
		digit <= "1000";
		wait for 1 ns;
		digit <= "1001";
		wait for 1 ns;
		digit <= "1010";
		wait;
	end process STIMULUS; 	

end architecture Test;