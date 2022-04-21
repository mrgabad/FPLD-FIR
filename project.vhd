LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.numeric_std.ALL;

ENTITY fir_direct IS GENERIC (
NUM_COEF : NATURAL := 11; 
BITS_COEF : NATURAL :- 4; 
BITS_IN : NATURAL := 4;
BITS_OUT : NATURAL := 10); 
PORT (
clk, rst : IN STD_LOGIC; 
x : IN STD_LOGIC_VECTOR (BITS_IN-1 DOWNTO 0);
y : OUT STD_LOGIC_VECTOR (BITS_OUT-1 DOWNTO 0)); 
END ENTITY;

ARCHITECTURE fpga OF fir_direct IS 
TYPE int array IS ARRAY ( TO NUM_COEF-1) OF INTEGER RANGE
   -2**(BITS_COEF-1) TO 2**(BITS_COEF-1)-1; 
CONSTANT coef : int_array := (-8,-5, -5,-1,1,2,2,3,5,7,7); 
TYPE signed_array IS ARRAY (NATURAL RANGE <>) OF SIGNED;
SIGNAL shift_reg : signed array(0 TO NUM COEF-1) (BITS COEF-1 DOWNTO 0); 
SIGNAL prod: signed_array(0 TO NUM_COEF-1)(BITS_IN+BITS_COEF-1 DOWNTO 0);
SIGNAL sum: signed_array(0 TO NUM_COEF-1) (BITS_OUT-1 DOWNTO 0); 
BEGIN
PROCESS(clk,rst) 
BEGIN IF rst = '0' THEN
shift_reg <= (OTHERS => (OTHERS => '0')); 
ELSIF 
rising edge(clk) THEN
shift reg <- SIGNED(x) & shift_reg(0 TO NUM_COEF-2); 
END IF; 
END PROCESS;

mult: FOR i IN 0 TO NUM_COEF-1 GENERATE 
prod(i) <- TO_SIGNED( coef(i), BITS_COEF) * shift_reg(i);
END GENERATE;

sum() <= resize (prod(0), BITS_OUT); 
adder: FOR i IN 1 TO NUM_COEF-1 GENERATE 
sum(i) <- sum(i-1) + prod(i); 
END GENERATE;

y <= STD_LOGIC_VECTOR(Sum(NUM_COEF-1)); 
END ARCHITECTURE;