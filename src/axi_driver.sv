class axi_driver extends uvm_driver #(axi_seq_item);
	`uvm_component_utils(axi_driver)
	virtual axi_interface.DRV vif;
	uvm_seq_item_pull_port #(axi_seq_item) read_port;
	
	function new(string name = "axi_driver", uvm_component parent);
		super.new(name, parent);
		read_port = new("read_port", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      		if (!uvm_config_db #(virtual axi_interface.DRV)::get(this, "", "vif", vif))
			`uvm_fatal (get_type_name(), "Interface not found")
	endfunction
	
	virtual task run_phase(uvm_phase phase);
	fork
		begin
			forever begin
				axi_seq_item wr_seq;
				wr_seq = axi_seq_item::type_id::create("wr_seq");
				seq_item_port.get_next_item(wr_seq);
				`uvm_info("DRV", $sformatf("WRITE : awaddr = %h awprot = %b wdata = %h wstrb = %b", wr_seq.awaddr, wr_seq.awprot, wr_seq.wdata, wr_seq.wstrb), UVM_NONE)
				drive_write(wr_seq);
				seq_item_port.item_done();
			end
		end
		begin
			forever begin
				axi_seq_item rd_seq;
				rd_seq = axi_seq_item::type_id::create("rd_seq");
				read_port.get_next_item(rd_seq);
				`uvm_info("DRV", $sformatf("READ : araddr = %h arprot = %b", rd_seq.araddr, rd_seq.arprot), UVM_NONE)
				drive_read(rd_seq);
				read_port.item_done();
			end
		end

	join
	endtask
	
	task drive_write(axi_seq_item t);
		fork	
			begin
			if(t.awvalid)
				aw_channel(t);
			end
			begin
			if(t.wvalid)
				w_channel(t);
			end
		join
		if(t.bready)
			b_channel(t);
	endtask
	
	task drive_read(axi_seq_item t);
		ar_channel(t);
		r_channel(t);
	endtask
	
	task aw_channel(axi_seq_item t);
		@(vif.drv_cb);
		vif.drv_cb.awaddr <= t.awaddr;
		vif.drv_cb.awprot <= t.awprot;
		vif.drv_cb.awvalid <= t.awvalid;
		do begin
			@(vif.drv_cb);
		end
		while(!(vif.drv_cb.awready));
		vif.drv_cb.awvalid <= 1'b0;
	endtask
	
	task w_channel(axi_seq_item t);
		@(vif.drv_cb);
		vif.drv_cb.wdata <= t.wdata;
		vif.drv_cb.wstrb <= t.wstrb;
		vif.drv_cb.wvalid <= t.wvalid;
		do begin
			@(vif.drv_cb);
		end
		while(!(vif.drv_cb.wready));
		vif.drv_cb.wvalid <= 1'b0;
	endtask

	
	task b_channel(axi_seq_item t);
		@(vif.drv_cb);
		vif.drv_cb.bready <= t.bready;
		do begin
			@(vif.drv_cb);
		end
		while(!(vif.drv_cb.bvalid));
		vif.drv_cb.bready <= 1'b0;
	endtask

	task ar_channel(axi_seq_item t);
		if(t.arvalid)
		begin
			@(vif.drv_cb);
			vif.drv_cb.araddr <= t.araddr;
	      		vif.drv_cb.arprot <= t.arprot;
			vif.drv_cb.arvalid <= t.arvalid;
			do begin
		    		@(vif.drv_cb);
			end
			while(!(vif.drv_cb.arready));
			vif.drv_cb.arvalid <= 1'b0;
		end
	endtask

	task r_channel(axi_seq_item t);
		if(t.rready)
		begin
			@(vif.drv_cb);
			vif.drv_cb.rready <= t.rready;
			do begin
		    		@(vif.drv_cb);
			end
			while(!(vif.drv_cb.rvalid));
			vif.drv_cb.rready <= 1'b0;
		end
	endtask
	
endclass	
