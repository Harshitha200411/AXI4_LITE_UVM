`include "axi_interface.sv"
`include "axi_design.sv"
`include "axi_pkg.sv"

module top;
	import uvm_pkg::*;
	import axi_pkg::*;
	bit clk;
	bit rst;
	axi_interface vif(clk, rst);
	
  	axi4_lite_slave #(.DATA_WIDTH(`DATA_WIDTH), .ADDR_WIDTH(`ADDR_WIDTH), .MEM_DEPTH(`MEM_DEPTH), .DEFAULT_PROT(`DEFAULT_PROT)) dut (.ACLK(vif.clk), .ARESETn(vif.rst), .AWADDR(vif.awaddr), .AWPROT(vif.awprot), .AWVALID(vif.awvalid), .AWREADY(vif.awready), .WDATA(vif.wdata), .WSTRB(vif.wstrb), .WVALID(vif.wvalid), .WREADY(vif.wready), .BRESP(vif.bresp), .BVALID(vif.bvalid), .BREADY(vif.bready), .ARADDR(vif.araddr), .ARVALID(vif.arvalid), .ARPROT(vif.arprot), .ARREADY(vif.arready), .RDATA(vif.rdata), .RVALID(vif.rvalid), .RREADY(vif.rready), .RRESP(vif.rresp));
	
	initial begin
      		uvm_config_db #(virtual axi_interface.DRV)::set(null, "uvm_test_top.env.act_a.a_d", "vif", vif);
      		uvm_config_db #(virtual axi_interface.IP_MON)::set(null, "uvm_test_top.env.act_a.a_m", "vif", vif);
      		uvm_config_db #(virtual axi_interface.OUT_MON)::set(null, "uvm_test_top.env.pas_a.p_m", "vif", vif);
      		uvm_config_db #(virtual axi_interface)::set(null, "*", "vif", vif);
		run_test();
	end
	
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	initial begin
		rst = 1'b1;
		#10;
		rst = 1'b0;
		#10;
		rst = 1'b1;
		#10;
		rst = 1'b0;
		#10;
		rst = 1'b1;
	end
  
endmodule

