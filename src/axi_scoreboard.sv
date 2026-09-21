class axi_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(axi_scoreboard)
	uvm_tlm_analysis_fifo #(axi_seq_item) write_fifo;
	uvm_tlm_analysis_fifo #(axi_seq_item) read_fifo;
	uvm_analysis_imp #(axi_seq_item, axi_scoreboard) scr_out_port;
	axi_seq_item wr_s;
	axi_seq_item rd_s;
	bit [1 : 0] exp_bresp;
	bit [1 : 0] exp_rresp;
	bit [`DATA_WIDTH - 1 : 0] exp_rdata;
	bit is_write = 0;
	bit is_read = 0;
	
	virtual axi_interface vif;
	byte mem [bit [`MEM_DEPTH*4-1:0]];

	function new(string name = "axi_scoreboard", uvm_component parent);
		super.new(name, parent);
		write_fifo = new("write_fifo", this);
		read_fifo = new("read_fifo", this);
		scr_out_port = new("scr_out_port", this); 
	endfunction

	task run_phase(uvm_phase phase);
	fork
		begin
			forever begin
				wr_s = axi_seq_item::type_id::create("wr_s");
				write_fifo.get(wr_s);
				is_write = 1;
				write_data(wr_s);
			end
		end
		begin
			forever begin
				rd_s = axi_seq_item::type_id::create("rd_s");
				read_fifo.get(rd_s);
				is_read = 1;
				read_data(rd_s);
			end
		end
	join
	endtask
		
	
	task write_data(axi_seq_item tr);
		if(tr.awaddr > 'h3C)
			exp_bresp = 2'b11;
		else if((tr.awaddr >= 'h28 && tr.awaddr <= 'h30) || (tr.awaddr % 4 != 0))
			exp_bresp = 2'b10;
      		else
		begin 
			for(int i = 0; i < `DATA_WIDTH / 8; i++)
			begin
				if(tr.wstrb[i]) 
				begin
					mem[tr.awaddr + i] = tr.wdata[i*8 +: 8];
                    		end
			end
			exp_bresp = 2'b00;
		end
	endtask
	
	task read_data(axi_seq_item tr);
      		if(tr.araddr > 'h3C) 
      		begin
        		exp_rdata = 0;
        		exp_rresp = 2'b11;
            	end
      		else if((tr.araddr >= 'h34 && tr.araddr <= 'h38) || (tr.araddr % 4 != 0)) 
      		begin
        		exp_rresp = 2'b10;
        		exp_rdata = 0;
            	end
    		else
    		begin
        		exp_rresp = 2'b00;
        		exp_rdata = 0;
              		for(int i = 0; i < `DATA_WIDTH/8; i++) 
              		begin
		      		if (mem.exists(tr.araddr + i))
                			exp_rdata[i*8 +: 8] = mem[tr.araddr + i];
            			else
                			exp_rdata[i*8 +: 8] = 8'h00;
        		end
    		end
	endtask
	
	function void write(axi_seq_item tr);
	if(is_write == 1)
	begin
		if(tr.bresp == exp_bresp)
			`uvm_info("SCOREBOARD",$sformatf("Actual BRESP = %b  Expected BRESP = %b",tr.bresp, exp_bresp), UVM_NONE)
		else
			`uvm_error("SCOREBOARD", $sformatf("INCORRECT BRESP Actual BRESP = %b  Expected BRESP = %b",tr.bresp, exp_bresp))
		is_write = 0;
	end
	else if(is_read == 1)
	begin 
		if(tr.rresp == exp_rresp)
			`uvm_info("SCOREBOARD",$sformatf("Actual RRESP = %b  Expected RRESP = %b",tr.rresp, exp_rresp), UVM_NONE)
		else
			`uvm_error("SCOREBOARD", $sformatf("INCORRECT RRESP Actual RRESP = %b  Expected RRESP = %b",tr.rresp, exp_rresp))
			
		if(tr.rdata == exp_rdata)
			`uvm_info("SCOREBOARD",$sformatf("Actual RDATA = %h  Expected RDATA = %h",tr.rdata, exp_rdata), UVM_NONE)
		else
			`uvm_error("SCOREBOARD", $sformatf("INCORRECT RDATA Actual RDATA = %h  Expected RDATA = %h",tr.rdata, exp_rdata))
		is_read = 0;
	end
	endfunction
endclass
