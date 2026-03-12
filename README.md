# Floating Point Execution System (IEEE-754) in Verilog

## Overview

This project implements a **Floating Point Execution System** using **Verilog HDL**.  
The system supports **IEEE-754 single precision floating point arithmetic** and executes instructions through a small processor-like architecture.

The design includes a **FIFO-based instruction buffer**, **register file**, **floating point unit (FPU)**, and a **finite state machine (FSM)** controller that manages the execution stages.

The system performs the following floating point operations:

- Addition
- Subtraction
- Multiplication

The design is verified through simulation using **Vivado waveform analysis**.

---

## Architecture

The system follows a simple instruction execution flow:

Instruction Input  
↓  
Instruction FIFO  
↓  
Instruction Decode  
↓  
Register File (Operands Fetch)  
↓  
Floating Point Unit  
↓  
Writeback to Register File

Execution stages:

1. IDLE
2. DECODE
3. EXECUTE
4. WRITEBACK

---

## Project Structure

```
FPU-Execution-System
│
├── instruction_fifo.v      # Parameterized synchronous FIFO
├── reg_file.v              # 32x32 register file
├── fpu_simple.v            # IEEE-754 floating point unit
├── fpu_system_top.v        # Top level system module
├── tb_fpu_system.v         # Testbench for simulation
└── README.md
```

---

## Modules Description

### 1. Instruction FIFO

A **parameterizable synchronous FIFO** used for buffering incoming instructions.

Features:
- Configurable depth
- Full and empty detection
- Circular pointer addressing

Purpose:
- Allows instruction queuing before execution.

---

### 2. Register File

Implements a **32 × 32-bit register file**.

Features:
- Asynchronous read ports
- Synchronous write port
- Preloaded registers for simulation

Registers used for testing:

| Register | Value |
|--------|------|
| R1 | 5.0 |
| R2 | 1.0 |
| R3 | 3.0 |
| R4 | 2.0 |

---

### 3. Floating Point Unit

Implements **IEEE-754 single precision floating point arithmetic**.

Supported operations:

| Opcode | Operation |
|------|-----------|
| 00 | Addition |
| 01 | Subtraction |
| 10 | Multiplication |

Key features:

- Sign extraction
- Exponent alignment
- Mantissa arithmetic
- Normalization
- Overflow / underflow handling

---

### 4. Control FSM

The control unit manages execution using a **Finite State Machine**.

States:

- IDLE
- DECODE
- EXECUTE
- WRITEBACK

Responsibilities:

- Fetch instruction from FIFO
- Decode operands
- Trigger FPU computation
- Write results back to register file

---

## Instruction Format

The instruction format used in the system:

```
[31:30] Opcode
[29:25] Destination Register (rd)
[24:20] Source Register 1 (rs1)
[19:15] Source Register 2 (rs2)
```

Example instruction:

```
ADD r5, r1, r3
```

---

## Simulation

Simulation was performed using **Vivado behavioral simulation**.

Test operations performed:

| Operation | Expected Result |
|----------|----------------|
5.0 + 3.0 | 8.0 |
5.0 − 2.0 | 3.0 |
3.0 × 2.0 | 6.0 |

IEEE-754 outputs observed in waveform:

| Decimal | Hex |
|-------|------|
8.0 | 0x41000000 |
3.0 | 0x40400000 |
6.0 | 0x40C00000 |

---

## Tools Used

- Verilog HDL
- Vivado Simulator
- GitHub

---

## Future Improvements

Possible extensions of the project include:

- Support for division operation
- Handling NaN and denormal numbers
- Rounding modes
- Pipelined floating point unit
- FPGA implementation

---

## Author

**Kovid Agarwal**  
B.Tech VLSI & Microelectronics  
Indian Institute of Technology Mandi

GitHub: https://github.com/Kovid006
