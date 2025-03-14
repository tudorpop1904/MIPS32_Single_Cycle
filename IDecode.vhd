----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2024 06:19:08 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecode is
    port(clk : in std_logic;
         Instr : in std_logic_vector(31 downto 0);
         RegWrite : in std_logic;
         RegDst : in std_logic;
         ExtOp : in std_logic;
         RD1 : out std_logic_vector(31 downto 0);
         RD2 : out std_logic_vector(31 downto 0);
         WD : in std_logic_vector(31 downto 0);
         Ext_Imm : out std_logic_vector(31 downto 0);
         func : out std_logic_vector(5 downto 0);
         sa : out std_logic_vector(4 downto 0));
end IDecode;

architecture Behavioral of IDecode is
signal RA1 : std_logic_vector(4 downto 0) := (others => '0');
signal RA2 : std_logic_vector(4 downto 0) := (others => '0');
signal WA : std_logic_vector(4 downto 0) := (others => '0');
component RF is
port ( clk : in std_logic;
       ra1 : in std_logic_vector(4 downto 0);
       ra2 : in std_logic_vector(4 downto 0);
       wa : in std_logic_vector(4 downto 0);
       wd : in std_logic_vector(31 downto 0);
       regwr : in std_logic;
       rd1 : out std_logic_vector(31 downto 0);
       rd2 : out std_logic_vector(31 downto 0));
end component;
begin
comp : RF port map(clk, RA1, RA2, WA, WD, RegWrite, RD1, RD2);
RA1 <= Instr(25 downto 21);
RA2 <= Instr(20 downto 16);
func <= Instr(5 downto 0);
sa <= Instr(10 downto 6);
Ext_Imm(15 downto 0) <= Instr(15 downto 0);
Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else (others => '0');
WA <= Instr(20 downto 16) when RegDst = '0' else Instr(15 downto 11);
end Behavioral;
