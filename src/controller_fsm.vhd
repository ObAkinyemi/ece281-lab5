----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller_fsm is
    Port ( 
        clk     : in STD_LOGIC; -- Add clock input
        i_reset : in STD_LOGIC;
        i_adv   : in STD_LOGIC;
        o_cycle : out STD_LOGIC_VECTOR (3 downto 0)
    );
end controller_fsm;

architecture FSM of controller_fsm is
    signal s_curr, s_next : std_logic_vector(3 downto 0);
    signal adv_debounced  : std_logic := '0';
    signal debounce_count  : unsigned(15 downto 0) := (others => '0');
    constant DEBOUNCE_LIMIT : unsigned(15 downto 0) := to_unsigned(10000, 16); -- Adjust for ~10ms at 100kHz

begin
    -- Next state logic
    s_next(0) <= (s_curr(3) and adv_debounced) or (s_curr(3) and i_reset and not adv_debounced) or 
                 (s_curr(2) and not adv_debounced and i_reset) or (s_curr(1) and not adv_debounced and i_reset);
    s_next(1) <= (s_curr(0) and adv_debounced) and not i_reset;
    s_next(2) <= (s_curr(1) and adv_debounced) and not i_reset;
    s_next(3) <= (s_curr(2) and adv_debounced) and not i_reset;

    -- Output logic
    o_cycle <= s_curr;

    -- Debouncer for i_adv
    debounce_process : process(clk)
    begin
        if rising_edge(clk) then
            if i_reset = '1' then
                debounce_count <= (others => '0');
                adv_debounced <= '0';
            elsif i_adv = '1' then
                if debounce_count < DEBOUNCE_LIMIT then
                    debounce_count <= debounce_count + 1;
                else
                    adv_debounced <= '1';
                end if;
            else
                debounce_count <= (others => '0');
                adv_debounced <= '0';
            end if;
        end if;
    end process;

    -- State register
    state_register : process(clk)
    begin
        if rising_edge(clk) then
            if i_reset = '1' then
                s_curr <= "0001";
            elsif adv_debounced = '1' and debounce_count >= DEBOUNCE_LIMIT then
                s_curr <= s_next;
            end if;
        end if;
    end process;
end FSM;