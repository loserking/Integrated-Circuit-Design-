**********************************************
* Main Circuit Netlist:
**********************************************
.subckt ND3 Z A B C
MN0 Z C n01 gnd n w=0.45u l=0.18u
MN2 n12 A gnd gnd n w=0.45u l=0.18u
MN1 n01 B n12 gnd n w=0.45u l=0.18u
MP0 Z A vdd vdd p w=0.9u l=0.18u
MP1 Z B vdd vdd p w=0.9u l=0.18u
MP2 Z C vdd vdd p w=0.9u l=0.18u
.ends ND3
