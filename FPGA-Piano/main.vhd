library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity piano is
port
( 						
    psdata: in std_logic; -- NET "psdata" LOC = "G13" | IOSTANDARD = LVCMOS33 | DRIVE = 8 | SLEW = SLOW ;
    psclk: in std_logic; -- NET "psclk" LOC = "G14" | IOSTANDARD = LVCMOS33 | DRIVE = 8 | SLEW = SLOW ;
    speaker: out std_logic -- NET "speaker" LOC = "A6" | IOSTANDARD = LVCMOS33 | SLEW = FAST | DRIVE = 8 ;
    -- Pakai 1k resistor, ground ke pin GND di J2
);
end piano;

architecture Behavioral of piano is
    signal ps2_data : std_logic_vector(7 downto 0) := (others => '0');
    signal ps2_clk : std_logic := '0';
    signal freq : integer range 0 to 100000000 := 0;
    signal octave : integer range 0 to 7 := 4;
    type key_table is array(character range '<' to 'Z') of integer range 0 to 100000000;
    constant key_freqs : key_table := (
        '<' => 0, -- unused
        'Q' => 65406, 'W' => 73416, 'E' => 82407, 'R' => 87307, 'T' => 97999,
        'Y' => 110000, 'U' => 123470, 'I' => 130810, 'O' => 146830, 'P' => 164810,
        'Z' => 174610, 'X' => 196000, 'C' => 220000, 'V' => 246940, 'B' => 261630,
        'N' => 293660, 'M' => 329630, ',' => 349230, '.' => 392000, '/' => 440000,
        '2' => 69296, '3' => 77782, '5' => 92499, '6' => 103830, '7' => 116540,
        '9' => 138590, '0' => 155560, 'S' => 185000, 'D' => 207650, 'F' => 233080,
        'H' => 277180, 'J' => 311130, 'L' => 369990, ';' => 415300
    );
begin
    ps2_clk <= psclk;

    process(ps2_clk)
    begin
        if rising_edge(ps2_clk) then
            if psdata = '0' then
                ps2_data <= ps2_data(6 downto 0) & '1';
            else
                ps2_data <= ps2_data(6 downto 0) & '0';
            end if;
        end if;
    end process;

    process(ps2_data)
    begin
        case ps2_data is
            when "111000001" => -- Q
                freq <= key_freqs('Q');
            when "111100001" => -- W
                freq <= key_freqs('W');
            when "111010001" => -- E
                freq <= key_freqs('E');
            when "111101001" => -- R
                freq <= key_freqs('R');
            when "111001001" => -- T
                freq <= key_freqs('T');
            when "111110001" => -- Y
                freq <= key_freqs('Y');
            when "111111001" => -- U
                freq <= key_freqs('U');
            when "111011001" => -- I
                freq <= key_freqs('I');
            when "111100101" => -- O
                freq <= key_freqs('O');
            when "111101101" => -- P
                freq <= key_freqs('P');
            when "110101001" => -- Z
                freq <= key_freqs('Z');
            when "111001101" => -- X
                freq <= key_freqs('X');
            when "111000101" => -- C
                freq <= key_freqs('C');
            when "111010101" => -- V
                freq <= key_freqs('V');
            when "111011101" => -- B
                freq <= key_freqs('B');
            when "111001011" => -- N
                freq <= key_freqs('N');
            when "111100011" => -- M
                freq <= key_freqs('M');
            when "111101011" => -- ,
                freq <= key_freqs(',');
            when "111110011" => -- .
                freq <= key_freqs('.');
            when "111111011" => -- /
                freq <= key_freqs('/');
            when "110010001" => -- 2
                freq <= key_freqs('2');
            when "110011001" => -- 3
                freq <= key_freqs('3');
            when "110101101" => -- 5
                freq <= key_freqs('5');
            when "110110101" => -- 6
                freq <= key_freqs('6');
            when "110111101" => -- 7
                freq <= key_freqs('7');
            when "111001111" => -- 9
                freq <= key_freqs('9');
            when "111001101" => -- 0
                freq <= key_freqs('0');
            when "111010011" => -- S
                freq <= key_freqs('S');
            when "111100011" => -- D
                freq <= key_freqs('D');
            when "111101011" => -- F
                freq <= key_freqs('F');
            when "111110101" => -- H
                freq <= key_freqs('H');
            when "111111101" => -- J
                freq <= key_freqs('J');
            when "110101111" => -- L
                freq <= key_freqs('L');
            when "110110111" => -- ;
                freq <= key_freqs(';');
            when others =>
                freq <= 0;
        end case;
    end process;

    process(freq)
    begin
        if freq = 0 then
            speaker <= '0';
        else
            speaker <= not speaker;
            wait for 50000000 / freq; -- 50 MHz clock
        end if;
    end process;
end Behavioral;
