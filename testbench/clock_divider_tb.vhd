LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clock_divider_tb IS
END ENTITY clock_divider_tb;

ARCHITECTURE test OF clock_divider_tb IS

    -- Señales para conectar al UUT
    SIGNAL clk_in : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL clk_out : STD_LOGIC;

    -- Parametros de simulacion
    CONSTANT INPUT_FREQ : INTEGER := 50_000_000; -- 50 MHz
    CONSTANT OUTPUT_FREQ : INTEGER := 5; -- 5 Hz para simular rápido

    -- Periodo del reloj de entrada
    CONSTANT clk_period : TIME := 20 ns; -- 50 MHz

BEGIN

    -- Instanciacion del UUT
    uut : ENTITY work.clock_divider
        GENERIC MAP(
            INPUT_FREQ => INPUT_FREQ,
            OUTPUT_FREQ => OUTPUT_FREQ
        )
        PORT MAP(
            clk_in => clk_in,
            reset => reset,
            clk_out => clk_out
        );

    -- Generacion del reloj de entrada
    clk_process : PROCESS
    BEGIN
        clk_in <= '0';
        WAIT FOR clk_period / 2;
        clk_in <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS clk_process;

    -- Señal de reset
    reset_process : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT;
    END PROCESS reset_process;

    -- Finalizacion de la simulacion
    stop_sim : PROCESS
    BEGIN
        WAIT FOR 200 ms; -- Simular por 200 ms
        REPORT "Fin de la simulacion";
        WAIT;
    END PROCESS stop_sim;

END test;