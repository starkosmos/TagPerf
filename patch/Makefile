.PHONY : patch

patch :
	@echo "Applying patches to RISCV-BOOM..."
	@cd ../vivado-risc-v/generators/riscv-boom/ && git apply ../../../patch/boom.patch
	@echo "Applying patches to Linux..."
	@cd ../vivado-risc-v/linux-stable/ && git apply ../../patch/linux.patch
	@echo "Applying patches to Rocket-Chip..."
	@cd ../vivado-risc-v/rocket-chip/ && git apply ../../patch/rocket.patch
	@echo "Applying patches to VHDL Wrapper..."
	@cd ../vivado-risc-v/ && git apply ../patch/vhdl.patch
	@echo "Patches applied successfully."
