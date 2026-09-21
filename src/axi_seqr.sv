class axi_seqr extends uvm_sequencer #(axi_seq_item);
	`uvm_component_utils(axi_seqr)
	function new(string name = "axi_seqr", uvm_component parent);
		super.new(name, parent);
	endfunction
endclass

class wr_seqr extends axi_seqr;
	`uvm_component_utils(wr_seqr)
	function new(string name = "wr_seqr", uvm_component parent);
		super.new(name ,parent);
	endfunction
endclass

class rd_seqr extends axi_seqr;
	`uvm_component_utils(rd_seqr)
	function new(string name = "rd_seqr", uvm_component parent);
		super.new(name ,parent);
	endfunction
endclass
