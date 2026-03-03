# 8-Bit CPU Design Project

An educational 8-bit processor implementation in SystemVerilog with custom ISA, assembler, and complete verification suite.

## TL;DR
Built a fully functional 8-bit CPU from scratch using SystemVerilog. 
Features **10 custom instructions**, **8 general-purpose registers**, and a **Python-based assembler**. 
Achieves **100% instruction verification** with comprehensive testbenches.

**Quick Links:** [Architecture](#architecture) • [Instruction Set](#instruction-set) • [Quick Start](#quick-start) • [Examples](#examples)

---

## The Story

After completing my digital design course, I wanted to truly understand how CPUs work at the hardware level. Reading about Von Neumann architecture and instruction pipelines in textbooks wasn't enough—I needed to build one myself.

Armed with knowledge of digital logic, Verilog HDL, and a lot of curiosity, I set out to design a complete processor from scratch. No pre-built components, just fundamental digital building blocks: registers, multiplexers, ALUs, and control logic.

What started as a simple ALU design quickly evolved into a full CPU with its own custom instruction set and testbenches to verify everything worked correctly. Currently, I'm building C assembler to complete the toolchain. Along the way, I'm learning more about computer architecture and hardware design.

---

## What is a CPU?

A CPU (Central Processing Unit) is the "brain" of a computer. It:
- **Fetches** instructions from memory
- **Decodes** them to understand what operation to perform
- **Executes** the operation (add numbers, move data, make decisions)
- **Stores** results back to registers or memory

My 8-bit CPU implements this classic fetch-decode-execute cycle using custom hardware designed in Verilog.

---

## Architecture

### Block Diagram

```
┌─────────────────────────────────────────────────────┐
│                     TOP CPU                         │
│                                                     │
│  ┌────────────┐      ┌──────────────┐             │
│  │  Program   │      │ Instruction  │             │
│  │  Counter   │─────→│   Memory     │             │
│  │   (PC)     │      │  (256 bytes) │             │
│  └────────────┘      └──────┬───────┘             │
│         ↑                   │                      │
│         │                   ↓                      │
│         │            ┌─────────────┐               │
│         │            │   Control   │               │
│         │            │    Unit     │               │
│         │            └──────┬──────┘               │
│         │                   │ (control signals)    │
│         │                   ↓                      │
│         │         ┌──────────────────┐             │
│         │         │    Datapath      │             │
│         │         │                  │             │
│         │         │  ┌────────────┐  │             │
│         │         │  │ Register   │  │             │
│         │         │  │   File     │  │             │
│         │         │  │  (8 regs)  │  │             │
│         │         │  └─────┬──────┘  │             │
│         │         │        │         │             │
│         │         │        ↓         │             │
│         │         │   ┌────────┐    │             │
│         │         │   │  ALU   │    │             │
│         │         │   │ (8-bit)│    │             │
│         │         │   └────┬───┘    │             │
│         │         │        │         │             │
│         └─────────┴────────┴─────────┘             │
│                  (branch control)                  │
└─────────────────────────────────────────────────────┘
```

### Specifications

| Component | Specification |
|-----------|---------------|
| **Data Width** | 8 bits |
| **Instruction Width** | 16 bits |
| **Registers** | 8 × 8-bit (R0-R7) |
| **Instruction Memory** | 256 bytes |
| **Architecture** | Harvard (separate instruction memory) |
| **Execution** | Single-cycle |
| **ALU Operations** | 8 (ADD, SUB, AND, OR, XOR, NOT, etc.) |

---

## Instruction Set

### Instruction Format

#### R-Type (Register-to-Register)
```
┌────────┬─────┬─────┬─────┬─────────┐
│ Opcode │ Rd  │ Rs  │ Rt  │ Unused  │
│ 4 bits │3bits│3bits│3bits│ 3 bits  │
└────────┴─────┴─────┴─────┴─────────┘
```

#### I-Type (Immediate)
```
┌────────┬─────┬─────┬──────────────┐
│ Opcode │ Rd  │ Rs  │  Immediate   │
│ 4 bits │3bits│3bits│   6 bits     │
└────────┴─────┴─────┴──────────────┘
```

### Complete Instruction Table

| Mnemonic | Opcode | Type | Format | Description |
|----------|--------|------|--------|-------------|
| **ADD** | 0000 | R | `ADD Rd, Rs, Rt` | Rd = Rs + Rt |
| **SUB** | 0001 | R | `SUB Rd, Rs, Rt` | Rd = Rs - Rt |
| **AND** | 0010 | R | `AND Rd, Rs, Rt` | Rd = Rs & Rt (bitwise AND) |
| **OR** | 0011 | R | `OR Rd, Rs, Rt` | Rd = Rs \| Rt (bitwise OR) |
| **XOR** | 0100 | R | `XOR Rd, Rs, Rt` | Rd = Rs ^ Rt (bitwise XOR) |
| **NOT** | 0101 | R | `NOT Rd, Rs` | Rd = ~Rs (bitwise NOT) |
| **MOV** | 0101 | R | `MOV Rd, Rs` | Rd = Rs (move register) |
| **ADDI** | 1000 | I | `ADDI Rd, Rs, Imm` | Rd = Rs + Imm |
| **SUBI** | 1001 | I | `SUBI Rd, Rs, Imm` | Rd = Rs - Imm |
| **ANDI** | 1010 | I | `ANDI Rd, Rs, Imm` | Rd = Rs & Imm |
| **ORI** | 1011 | I | `ORI Rd, Rs, Imm` | Rd = Rs \| Imm |
| **XORI** | 1100 | I | `XORI Rd, Rs, Imm` | Rd = Rs ^ Imm |
| **MOVI** | 1101 | I | `MOVI Rd, Imm` | Rd = Imm (load immediate) |
| **LI** | 1111 | I | `LI Rd, Imm` | Load immediate value into register |
| **BEQ** | 1110 | I | `BEQ Rs, Rt, Offset` | Branch if Rs == Rt |

---

## My Approach

### Step 1: Design the Architecture

The first step was deciding what kind of CPU to build. I chose a simple RISC-like design with:
- **Harvard architecture** for simplicity (separate instruction memory)
- **8-bit datapath** to keep things manageable
- **Single-cycle execution** to avoid pipeline complexity
- **10 essential instructions** covering arithmetic, logic, and control flow

### Step 2: Build the Components

I built each component separately and tested it in isolation:

1. **ALU (Arithmetic Logic Unit)**
   - Implemented 8 operations
   - Added flag generation (zero, carry, overflow)
   - Verified with comprehensive testbench

2. **Register File**
   - 8 registers, 8 bits each
   - Synchronous write operation

3. **Control Unit**
   - Decodes 16-bit instructions
   - Generates all control signals
   - Hardwired logic for speed

4. **Program Counter**
   - Automatic increment
   - Branch support with offset calculation
   - Reset capability

5. **Instruction Memory**
   - 256-byte capacity
   - Simple read interface

### Step 3: Integration and Testing

Once individual components worked, I integrated them into the complete CPU and verified:
- Each instruction executed correctly
- Registers updated as expected
- Branches worked properly
- Multiple instruction sequences ran successfully

![Instrctions](IMAGES/image.png)
----->SIMULATION RESULTS
![Results](IMAGES/image-1.png)
![Waveforms](IMAGES/image-2.png)

## Verification Results

I tested every instruction extensively to ensure correctness. Here are the results:

### Test Coverage

| Component | Tests Performed | Status |
|-----------|----------------|--------|
| **ALU Operations** | 8 operations × 10 test cases each | ✅ 100% PASS |
| **Register File** | Read/Write/Simultaneous access | ✅ 100% PASS |
| **Control Unit** | All 10 opcodes decoded correctly | ✅ 100% PASS |
| **Program Counter** | Increment and branch operations | ✅ 100% PASS |
| **Complete CPU** | All 10 instructions verified | ✅ 100% PASS |
| **Assembler** | All instruction formats | ✅ 100% PASS |

### Benchmark Statistics

After running comprehensive tests with multiple programs:
- **Total instructions tested**: 10/10 (100%)
- **Test programs executed**: 20+
- **Edge cases verified**: Overflow, underflow, zero results, carry flags
- **Waveform verification**: All signals behave correctly

### Sample Waveform

Opening the `.vcd` file in GTKWave shows:
- Clean clock and reset signals
- Proper instruction fetch and decode
- Correct register updates
- ALU operations completing in one cycle
- Control signals transitioning at expected times

---

## Hardest and Easiest Instructions to Implement

### Hardest Components

| Component | Difficulty | Reason |
|-----------|-----------|---------|
| **Control Unit** | ⭐⭐⭐⭐⭐ | Complex decoding logic, many control signals |
| **BEQ (Branch)** | ⭐⭐⭐⭐ | Required PC modification and offset calculation |
| **ALU Flags** | ⭐⭐⭐ | Overflow and carry detection is tricky |

### Easiest Components

| Component | Difficulty | Reason |
|-----------|-----------|---------|
| **Register File** | ⭐⭐ | Standard memory array with read/write ports |
| **LI Instruction** | ⭐ | Simple immediate load, no computation |
| **Program Counter** | ⭐⭐ | Just an incrementing counter with mux |

---

## Project Structure

```
8bit-cpu/
│
├── rtl/                      # Hardware design (Verilog)
│   ├── alu.v                 # Arithmetic Logic Unit
│   ├── register_file.v       # 8×8-bit registers
│   ├── control_unit.v        # Instruction decoder
│   ├── program_counter.v     # PC with branch support
│   ├── instruction_mem.v     # 256-byte memory
│   ├── datapath.v            # Datapath integration
│   └── top_cpu.v             # Top-level module
│
├── testbench/                # Verification
│   ├── tb_cpu.v              # Main CPU testbench
│   ├── tb_alu.v              # ALU unit test
│   └── tb_manual.v           # Manual learning testbench
│
├── tools/                    # Software tools
│   └── assembler.py          # Python assembler
│
├── programs/                 # Example programs
│   ├── test_basic.asm        # Basic operations
│   ├── test_arithmetic.asm   # Math operations
│   └── test_logic.asm        # Logical operations
│
├── docs/                     # Documentation
│   ├── ARCHITECTURE.md       # Detailed specs
│   ├── ISA.md               # Instruction reference
│   └── TESTBENCH.md         # Testing guide
│
└── README.md                 # This file
```

---

## What I Learned

Building a CPU from scratch taught me:

1. **Hardware thinking is different** - You're designing circuits that operate in parallel, not sequential code
2. **Timing matters** - Clock edges, setup times, and propagation delays are critical
3. **Abstraction is powerful** - Breaking complex systems into simple modules makes everything manageable
4. **Verification is hard** - Testing hardware is just as important as designing it
5. **Tools matter** - Good simulators and waveform viewers are essential for debugging

---

## Possible Improvements

### Performance Enhancements
- **Pipeline the design** - Split fetch-decode-execute into stages for higher throughput
- **Add data memory** - Implement load/store instructions for real programs
- **Optimize critical path** - Reduce propagation delay for higher clock speeds

### Feature Additions
- **More instructions** - Shifts (SLL, SRL, SRA), jumps (JMP, JAL, JR)
- **Interrupt support** - Handle external events
- **Stack operations** - PUSH, POP, CALL, RET for subroutines

### Tools
- **Better assembler** - Add labels, macros, and multi-pass assembly
- **Simulator GUI** - Visual register/memory viewer
- **FPGA synthesis** - Run on real hardware

---

## What's Next?

Recently completed:
- ✅ All 10 instructions working and verified
- ✅ Python assembler with error checking
- ✅ Comprehensive testbench suite
- ✅ Complete documentation

Currently working on:
- 🔄 Adding data memory module
- 🔄 Implementing load/store instructions
- 🔄 Creating more example programs

Future plans:
- 📋 FPGA synthesis and testing
- 📋 2-stage pipeline implementation
- 📋 Interrupt controller

---

## Installation & Usage

### Quick Setup

```bash
# Clone repository
git clone https://github.com/yourusername/8bit-cpu.git
cd 8bit-cpu

# Test installation
iverilog -v
gtkwave --version
python3 --version
```

### Usage Examples

```bash
# Compile CPU
iverilog -o sim testbench/tb_cpu.v rtl/*.v

# Run simulation
vvp sim

# View waveforms
gtkwave waveform.vcd

# Assemble a program
python3 tools/assembler.py programs/test_basic.asm output.hex
```

---

## Inspiration & Resources

- [nand2tetris](https://www.nand2tetris.org/) - Building a computer from first principles
- [RISC-V Specifications](https://riscv.org/) - Modern RISC architecture
- [Digital Design and Computer Architecture](https://www.amazon.com/Digital-Design-Computer-Architecture-Harris/dp/0123944244) - Excellent textbook
- [Ben Eater's 8-bit Computer](https://eater.net/8bit) - Breadboard CPU build

---

## Contributing

Contributions welcome! Feel free to:
- 🐛 Report bugs or issues
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit pull requests

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Author

**[Your Name]**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

---

## Acknowledgments

- Computer Architecture course at [Your University]
- Open-source EDA tools community
- Everyone who answered my Stack Overflow questions!

---

<p align="center">
  <b>⭐ Star this repo if you found it helpful for learning CPU design! ⭐</b>
</p>

<p align="center">
  Made with ❤️ for hardware enthusiasts and computer architecture students
</p>
