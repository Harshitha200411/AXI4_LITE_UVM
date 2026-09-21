class axi_active_agent extends uvm_agent;
	`uvm_component_utils(axi_active_agent)
	axi_act_monitor a_m;
	axi_driver a_d;
	wr_seqr w_sq;
	rd_seqr r_sq;
	
	function new(string name = "axi_active_agent", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (get_is_active() == UVM_ACTIVE)
		begin	
			w_sq = wr_seqr::type_id::create("w_s", this);
			r_sq = rd_seqr::type_id::create("r_s", this);
			a_d = axi_driver::type_id::create("a_d", this);
		end
		a_m = axi_act_monitor::type_id::create("a_m", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		a_d.seq_item_port.connect(w_sq.seq_item_export);
		a_d.read_port.connect(r_sq.seq_item_export);
	endfunction
endclass	
