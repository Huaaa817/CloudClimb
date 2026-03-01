# (2024 Fall) Hardware Design Lab  

## Final Project – CloudClimb (Dual-FPGA VGA Arcade System)

CloudClimb is a dual-player competitive arcade game implemented on FPGA using Verilog (with partial VHDL modules) in Vivado.

This project demonstrates real-time VGA rendering, FSM-based control logic, multi-device integration, and hardware-level system coordination.

---

## Project Overview

- Designed a dual-FPGA competitive arcade game system  
- Implemented a VGA display controller (640×480 resolution)  
- Built a grid-based rendering engine with vertical scrolling mechanics  
- Developed a Finite State Machine (FSM) supporting:
  - `INITIAL`
  - `GAME`
  - `FINISH`
- Integrated keyboard and mouse input via PS/2 interface  
- Implemented real-time collision detection and scoring logic  
- Displayed player scores using seven-segment displays  
- Controlled win/lose results through LED hardware signaling  
- Integrated PMOD-based background music and event-triggered sound effects  

---

## Technical Highlights

- FPGA-based synchronous digital system design  
- FSM architecture implementation  
- Pixel-level VGA signal generation  
- PS/2 communication protocol handling  
- Hardware timing and clock management  
- Modular hardware design and integration  
- Hardware-level debugging and validation  

---

## System Architecture

- FPGA × 2  
- Keyboard × 2  
- Mouse × 2  
- VGA Display  
- PMOD Audio Module  
- Seven-Segment Display  
- On-board LEDs  

---

## Documentation

A detailed technical report is included, covering:

- System architecture design  
- FSM state transitions  
- VGA rendering logic  
- I/O integration (Keyboard, Mouse, PMOD, Display)  
- Timing analysis and design considerations  
- Engineering challenges and solutions  

Final Technical Report:  
[View Full Report (PDF)](docs/Group27_report.pdf)

---



## Skills Demonstrated

Hardware Description Languages:  
Verilog, VHDL  

Digital Design:  
FPGA Design, Finite State Machine (FSM), VGA Controller Design  

System Integration:  
PS/2 Interface Handling, Hardware Timing Control, Multi-I/O Integration  

Engineering Practice:  
Hardware Debugging, Modular Design, Real-Time Digital Systems
