# **ECC Scalar Multiplication on Curve25519 (Verilog)**  

This repository contains a Verilog implementation of scalar multiplication for **Elliptic Curve Cryptography (ECC)** on **Curve25519**. It includes various finite field arithmetic modules optimized for performance, leading to an efficient implementation of the **Montgomery ladder** algorithm for secure scalar multiplication.  

## **Features**  

- **Finite Field Adder/Subtractor**  
  - Performs addition and subtraction over the prime field used in Curve25519.  

- **Finite Field Multiplier**  
  - Computes **256-bit multiplication** in **176 clock cycles**.  
  - Utilizes **24 × 16-bit multipliers** for efficient computation inside **DSP Blocks**.  

- **Finite Field Inversion**  
  - Implemented using the **Extended Euclidean Algorithm (EEA)** for modular inversion.  

- **ECC Scalar Multiplication**  
  - Computes **$x_q = [k] x_p$** using the **Montgomery ladder** algorithm.  
  - Ensures **constant-time execution** for resistance against timing attacks.  

## **Getting Started**  

### **Requirements**  
- Verilog simulator (e.g., **ModelSim, Icarus Verilog**)  
- FPGA synthesis tool (e.g., **Vivado, Quartus, Yosys**)  

### **Simulation & Testing**  


1. Run any of the files (say `ffm.v` with its testbench `ffm_tb.v` for multiplier) to observe results for individual arithmetic modules.
2. Run `boss.v` with its testbench `boss_tb.v` to observe the scalar multiplication module.

### **Feedback**  

Feel free to reach out or initiate a pull request if you find any issues!




