library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all; 

entity traffic_light_system_tb is
end entity traffic_light_system_tb;

architecture Test of traffic_light_system_tb is
    
    component traffic_light_system is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            display1    : out std_logic_vector(6 downto 0);
            display0    : out std_logic_vector(6 downto 0);
            rc, yc, gc, rp, gp : out std_logic    
        );
    end component;

    constant C_CLK_PERIOD: time := 125 ms;
    
    signal clk : std_logic := '1';
    signal reset: std_logic := '1';
    signal led_disp0 : std_logic_vector(6 downto 0);
    signal led_disp1 : std_logic_vector(6 downto 0);
    signal lights : std_logic_vector(4 downto 0);
    
begin
    TLS_i : traffic_light_system 
		port map (
			clk => clk, 
			reset => reset, 
			display1 => led_disp1, 
			display0 => led_disp0, 
			rc => lights(2), 
			yc => lights(3), 
			gc => lights(4), 
			rp => lights(0), 
			gp => lights(1));
    
    clk <= not clk after C_CLK_PERIOD/2;
    
    STIMULUS: process
    begin
        reset <= '1';
        
        wait for 3*C_CLK_PERIOD;
        
        reset <= '0';
        
        wait;
    end process STIMULUS;
    
    WRITE_ROM_FILE: process 
        file        data_file      : text; --is in data_file_name;
        variable    data_file_line : line;
        variable    v_romvector    : std_logic_vector(18 downto 0);
    begin
        if reset = '0' then
            file_open(data_file, "C:/romFile.txt",  write_mode);
            
            while true loop
                for i in 1 to 8 loop
                    wait for C_CLK_PERIOD;
                    v_romvector := led_disp1 & led_disp0 & lights;
                    hwrite(data_file_line, v_romvector);
                    write(data_file_line,' ');
                end loop;
                writeline(data_file, data_file_line);
            end loop;
        end if;
        wait for C_CLK_PERIOD;
    end process;

end architecture;