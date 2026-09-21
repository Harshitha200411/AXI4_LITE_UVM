`include "define.svh"
interface axi_interface (input bit clk, rst);
	logic [`ADDR_WIDTH - 1 : 0] awaddr;
	logic awvalid;
	logic awready;
	logic [2 : 0] awprot;

	logic [`DATA_WIDTH - 1 : 0] wdata;
	logic [(`DATA_WIDTH / 8) - 1 : 0] wstrb;
	logic wvalid;
	logic wready;

	logic [1 : 0] bresp;
	logic bvalid;
	logic bready;

	logic [`ADDR_WIDTH - 1 : 0] araddr;
	logic arvalid;
	logic arready;
	logic [2 : 0] arprot;

	logic [`DATA_WIDTH - 1 : 0] rdata;
	logic [1 : 0] rresp;
	logic rvalid;
	logic rready;
	
	clocking drv_cb @(posedge clk);
		default input #1 output #1;
		output awaddr, awvalid, awprot;
		output wdata, wstrb, wvalid;
		output bready;
		output araddr, arvalid, arprot;
		output rready;
		input awready;
		input wready;
		input bvalid;
		input arready;
		input rvalid;
	endclocking

	clocking ip_mon_cb @(posedge clk);
		default input #1 output #1;
		input awaddr, awvalid, awprot, awready;
		input wdata, wstrb, wvalid, wready;
		input araddr, arvalid, arprot, arready;
	endclocking

	clocking out_mon_cb @(posedge clk);
		default input #1 output #1;
		input awready, awvalid;
		input wready, wvalid;
		input bresp, bvalid, bready;
		input arready, arvalid;
		input rdata, rresp, rvalid, rready;
	endclocking

	modport DRV (clocking drv_cb);
	modport IP_MON (clocking ip_mon_cb);
	modport OUT_MON ( clocking out_mon_cb);
	
	property awaddr_stable;
	@(posedge clk) disable iff (!rst)
	awvalid && !awready |=> $stable(awaddr);
	endproperty
	assert property (awaddr_stable)
	else
		$error("Assertion failed: awaddr not stable");

	property wdata_stable;
		@(posedge clk) disable iff (!rst)
		wvalid && !wready |=> $stable(wdata);
	endproperty
	assert property (wdata_stable)
	else
		$error("Assertion failed: wdata not stable");

	property wstrb_stable;
		@(posedge clk) disable iff (!rst)
		wvalid && !wready |=> $stable(wstrb);
	endproperty
	assert property (wstrb_stable)
	else
		$error("Assertion failed: wstrb not stable");
		
	property araddr_stable;
		@(posedge clk) disable iff (!rst)
		arvalid && !arready |=> $stable(araddr);
	endproperty
	assert property (araddr_stable)
	else
		$error("Assertion failed: araddr not stable");

	property rsp_after_handshake_write;
		@(posedge clk) disable iff (!rst)
		((awvalid && awready) ##[0:10] (wvalid && wready)) 
		or
		((wvalid && wready) ##[0:10] (awvalid && awready))
		|-> ##[1:10] bvalid;
	endproperty
	assert property (rsp_after_handshake_write)
	else
		$error("Assertion failed: resp was not generated after the the aw and w channel handshake");
	
	property rsp_after_handahake_read;
		@(posedge clk) disable iff (!rst)
		(arvalid && arready) |=> ##[1:10] rvalid;
	endproperty
	assert property (rsp_after_handahake_read)
	else
		$error("Assertion failed: resp was not generated after ar handshake");

	property rresp_stable;
		@(posedge clk) disable iff (!rst)
		(rvalid && !rready) |=> $stable(rresp);
	endproperty
	assert property (rresp_stable)
	else
		$error("Assertion failed: rresp is not stable");

	property rdata_stable;
		@(posedge clk) disable iff (!rst)
		(rvalid && !rready) |=> $stable(rdata);
	endproperty
	assert property (rdata_stable)
	else
		$error("Assertion failed: rdata not stable");
endinterface
