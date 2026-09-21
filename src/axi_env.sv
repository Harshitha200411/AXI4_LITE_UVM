class axi_env extends uvm_env;
	`uvm_component_utils(axi_env)
	axi_active_agent act_a;
	axi_passive_agent pas_a;
	axi_scoreboard scr;
	axi_subscriber sub;
	
	function new(string name = "axi_env", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      		uvm_config_db #(uvm_active_passive_enum)::set(this,"act_a","is_active", UVM_ACTIVE);
      		uvm_config_db #(uvm_active_passive_enum)::set(this,"pas_a","is_active", UVM_PASSIVE);
		act_a = axi_active_agent::type_id::create("act_a", this);
		pas_a = axi_passive_agent::type_id::create("pas_a", this);
		scr = axi_scoreboard::type_id::create("scr", this);
		sub = axi_subscriber::type_id::create("sub", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		act_a.a_m.wr_port.connect(scr.write_fifo.analysis_export);
		act_a.a_m.rd_port.connect(scr.read_fifo.analysis_export);
		pas_a.p_m.om_port.connect(scr.scr_out_port);
		act_a.a_m.wr_port.connect(sub.analysis_export);
		act_a.a_m.rd_port.connect(sub.analysis_export);
	endfunction
endclass
