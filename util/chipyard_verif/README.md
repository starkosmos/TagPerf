# Verification for Chipyard Simulation Environment

To verify the function of IBP, this directory is intended to
use a simple interpretor which read from intermediate code in
text files. The interpretor contains function pointers which
can provide workload for indirect jumps.

To compile the interpretor, RISC-V toolchain is required, and
use for example
```
riscv64-unknown-elf-gcc interpret.c -o interpret.notrace
```
to compile it. Add `-DTRACE` if additional trace is required.
Then use the file and a file containing intermediate code as
arguments of Proxy Kernel in Verilator simulation. For example
```
make -j16 run-binary \
    CONFIG=MediumBoomV3Config LOADMEM=1 TIMEOUT_CYCLES=-1 \
    BINARY=./benchmarks/pk \
    BINARY_ARGS="./user/interpret.notrace ./user/interpret.txt"
```

Besides, some Chisel code to print extra logs is requied in IBP
class, patch Rochet Chip and BOOM in Chipyard v1.13.0 using
`chipyard.patch` and it will add IBP to Chipyard and generate
extra logs in `*.out` file.

The `*.out` file contains information of commit information and
IBP predictions, redirect it as standard input to program
`verif` and its correctness will be determined. To align with
cosimulator, besides parameters, function `hashTag2Idx` should
be modified to lower bits of tag, and folded path history
should be modified with no shift operation. Also, lvcP should
be invalidated.
