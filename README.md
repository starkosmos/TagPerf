# Tag-based Performance Monitor

This repository includes a tag-based performance monitor and
a demo with repository `vivado-risc-v`. The demo is based on
a medium BOOM processor and board Genesys 2.

## Usage

To apply the performance monitor on BOOM processor, first
update submodules and prepare working environment.
```
git submodule update --init
cd vivado-risc-v
make apt-install
make update-submodules
```
To get internal signals from core and PIDs from Linux kernel,
several patches are required.
```
make -C patch
```
Debian system and Medium BOOM project can be built according to
`vivado-risc-v` repository by
```
cd vivado-risc-v
./mk-sd-image
make -j CONFIG=rocket64x1 BOARD=genesys2 vivado-project
```
Afterwards, create IP for the performance monitor.
```
make -C src
```
To build bitstream with performance monitor, we need to open
the project generated, and in Vivado, open "IP Catalog", right
click and add the IP directory `src/.tpm`. Open board design
and add the IP "TPM". Add another IP "JTAG to AXI Master" to
communicate with TPM by host machine via JTAG port. TPM uses
AXILite protocol so that an "AXI Protocol Converter" IP is also
required. Connect the clock port, reset port, tag port, event
port and AXI interfaces, assign AXI address and then save block
design. Then the modification is finished. Bitstream can be
generated after this.

After bitstream and Debian image are obtained, the PM can be
tested on Genesys 2 with SD card written. TCL script
`src/tpm.tcl` provides some functions to simplify AXI
transaction process through JTAG port.
