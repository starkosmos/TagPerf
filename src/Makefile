.PHONY : clean

TPM_SV        = tpm.sv
PARAM_CPUFREQ = 50000000

define TPM_TCL
	# Package Tagged-based Performance Monitor
	ipx::infer_core .tpm
	ipx::current_core .tpm/component.xml
	set_property vendor mprc.pku.edu.cn [ipx::current_core]
	set_property library MPRC [ipx::current_core]
	set_property name TPM [ipx::current_core]
	set_property version 0.1 [ipx::current_core]
	set_property display_name TPMv0 [ipx::current_core]
	set_property description {Tagged-based Performance Monitor} [ipx::current_core]
	set_property vendor_display_name MPRC [ipx::current_core]
	set_property company_url https://mprc.pku.edu.cn [ipx::current_core]
	ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces rst -of_objects [ipx::current_core]]
	ipx::add_bus_parameter FREQ_HZ  [ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]
	set_property value ACTIVE_HIGH [ipx::get_bus_parameters POLARITY -of_objects [ \\
		ipx::get_bus_interfaces rst -of_objects [ipx::current_core]]]
	set_property value $(PARAM_CPUFREQ) [ipx::get_bus_parameters FREQ_HZ -of_objects [ \\
		ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]]
	set_property core_revision 2 [ipx::current_core]
	ipx::update_source_project_archive -component [ipx::current_core]
	ipx::create_xgui_files [ipx::current_core]
	ipx::update_checksums [ipx::current_core]
	ipx::check_integrity [ipx::current_core]
	ipx::save_core [ipx::current_core]
endef
export TPM_TCL

.tpm/ : $(TPM_SV)
	$(RM) -r .tpm/ && mkdir .tpm
	ln -s $(realpath $(TPM_SV)) .tpm/
	echo "$$TPM_TCL" > .tpm/tpm.tcl
	vivado -mode batch -source .tpm/tpm.tcl >/dev/null 2>&1

clean:
	$(RM) -r .*[A-z]*/ *.log *.jou
