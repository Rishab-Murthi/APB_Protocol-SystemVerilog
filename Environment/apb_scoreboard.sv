`ifndef APB_SCOREBOARD
`define APB_SCOREBOARD
class apb_scoreboard;
  bit [31:0] mem [0:255];
  mailbox mon2sb;
  apb_transaction pkt;
  virtual apb_interface vif;
  function new(virtual apb_interface vif, mailbox mon2sb);
    this.mon2sb = mon2sb;
    this.vif=vif;
    pkt = new();
  endfunction
  task run;
    forever begin
      @(negedge vif.pclk);
      mon2sb.get(pkt);
      if(!vif.presetn)begin
        for(int i=0; i<256; i++)begin
          mem[i] = i;
        end
      end
      else begin
        $display("entering sc forever");
        $display("packet=%p",pkt);
        if(pkt.pwrite == 1)begin
          mem[pkt.paddr] = pkt.pwdata;
        end
        else begin
          if(pkt.prdata == mem[pkt.paddr])begin
            $display("----------------pass----------------");
            $display("pkt recieved:%d %d",pkt.prdata,mem[pkt.paddr]);
          end
          else begin
            $display("----------------fail-------%d %d-----",pkt.prdata,mem[pkt.paddr]);
          end
          $display("exitting scb");
        end
      end
    end
  endtask
endclass
`endif
