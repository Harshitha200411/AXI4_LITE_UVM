class axi_act_monitor extends uvm_monitor;
	`uvm_component_utils(axi_act_monitor)
	uvm_analysis_port #(axi_seq_item) wr_port;
	uvm_analysis_port #(axi_seq_item) rd_port;
	virtual axi_interface.IP_MON vif;
	axi_seq_item wr_s;
	axi_seq_item rd_s;

	function new(string name = "axi_act_mon", uvm_component parent);
		super.new(name, parent);
		wr_port = new("wr_port", this);
		rd_port = new("rd_port", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db #(virtual axi_interface.IP_MON)::get(this, "", "vif", vif))
	    		`uvm_fatal(get_type_name(), "Interface not found")
	endfunction

	virtual task run_phase(uvm_phase phase);
	bit aw_done = 0;
	bit w_done = 0;
	forever begin
		@(vif.ip_mon_cb);		
		if(vif.ip_mon_cb.awvalid && vif.ip_mon_cb.awready && !aw_done)
		begin
			if(wr_s == null)
				wr_s = axi_seq_item::type_id::create("wr_s");
			wr_s.awaddr = vif.ip_mon_cb.awaddr;
			wr_s.awprot = vif.ip_mon_cb.awprot;
			aw_done = 1;
		end	
	
	
		if(vif.ip_mon_cb.wvalid && vif.ip_mon_cb.wready && !w_done)
		begin
			if(wr_s == null)
				wr_s = axi_seq_item::type_id::create("wr_s");
			wr_s.wdata = vif.ip_mon_cb.wdata;
			wr_s.wstrb = vif.ip_mon_cb.wstrb;
			w_done = 1;
		end

	
		if(aw_done && w_done)
		begin
			wr_port.write(wr_s);
			`uvm_info("ACTIVE MONITOR", $sformatf("WRITE: awaddr=%h wdata=%h awprot=%b wstrb=%b", wr_s.awaddr, wr_s.wdata, wr_s.awprot, wr_s.wstrb), UVM_NONE)
			aw_done = 0;
			w_done = 0;
		end
				
		if(vif.ip_mon_cb.arvalid && vif.ip_mon_cb.arready)
		begin
			rd_s = axi_seq_item::type_id::create("rd_s");
			rd_s.araddr = vif.ip_mon_cb.araddr;
			rd_s.arprot = vif.ip_mon_cb.arprot;
			rd_port.write(rd_s);
			`uvm_info("ACTIVE MONITOR", $sformatf("READ: araddr=%h arprot=%b", rd_s.araddr, rd_s.arprot), UVM_NONE)
		end
		
		end
	endtask
endclass
