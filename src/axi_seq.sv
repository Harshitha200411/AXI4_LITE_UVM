class write_transaction_addr_first extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(write_transaction_addr_first)
	axi_seq_item req;
	function new(string name = "write_transaction_addr_first");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.awaddr[1:0] == 2'b00; req.awaddr < 'h3C; req.awvalid == 1; req.wvalid == 0; req.bready == 0; req.arvalid == 0; req.rready == 0;})
		`uvm_do_with(req, {req.awvalid == 0; req.wvalid == 1; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass

class write_transaction_data_first extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(write_transaction_data_first)
	axi_seq_item req;
	function new(string name = "write_transaction_data_first");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.awvalid == 0; req.wvalid == 1; req.bready == 0; req.arvalid == 0; req.rready == 0; req.wstrb == 4'b1111;})
		`uvm_do_with(req, {req.awaddr[1:0] == 2'b00; req.awaddr < 'h3C; req.awvalid == 1; req.wvalid == 0; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass


class read_transaction extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(read_transaction)
	axi_seq_item req;
	function new(string name = "read_transaction");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.araddr[1:0] == 2'b00; req.araddr < 'h3C; req.awvalid == 0; req.wvalid == 0; req.bready == 0; req.arvalid == 1; req.rready == 1;})
	end
	endtask
endclass

class decerr_write_check extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(decerr_write_check)
	axi_seq_item req;
	function new(string name = "decerr_write_check");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.awaddr > 'h3C; req.awvalid == 1; req.wvalid == 0; req.bready == 0; req.arvalid == 0; req.rready == 0;})
		`uvm_do_with(req, {req.awvalid == 0; req.wvalid == 1; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass

class decerr_read_check extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(decerr_read_check)
	axi_seq_item req;
	function new(string name = "decerr_read_check");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.araddr[1:0] == 2'b00; req.araddr > 'h3C; req.awvalid == 0; req.wvalid == 0; req.bready == 0; req.arvalid == 1; req.rready == 1;})
	end
	endtask
endclass

class slverr_unaligned_addr_write extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(slverr_unaligned_addr_write)
	axi_seq_item req;
	function new(string name = "slverr_unaligned_addr_write");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.awaddr[1:0] != 2'b00; req.awaddr < 'h3C;req.awvalid == 1; req.wvalid == 0; req.bready == 0; req.arvalid == 0; req.rready == 0;})
		`uvm_do_with(req, {req.awvalid == 0; req.wvalid == 1; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass


class slverr_unaligned_addr_read extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(slverr_unaligned_addr_read)
	axi_seq_item req;
	function new(string name = "slverr_unaligned_addr_read");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.araddr[1:0] != 2'b00; req.araddr < 'h3C; req.awvalid == 0; req.wvalid == 0; req.bready == 0; req.arvalid == 1; req.rready == 1;})
	end
	endtask
endclass


class write_in_ro extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(write_in_ro)
	axi_seq_item req;
	function new(string name = "write_in_ro");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.awaddr >= 'h28 && req.awaddr <= 'h30; req.awvalid == 1; req.wvalid == 0; req.bready == 0; req.arvalid == 0; req.rready == 0;})
		`uvm_do_with(req, {req.awvalid == 0; req.wvalid == 1; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass


class read_in_wo extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(read_in_wo)
	axi_seq_item req;
	function new(string name = "read_in_wo");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.araddr >= 'h34 && req.araddr <= 'h38; req.awvalid == 0; req.wvalid == 0; req.bready == 0; req.arvalid == 1; req.rready == 1;})
	end
	endtask
endclass

class write_tog extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(write_tog)
	axi_seq_item req;
	function new(string name = "write_tog");
		super.new(name);
	endfunction
	task body();
	repeat(1) begin
		`uvm_do_with(req, {req.awaddr < 'h3C; req.awvalid == 1; req.wvalid == 1; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass

class write_1 extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(write_1)
	axi_seq_item req;
	function new(string name = "write_1");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.awaddr inside {'h6, 'h4, 'h40, 'h8, 'h0}; req.awvalid == 1; req.wvalid == 0; req.bready == 0; req.arvalid == 0; req.rready == 0;})
		`uvm_do_with(req, {req.wstrb == 4'b1111; req.awvalid == 0; req.wvalid == 1; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass

class write_2 extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(write_2)
	axi_seq_item req;
	function new(string name = "write_2");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.wstrb == 4'b1111; req.awvalid == 0; req.wvalid == 1; req.bready == 0; req.arvalid == 0; req.rready == 0;})
		`uvm_do_with(req, {req.awaddr inside {'h6, 'h4, 'h40, 'h8, 'h0}; req.awvalid == 1; req.wvalid == 0; req.bready == 1; req.arvalid == 0; req.rready == 0;})
	end
	endtask
endclass

class read extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(read)
	axi_seq_item req;
	function new(string name = "read");
		super.new(name);
	endfunction
	task body();
	repeat(10) begin
		`uvm_do_with(req, {req.araddr inside {'h6, 'h4, 'h40, 'h8, 'h0}; req.awvalid == 0; req.wvalid == 0; req.bready == 0; req.arvalid == 1; req.rready == 1;})
	end
	endtask
endclass

