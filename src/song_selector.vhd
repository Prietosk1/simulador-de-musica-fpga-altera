LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY song_selector IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        song_id : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- ID de la cancion (0-3)
        load_song : IN STD_LOGIC; -- Señal para cargar la cancion

        duration_out : OUT INTEGER; -- Duracion de la cancion en segundos
        is_valid_song : OUT STD_LOGIC -- Asumiendo un maximo de 10 canciones
    );
END ENTITY song_selector;

ARCHITECTURE rtl OF song_selector IS

    SIGNAL selected_id : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL duration_r : INTEGER := 0; -- Registro de duracion
    SIGNAL is_valid_r : STD_LOGIC := '0'; -- Registro de validez

BEGIN

    -- comportamiento del selector de canciones
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            selected_id <= "00";
            duration_r <= 0;
            is_valid_r <= '0';

        ELSIF rising_edge(clk) THEN
            -- Si load_song es alta, almacenamos el ID de la cancion
            IF load_song = '1' THEN
                selected_id <= song_id;

                CASE song_id IS
                    WHEN "00" =>
                        duration_r <= 5; -- Duracion en segundos para la cancion 0
                        is_valid_r <= '1';
                    WHEN "01" =>
                        duration_r <= 8; -- Duracion en segundos para la cancion 1
                        is_valid_r <= '1';
                    WHEN "10" =>
                        duration_r <= 14; -- Duracion en segundos para la cancion 2
                        is_valid_r <= '1';
                    WHEN "11" =>
                        duration_r <= 18; -- Duracion en segundos para la cancion 3
                        is_valid_r <= '1';
                    WHEN OTHERS =>
                        duration_r <= 0;
                        is_valid_r <= '0';
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    -- Asignacion de salidas
    duration_out <= duration_r;
    is_valid_song <= is_valid_r;
END rtl;