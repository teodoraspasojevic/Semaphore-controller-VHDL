library ieee;
use ieee.std_logic_1164.all;

entity traffic_light is

	port (
		reset	: in std_logic;
		clk		: in std_logic;
		rc		: out std_logic;
		yc		: out std_logic;
		gc		: out std_logic;
		rp		: out std_logic;
		gp		: out std_logic;
		time_d1	: out std_logic_vector (3 downto 0);	-- desetice
		time_d2	: out std_logic_vector (3 downto 0)		-- jedinice
	);

end entity traffic_light;

architecture Behavioral of traffic_light is

	-- definisemo tip koji koristimo za imenovanje stanja
	type State_t is (redRed1,redGreen,redRed2,redYellowRed,greenRed,yellowRed);
	signal state_reg, next_state: State_t; 
	
	-- konstanta koja definise max vrednost koju moze uzeti brojac
	constant C_MAX_CNT : integer := 200;
	-- signal brojaca, koji broji unazad
	signal timeout_cnt	: integer range 0 to C_MAX_CNT;

begin

	STATE_TRANSITION: process (clk) is
	-- PROCES ZA PRELAZAK IZMEDJU STANJA:
		-- realizujemo kontroler sa sinhronim resetom
		-- ukoliko je reset aktivan (=1), postavljamo stanje na redRed1
		-- ukoliko je reset neaktivan (=0), postavljamo trenutno stanje na sledece stanje
		-- koristimo makro rising_edge umesto if (clk'event and clk='1')
	begin
		if rising_edge(clk) then
			if reset = '1' then 
				state_reg <= redRed1;
			else 
				state_reg <= next_state;
			end if;
		end if;
	end process STATE_TRANSITION;
	
	NEXT_STATE_LOGIC: process (state_reg, timeout_cnt) is 
	-- PROCES ZA GENERISANJE SLEDECEG STANJA:
		-- posto je ovo kombinaciona logika, u listi osetljivosti se moraju naci svi signali
		-- stanje se menja na osnovu trenutnog stanja, i samo ukoliko je brojac dosao do broja 1, kada prestaje da traje trenutno stanje
	
	begin
		case (state_reg) is
			when redRed1 =>
				if (timeout_cnt=1) then
					next_state <= redGreen;
				else 
					next_state <= redRed1;
				end if;
			when redGreen =>
				if (timeout_cnt=1) then
					next_state <= redRed2;
				else 
					next_state <= redGreen;
				end if;
			when redRed2 =>
				if (timeout_cnt=1) then
					next_state <= redYellowRed;
				else 
					next_state <= redRed2;
				end if;
			when redYellowRed =>
				if (timeout_cnt=1) then
					next_state <= greenRed;
				else 
					next_state <= redYellowRed;
				end if;
			when greenRed =>
				if (timeout_cnt=1) then
					next_state <= yellowRed;
				else 
					next_state <= greenRed;
				end if;
			when yellowRed =>
				if (timeout_cnt=1) then
					next_state <= redRed1;
				else 
					next_state <= yellowRed;
				end if;
			-- nije nam potrebno when others jer je case pozvan za state_reg koji je tipa State_t, cije smo sve moguce vrednosti pokrili
		end case;
	end process NEXT_STATE_LOGIC;
	
	TIMEOUT: process (clk, timeout_cnt) is
	-- PROCES ZA GENERISANJE BROJACA:
		-- brojac se menja na svaku uzlaznu ivicu takta
		-- ukoliko nije dosao do 1, nije se jos uvek zavrsilo trenutno stanje i dekrementiramo ga
		-- ukoliko je dosao do 1, zavrsilo se trenutno stanje i brojacu dodeljujemo vrednost trajanja sledeceg stanja
		-- kako je frekvencija 8Hz, dobijamo da je perioda 125ms, pa jedna sekunda vredi 8 takta, pa dobijamo ove granicne vrednosti
	begin
		if rising_edge (clk) then
			if reset = '1' then 
				timeout_cnt <= 16; 								--2s
			else 
				case (state_reg) is
					when redRed1 =>
						if (timeout_cnt=1) then
							timeout_cnt <= 72;					--9s
						else 
							timeout_cnt <= timeout_cnt - 1 ;
						end if;
					when redGreen =>
						if (timeout_cnt=1) then
							timeout_cnt <= 16;					--2s
						else 
							timeout_cnt <= timeout_cnt - 1 ;
						end if;
					when redRed2 =>
						if (timeout_cnt=1) then
							timeout_cnt <= 8;					--1s
						else 
							timeout_cnt <= timeout_cnt - 1 ;
						end if;
					when redYellowRed =>
						if (timeout_cnt=1) then
							timeout_cnt <= 176;					--22s
						else 
							timeout_cnt <= timeout_cnt - 1 ;
						end if;
					when greenRed =>
						if (timeout_cnt=1) then
							timeout_cnt <= 8;					--1s
						else 
							timeout_cnt <= timeout_cnt - 1 ;
						end if;
					when yellowRed =>
						if (timeout_cnt=1) then
							timeout_cnt <= 16;					--2s
						else 
							timeout_cnt <= timeout_cnt - 1 ;
						end if;
				end case;
			end if;
		end if;
	end process TIMEOUT;

OUTPUT_LOGIC: process (state_reg,timeout_cnt) is
	--PROCES ZA GENERISANJE IZLAZNIH SIGNALA:
		-- u svim stanjima osim u greenRed za signale time_d1 i time_d2 cemo staviti neku vrednost koja nema izlaz na displeju("1010"-"1111" - npr. "1010")
		-- u stanju greenRed generisemo vrednosti za signale time_d1 i time_d2
	begin
		case state_reg is 
			when redRed1 =>
				rc <= '1';
				yc <= '0';
				gc <= '0';
				rp <= '1';
				gp <= '0';
				time_d1 <= "1010";
				time_d2 <= "1010";
			when redGreen => 
				rc <= '1';
				yc <= '0';
				gc <= '0';
				rp <= '0';
				gp <= '1';
				time_d1 <= "1010";
				time_d2 <= "1010";
			when redRed2 =>
				rc <= '1';
				yc <= '0';
				gc <= '0';
				rp <= '1';
				gp <= '0';
				time_d1 <= "1010";
				time_d2 <= "1010";
			when redYellowRed =>
				rc <= '1';
				yc <= '1';
				gc <= '0';
				rp <= '1';
				gp <= '0';
				time_d1 <= "1010";
				time_d2 <= "1010";
			when greenRed =>
				rc <= '0';
				yc <= '0';
				gc <= '1';
				rp <= '1';
				gp <= '0';
				
				-- na izlazu se nece prikazivati vise od 22s jer je najvece cekanje 22s
				if (timeout_cnt>168) then		-- 22
					time_d1 <= "0010";
					time_d2 <= "0010";
				elsif (timeout_cnt>160) then	-- 21
					time_d1 <= "0010";
					time_d2 <= "0001";
				elsif (timeout_cnt>152) then	-- 20
					time_d1 <= "0010";
					time_d2 <= "0000";
				elsif (timeout_cnt>144) then	-- 19
					time_d1 <= "0001";
					time_d2 <= "1001";
				elsif (timeout_cnt>136) then	-- 18
					time_d1 <= "0001";
					time_d2 <= "1000";
				elsif (timeout_cnt>128) then	-- 17
					time_d1 <= "0001";
					time_d2 <= "0111";
				elsif (timeout_cnt>120) then	-- 16
					time_d1 <= "0001";
					time_d2 <= "0110";
				elsif (timeout_cnt>112) then	-- 15
					time_d1 <= "0001";
					time_d2 <= "0101";
				elsif (timeout_cnt>104) then	-- 14
					time_d1 <= "0001";
					time_d2 <= "0100";
				elsif (timeout_cnt>96) then		-- 13
					time_d1 <= "0001";
					time_d2 <= "0011";
				elsif (timeout_cnt>88) then		-- 12
					time_d1 <= "0001";
					time_d2 <= "0010";
				elsif (timeout_cnt>80) then		-- 11
					time_d1 <= "0001";
					time_d2 <= "0001";
				elsif (timeout_cnt>72) then		-- 10
					time_d1 <= "0001";
					time_d2 <= "0000";
				elsif (timeout_cnt>64) then		-- 09
					time_d1 <= "0000";
					time_d2 <= "1001";
				elsif (timeout_cnt>56) then		-- 08
					time_d1 <= "0000";
					time_d2 <= "1000";
				elsif (timeout_cnt>48) then		-- 07
					time_d1 <= "0000";
					time_d2 <= "0111";
				elsif (timeout_cnt>40) then		-- 06
					time_d1 <= "0000";
					time_d2 <= "0110";
				elsif (timeout_cnt>32) then		-- 05
					time_d1 <= "0000";
					time_d2 <= "0101";
				elsif (timeout_cnt>24) then		-- 04
					time_d1 <= "0000";
					time_d2 <= "0100";
				elsif (timeout_cnt>16) then		-- 03
					time_d1 <= "0000";
					time_d2 <= "0011";
				elsif (timeout_cnt>8) then		-- 02
					time_d1 <= "0000";
					time_d2 <= "0010";
				else 							-- 01
					time_d1 <= "0000";
					time_d2 <= "0001";
				end if;
			when yellowRed =>
				rc <= '0';
				yc <= '1';
				gc <= '0';
				rp <= '1';
				gp <= '0';
				time_d1 <= "1010";
				time_d2 <= "1010";
		end case;
	end process  OUTPUT_LOGIC;

end architecture Behavioral;