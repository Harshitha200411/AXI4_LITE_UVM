class axi_test extends uvm_test;
	`uvm_component_utils(axi_test)
	axi_env env;
	function new (string name = "axi_test", uvm_component parent);
		super.new(name, parent);
	endfunction
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = axi_env::type_id::create("env", this);
	endfunction
	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
endclass

class test1 extends axi_test;
	`uvm_component_utils(test1)
	write_transaction_addr_first s;
	function new(string name = "test1", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = write_transaction_addr_first::type_id::create("s");
		s.start(env.act_a.w_sq);
		`uvm_info("TEST","Write address first test done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass  

class test2 extends axi_test;
	`uvm_component_utils(test2)
	write_transaction_data_first s;
	function new(string name = "test2", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = write_transaction_data_first::type_id::create("s");
		s.start(env.act_a.w_sq);
		`uvm_info("TEST","Write data first test done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test3 extends axi_test;
	`uvm_component_utils(test3)
	read_transaction s;
	function new(string name = "test3", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = read_transaction::type_id::create("s");
		s.start(env.act_a.r_sq);
		`uvm_info("TEST","Read test done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test4 extends axi_test;
	`uvm_component_utils(test4)
	decerr_write_check s;
	function new(string name = "test4", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = decerr_write_check::type_id::create("s");
		s.start(env.act_a.w_sq);
		`uvm_info("TEST","DECERR write done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test5 extends axi_test;
	`uvm_component_utils(test5)
	decerr_read_check s;
	function new(string name = "test5", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = decerr_read_check::type_id::create("s");
		s.start(env.act_a.r_sq);
		`uvm_info("TEST","DECERR read done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test6 extends axi_test;
	`uvm_component_utils(test6)
	slverr_unaligned_addr_write s;
	function new(string name = "test6", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = slverr_unaligned_addr_write::type_id::create("s");
		s.start(env.act_a.w_sq);
		`uvm_info("TEST","Unaligned write done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test7 extends axi_test;
	`uvm_component_utils(test7)
	slverr_unaligned_addr_read s;
	function new(string name = "test7", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = slverr_unaligned_addr_read::type_id::create("s");
		s.start(env.act_a.r_sq);
		`uvm_info("TEST","Unaligned read done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass


class test8 extends axi_test;
	`uvm_component_utils(test8)
	write_in_ro s;
	function new(string name = "test8", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = write_in_ro::type_id::create("s");
		s.start(env.act_a.w_sq);
		`uvm_info("TEST","Write in ro region test done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test9 extends axi_test;
	`uvm_component_utils(test9)
	read_in_wo s;
	function new(string name = "test9", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = read_in_wo::type_id::create("s");
		s.start(env.act_a.r_sq);
		`uvm_info("TEST","Read in wo region test done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test10 extends axi_test;
	`uvm_component_utils(test10)
	write_tog s;
	function new(string name = "test10", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s = write_tog::type_id::create("s");
		s.start(env.act_a.w_sq);
		`uvm_info("TEST","Write address and data together test done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test11 extends axi_test;
	`uvm_component_utils(test11)
	write_1 s1;
	read s2;
	function new(string name = "test11", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s1 = write_1::type_id::create("s1");
		s1.start(env.act_a.w_sq);
		s2 = read::type_id::create("s2");
		s2.start(env.act_a.r_sq);
		`uvm_info("TEST","Write followed by read with address sent first done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

class test12 extends axi_test;
	`uvm_component_utils(test12)
	write_2 s1;
	read s2;
	function new(string name = "test12", uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		s1 = write_2::type_id::create("s1");
		s1.start(env.act_a.w_sq);
		s2 = read::type_id::create("s2");
		s2.start(env.act_a.r_sq);
		`uvm_info("TEST","Wrrite followed by read with data sent first done",UVM_NONE)
		phase.drop_objection(this);
	endtask
endclass

