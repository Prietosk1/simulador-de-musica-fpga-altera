LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clock_divider IS
    -- Parametros genericos para definir las frecuencias de entrada y salida
    GENERIC (
        INPUT_FREQ : INTEGER := 50_000_000; -- 50 MHz
        OUTPUT_FREQ : INTEGER := 1 -- 1 Hz
    );
    PORT (
        clk_in : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk_out : OUT STD_LOGIC
    );
END ENTITY clock_divider;

ARCHITECTURE rtl OF clock_divider IS

    SIGNAL counter : INTEGER := 0;

    -- Señal interna para el reloj dividido
    SIGNAL clk_reg : STD_LOGIC := '0';

    -- Calculo del valor maximo del contador basado en las frecuencias
    CONSTANT MAX_COUNT : INTEGER := INPUT_FREQ / (2 * OUTPUT_FREQ);

BEGIN

    PROCESS (clk_in, reset)
    BEGIN
        IF reset = '1' THEN
            counter <= 0;
            clk_reg <= '0';

        ELSIF rising_edge(clk_in) THEN
            IF counter = MAX_COUNT - 1 THEN
                counter <= 0;
                clk_reg <= NOT clk_reg; -- Toggle de la señal de reloj de salida
            ELSE
                counter <= counter + 1;
            END IF;
        END IF;
    END PROCESS;

    -- Asignacion de la señal interna al puerto de salida
    clk_out <= clk_reg;

END rtl;