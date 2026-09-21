class axi_pas_monitor extends uvm_monitor;
	`uvm_component_utils(axi_pas_monitor)
	uvm_analysis_port #(axi_seq_item) om_port;
	virtual axi_interface.OUT_MON vif;
	axi_seq_item im_s;

	function new(string name = "axi_pas_mon", uvm_component parent);
		super.new(name, parent);
		om_port = new("om_port", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db #(virtual axi_interface.OUT_MON)::get(this, "", "vif", vif))
	    		`uvm_fatal(get_type_name(), "Interface not found")
	endfunction
	
	virtual task run_phase(uvm_phase phase);
	forever begin
		@(vif.out_mon_cb);
		im_s = axi_seq_item::type_id::create("im_s");
		if(vif.out_mon_cb.bvalid && vif.out_mon_cb.bready)
		begin
			im_s.bresp = vif.out_mon_cb.bresp;
			om_port.write(im_s);
			`uvm_info("PASSIVE MONITOR", $sformatf("WRITE : BRESP = %b", im_s.bresp), UVM_NONE)
		end	
		if(vif.out_mon_cb.rvalid && vif.out_mon_cb.rready)
		begin
			im_s.rresp = vif.out_mon_cb.rresp;
			im_s.rdata = vif.out_mon_cb.rdata;
			om_port.write(im_s);
			`uvm_info("PASSIVE MONITOR", $sformatf("READ : RRESP = %b RDATA = %h", im_s.rresp, im_s.rdata), UVM_NONE)
		end
		end
	endtask
endclass
