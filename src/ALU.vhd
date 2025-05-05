----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

signal w_result, a, b : std_logic_vector (7 downto 0);
signal w_flags    : std_logic_vector (3 downto 0);
signal w_opp : std_logic_vector(2 downto 0);


begin
    ALU_process : process(w_flags, i_op, i_A, i_B)
        if i_op = "000" then
         w_result <= std_logic_vector(signed(i_A) + signed(i_B));
        if i_op = "001" then
         w_result <= std_logic_vector(signed(i_A) - signed(i_B));
        
        if i_op = "010" then
        o_result <= i_A and i_B;
         
        if i_op = "011" then
         o_result <= i_A or i_B;
        
-- concurrent statments
 

        variable result : resize(unsigned(i_A), 9) + resize(unsigned(i_B), 9);
        begin
            if (result(7) = '1') then
                w_flags(3) = '1'; --Negative flag
            
            if (result = "000000000") then
                w_flags(2) = '1'; --Zero Flag
            
            if (result(8) = '1' and w_op(1) = '1') then
                w_flags(1) = '1'; -- Carry flag
            
            
            if ( AND(w_op(1),XOR(result(7),i_A(7)),XNOR(w_op(0),i_A(7),i_B(7)) )  ) then
                w_flags(0) = '1';
                
        end if;
    end process ALU_process;
    
    

end Behavioral;
