# Multiplier Implementations in Verilog

This repository contains three different implementations of multipliers in Verilog, each showcasing a distinct approach to multiplication. The implementations include:

1. **Repetitive Addition Multiplier**
2. **Add and Shift Multiplier**
3. **Booth's Multiplier**

## Contents

- `repetitive_addition_multiplier`: Verilog code for the repetitive addition multiplier, designer level testbench and outputs corresponding to the test bench.
- `add_shift_multiplier`: Verilog code for the add and shift multiplier, designer level testbench and outputs corresponding to the test bench.
- `booths_multiplier`: Verilog code for Booth's multiplier, designer level testbench and outputs corresponding to the test bench test.

## Implementation Details

### Repetitive Addition Multiplier
This implementation utilizes the repetitive addition method for multiplication. It repeatedly adds one operand to the result, based on the bits of the other operand.

### Add and Shift Multiplier
The add and shift multiplier multiplies two numbers by repeatedly adding one operand to a running total, while shifting the other operand to the right.

### Booth's Multiplier
Booth's multiplier is an algorithm that efficiently performs binary multiplication by taking advantage of the patterns in the multiplier's bit representation.

## References

The code in this repository is inspired by the book:
- **RTL Hardware Design Using VHDL** by Pong P. Chu

Make sure to refer to the mentioned book for a deeper understanding of the concepts and further insights.
