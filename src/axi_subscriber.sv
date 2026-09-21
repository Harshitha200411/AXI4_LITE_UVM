class axi_subscriber extends uvm_subscriber #(axi_seq_item);
	`uvm_component_utils(axi_subscriber)
	axi_seq_item s;
	
	covergroup cg;
		awaddr_cp : coverpoint s.awaddr {
			bins normal = {['h0 : 'h24], 'h3C};
			bins read_only = {['h24 : 'h30]};
			bins write_only = {['h34 : 'h38]};
		}
		wdata_cp : coverpoint s.wdata {
			bins low_mem_0 = {['h0 : 'h3FFFFFFF]};
			bins low_mem_1 = {['h40000000 : 'h7FFFFFFF]};
			bins high_mem_0 = {['h80000000 : 'hBFFFFFFF]};
			bins high_mem_1 = {['hC0000000 : 'hFFFFFFFF]};
		}
		wstrb_cp : coverpoint s.wstrb {
			bins bit_1 = {1, 2, 4, 8};
			bins bit_2 = {3, 5, 6, 9, 10, 12};
			bins bit_3 = {7, 11, 13, 14};
			bins other = {0, 15};
		}
		araddr_cp : coverpoint s.araddr {
			bins normal = {['h0 : 'h24], 'h3C};
			bins read_only = {['h24 : 'h30]};
			bins write_only = {['h34 : 'h38]};
		}
	endgroup
	
	function new(string name = "axi_subscriber", uvm_component parent);
		super.new(name, parent);
		cg = new();
	endfunction
	
	function void write(axi_seq_item t);
		s = t;
		cg.sample();
	endfunction
endclass
	
