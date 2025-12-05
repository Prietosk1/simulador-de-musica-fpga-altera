LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY song_selector_tb IS
END ENTITY song_selector_tb;

ARCHITECTURE test OF song_selector_tb IS

    -- Señales para conectar al UUT
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL song_id : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL load_song : STD_LOGIC := '0';

    SIGNAL duration_out : INTEGER;
    SIGNAL is_valid_song : STD_LOGIC;

    -- Periodo del reloj
    CONSTANT clk_period : TIME := 20 ns; -- 50 MHz

BEGIN

    -- Instanciacion del UUT
    uut : ENTITY work.song_selector
        PORT MAP(
            clk => clk,
            reset => reset,
            song_id => song_id,
            load_song => load_song,
            duration_out => duration_out,
            is_valid_song => is_valid_song
        );

    -- Generacion del reloj
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS clk_process;

    -- Proceso de prueba
    test_process : PROCESS
    BEGIN
        REPORT "=== Inicio de la simulacion ===";

        -- Aplicar reset
        reset <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT FOR clk_period * 5;

        -- Cargar cancion valida (id = 0)
        song_id <= "0000";
        WAIT FOR clk_period;

        load_song <= '1';
        WAIT FOR clk_period;
        load_song <= '0';
        WAIT FOR clk_period * 10;

        REPORT "Prueba 1: duration_out=" & INTEGER'image(duration_out) &
            ", is_valid_song=" & STD_LOGIC'image(is_valid_song);

        ASSERT duration_out = 5 REPORT "ERROR: La duración de canción 1 debería ser 10" SEVERITY error;
        ASSERT is_valid_song = '1' REPORT "ERROR: Canción 1 debería ser válida" SEVERITY error;

        -- Cargar cancion invalida (id = 9)
        song_id <= "1001";
        WAIT FOR clk_period;

        load_song <= '1';
        WAIT FOR clk_period;
        load_song <= '0';
        WAIT FOR clk_period * 10;

        REPORT "Prueba 2: duration_out=" & INTEGER'image(duration_out) &
            ", is_valid_song=" & STD_LOGIC'image(is_valid_song);

        ASSERT duration_out = 0 REPORT "ERROR: La duración de canción inválida debería ser 0" SEVERITY error;
        ASSERT is_valid_song = '0' REPORT "ERROR: Canción inválida debería ser inválida" SEVERITY error;

        -- Cargar otra cancion valida (id = 2)
        song_id <= "0010";
        WAIT FOR clk_period;

        load_song <= '1';
        WAIT FOR clk_period;
        load_song <= '0';
        WAIT FOR clk_period * 10;
        REPORT "Prueba 3: duration_out=" & INTEGER'image(duration_out) &
            ", is_valid_song=" & STD_LOGIC'image(is_valid_song);
        ASSERT duration_out = 14 REPORT "ERROR: La duración de canción 2 debería ser 14" SEVERITY error;
        ASSERT is_valid_song = '1' REPORT "ERROR: Canción 2 debería ser válida" SEVERITY error;

        -- Finalizar simulacion
        REPORT "Fin de la simulacion";
        WAIT;
    END PROCESS test_process;
END test;