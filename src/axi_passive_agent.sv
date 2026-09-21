class axi_passive_agent extends uvm_agent;
	`uvm_component_utils (axi_passive_agent)
	axi_pas_monitor p_m;
	
	function new(string name = "axi_passive_agent", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active() == UVM_PASSIVE)
			p_m = axi_pas_monitor::type_id::create("p_m", this);
	endfunction
endclass
