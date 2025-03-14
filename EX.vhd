----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2024 06:26:21 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    port(RD1 : in std_logic_vector(31 downto 0);
         ALUSrc : in std_logic;
         RD2 : in std_logic_vector(31 downto 0);
         Ext_Imm : in std_logic_vector(31 downto 0);
         sa : in std_logic_vector(4 downto 0);
         funct : in std_logic_vector(5 downto 0);
         AluOp : in std_logic_vector(5 downto 0);
         PCPlus : in std_logic_vector(31 downto 0);
         Zero : out std_logic;
         ALURes : out std_logic_vector(31 downto 0);
         BranchAddr: out std_logic_vector(31 downto 0));
end EX;

architecture Behavioral of EX is
signal ALUCtrl : std_logic_vector(2 downto 0);
signal secondData : std_logic_vector(31 downto 0);
signal ALUCmp : std_logic;
begin

Zero <= '1' when (RD1 = secondData) else '0';

process(ALUOp)
begin
    case ALUOp is
        when "000000" => -- R-Type
            case funct is
                when "100000" => -- add
                    ALUCtrl <= "000"; -- adunare pe ALU
                when "100010" => -- sub
                    ALUCtrl <= "100"; -- scadere pe ALU
                when "000000" => -- sll
                    ALUCtrl <= "110"; -- Deplasare la stanga pe ALU
                when "000010" => -- srl
                    ALUCtrl <= "101"; -- Deplasare logica la dreapta pe ALU
                when "000011" => -- sra
                    ALUCtrl <= "111"; -- Deplasare aritmetica la dreapta pe ALU
                when "100100" => -- and
                    ALUCtrl <= "001"; -- Conjunctie pe ALU
                when "100101" => -- or
                    ALUCtrl <= "010"; -- Disjunctie pe ALU
                when "100110" => -- xor
                    ALUCtrl <= "011"; -- Disjunctie exclusiva pe ALU
            end case;
        when "001000" => -- addi
            ALUCtrl <= "000"; -- adunare
        when "100011" => -- lw
            ALUCtrl <= "000"; -- adunare
        when "101011" => -- sw
            ALUCtrl <= "000"; -- adunare
        when "000100" => -- beq
            ALUCtrl <= "100"; -- scadere
        when "001010" => -- slti
            ALUCtrl <= "100"; -- scadere
        when "000111" => -- bgtz
            ALUCtrl <= "100"; -- scadere
        when "000010" => -- j
            ALUCtrl <= "000"; -- adunare, irelevant
    end case;
end process;

secondData <= RD2 when ALUSrc = '0' else Ext_Imm;

process(ALUCtrl)
begin
    case ALUCtrl is
        when "000" => -- adunare
            ALURes <= RD1 + secondData;
        when "100" => -- scadere
            ALURes <= RD1 - secondData;
        when "001" => -- AND
            ALURes <= RD1 AND secondData;
        when "010" => -- OR
            ALURes <= RD1 OR secondData;
        when "011" => -- XOR
            ALURes <= RD1 XOR secondData;
        when "110" => -- Shift Left
            ALURes <= to_stdlogicvector(to_bitvector(RD1) sll conv_integer(sa));
        when "101" => -- Shift Right
            ALURes <= to_stdlogicvector(to_bitvector(RD1) srl conv_integer(sa));
        when "111" => -- "Less Than"
            if signed(RD1) < signed(secondData) then
                ALURes <= X"00000001";
            else 
                ALURes <= (others => '0');
            end if;
    end case;
end process;

end Behavioral;
