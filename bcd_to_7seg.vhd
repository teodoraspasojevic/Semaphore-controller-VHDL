library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_7seg is

	port (
		digit: in std_logic_vector (3 downto 0);
		display: out std_logic_vector(6 downto 0)
	);

end entity bcd_to_7seg;

architecture Behavioral of bcd_to_7seg is 

begin

	SHINE: process (digit) is
	begin
		case(digit) is
			when "0000" =>
				display <= "0111111";
			when "0001" =>
				display <= "0000110";
			when "0010" =>
				display <= "1011011";
			when "0011" =>
				display <= "1001111";
			when "0100" =>
				display <= "1100110";
			when "0101" =>
				display <= "1101101";
			when "0110" =>
				display <= "1111101";
			when "0111" =>
				display <= "0000111";
			when "1000" =>
				display <= "1111111";
			when "1001" =>
				display <= "1101111";
			when others =>
				display <= "0000000";
		end case;
	end process SHINE;
end architecture Behavioral;