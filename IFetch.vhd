----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2024 06:23:03 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
    port(clk : in std_logic;
         en : in std_logic;
         jump : in std_logic;
         PC_Src : in std_logic;
         branchAddr : in std_logic_vector(31 downto 0) := X"00000000";
         jumpAddr : in std_logic_vector(31 downto 0) := X"00000001";
         Instr : out std_logic_vector(31 downto 0);
         PCPlus : out std_logic_vector(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal mux1 : std_logic_vector(31 downto 0);
signal mux2 : std_logic_vector(31 downto 0);
signal Addr : std_logic_vector(31 downto 0) := X"00000000";
signal PCPlusAux : std_logic_vector(31 downto 0);
type InstrMem is array (0 to 7) of std_logic_vector(31 downto 0);
signal IM : InstrMem := (
    B"000000_01100_01100_01100_00000_100110", -- xor $12, $12, $12 (initializam suma cu 0)
    B"001000_00100_00100_0000000000000001", -- addi $4, $4, 1 (adunam valoarea lui N cu 1 pentru beq)
    B"100011_00000_00001_0000000000000001", -- lw $1, 1($0) (initializam contorul $1 cu 1)
    B"000100_00001_00100_0000000000000011", -- beq $1, $4, 3 (sarim la a 3a instructiune fata de urmatoarea instructiune)
    B"000000_01100_01100_00001_00000_100000", -- add $12, $12, $1 (sum += counter)
    B"001000_00001_00001_0000000000000001", -- addi $1, $1, 1
    B"000010_00000000000000000000000011", -- j 3
    B"000000_00000_00000_00000_00000_000000" -- sll $0, $0, $0 (NOOP)
);
begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            Addr <= mux2;
        end if;
    end if;
end process;

PCPlusAux <= Addr + 1;

mux1 <= PCPlusAux when PC_Src = '0' else branchAddr;
mux2 <= mux1 when jump = '0' else jumpAddr;

PCPlus <= PCPlusAux;

process(clk)
begin
    if rising_edge(clk) then
        Instr <= IM(conv_integer(Addr(6 downto 2)));
    end if;
end process;

end Behavioral;
