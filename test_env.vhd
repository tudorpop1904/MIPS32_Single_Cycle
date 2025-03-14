----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2024 06:22:39 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
         
end test_env;

architecture Behavioral of test_env is

component MPG
Port ( en : out  STD_LOGIC; 
input : in STD_LOGIC; 
clock : in  STD_LOGIC); 
end component; 

component SSD
Port(
     clk : in STD_LOGIC;
     D: in STD_LOGIC_VECTOR(31 downto 0);
     an: out Std_logic_Vector(7 downto 0);
     cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

component RF
Port(
     clk : in std_logic;
     ra1 : in std_logic_vector(4 downto 0);
ra2 : in std_logic_vector(4 downto 0);
wa : in std_logic_vector(4 downto 0);
wd : in std_logic_vector(31 downto 0);
regwr : in std_logic;
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0));
end component;

component ram_wr_1st
Port(
     clk : in std_logic;
    we : in std_logic;
    en : in std_logic;
    addr : in std_logic_vector(5 downto 0);
    di : in std_logic_vector(31 downto 0);
    do : out std_logic_vector(31 downto 0));
end component;

signal cnt: STD_LOGIC_VECTOR(5 downto 0);
signal enable : STD_LOGIC;
signal enable1 : STD_LOGIC;
signal input1 : STD_LOGIC_vector(31 downto 0);
signal input2: STD_LOGIC_vector(31 downto 0);
signal input3: STD_LOGIC_vector(31 downto 0);
signal out_alu: std_logic_vector(31 downto 0);
signal Digits: std_logic_vector(31 downto 0);
signal rd1: std_logic_vector(31 downto 0);
signal sum: std_logic_vector(31 downto 0);
signal rd2: std_logic_vector(31 downto 0);
signal do: std_logic_vector(31 downto 0);
signal instr : std_logic_vector(31 downto 0);
signal PCPLus : std_logic_vector(31 downto 0);
signal shift: std_logic_vector(4 downto 0);
signal wd : std_logic_vector(31 downto 0);
signal regwrite : std_logic;
signal regdst : std_logic;
signal extop : std_logic;
signal extended : std_logic_vector(31 downto 0);
signal func : std_logic_vector(5 downto 0);
signal pc_src : std_logic;
signal jump : std_logic;
type mem_type is array (0 to 31) of std_logic_vector(31 downto 0);
signal mem_ROM : mem_type := (
 -- M biti în reprezentare binara
X"87686756",
X"87687753",
X"87126756", -- sau hexazecimala
others => X"00000000" -- initializeaza restul locatiilor cu aceeasi valoare
);

component IFetch is
    port(clk : in std_logic;
         en : in std_logic;
         jump : in std_logic;
         PC_Src : in std_logic;
         branchAddr : in std_logic_vector(31 downto 0) := X"00000000";
         jumpAddr : in std_logic_vector(31 downto 0) := X"00000001";
         Instr : out std_logic_vector(31 downto 0);
         PCPlus : out std_logic_vector(31 downto 0));
end component;

component IDecode is
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
end component;

begin
c1 : MPG port map(enable,btn(0),clk);
c2 : MPG port map(enable1,btn(1),clk);
c3 : SSD port map(clk,Digits,an,cat);
c4 : IFetch port map(clk, enable, jump, pc_src, X"00000000", X"00000001", instr, pcplus);
c5 : IDecode port map(clk, instr, regwrite, regdst, extop, rd1, rd2, wd, extended, func, shift);
--c3: reg_file port map(clk,cnt,cnt,cnt,sum,enable1,rd1,rd2);
--c4: ram_wr_1st port map(clk,enable1,'1',cnt,shift,do);
process(instr)
begin
    case instr(31 downto 26) is
    when "000000" => pc_src <= '0'; -- Operatiile de tip R
                     jump <= '0';
                     regdst <= '1';
                     regwrite <= '1';
                     extop <= '0';
    when "001000" => pc_src <= '0'; -- add imediate
                     jump <= '0';
                     regdst <= '0';
                     regwrite <= '1';
                     extop <= '1';
    when "100011" => pc_src <= '0'; -- load word
                     jump <= '0';
                     regdst <= '0';
                     regwrite <= '1';
                     extop <= '1';
    when "101011" => pc_src <= '0'; -- store word
                     jump <= '0';
                     regdst <= '0';
                     regwrite <= '0';
                     extop <= '1';
    when "000100" => pc_src <= '1'; -- branch on equality
                     jump <= '0';
                     regdst <= '0';
                     regwrite <= '0';
                     extop <= '1';
    when "001010" => pc_src <= '0'; -- set on less than with immediate value
                     jump <= '0';
                     regdst <= '0';
                     regwrite <= '1';
                     extop <= '1';
    when "000111" => pc_src <= '1'; -- branch on greater than zero
                     jump <= '0';
                     regdst <= '1';
                     regwrite <= '0';
                     extop <= '1';
    when "000010" => pc_src <= '0'; -- jump
                     jump <= '1';
                     regdst <= '0';
                     regwrite <= '0';
                     extop <= '0';
    when others => pc_src <= '0'; -- momentan nimic
                   jump <= '0';
                   regdst <= '0';
                   regwrite <= '0';
                   extop <= '0';
    end case;
end process;


process(clk)
begin
if rising_edge(clk) then
  if enable='1' then
  if sw(0) ='0' then
  cnt<=cnt+1;
  else
  cnt<=cnt-1;
  end if;
  end if;
  end if;
  end process;
  
  
--process(cnt)
--begin
--input1<="0000000000000000000000000000" & sw(3 downto 0);
--input2<="0000000000000000000000000000" & sw(7 downto 4);
--input3<="000000000000000000000000" & sw(7 downto 0);
--case cnt(1 downto 0) is
--when "00" => 
--  out_alu<=input1+input2;
 
--when "01" =>
--  out_alu<=input1-input2;
  
-- when "10" =>
--  out_alu<=input3(29 downto 0) & "00";
  
--  when others =>
--  out_alu<="00" & input3(31 downto 2) ;
  

--end case;
--sum <=rd1+rd2;
--Digits <= sum;
--shift<=do(29 downto 0) & "00";
--Digits <= shift;

--end process;



end Behavioral;