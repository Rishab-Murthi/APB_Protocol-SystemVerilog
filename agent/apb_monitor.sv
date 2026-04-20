`ifndef APB_MONITOR
`define APB_MONITOR
class apb_monitor;
  apb_transaction pkt;
  virtual apb_interface vif;
  mailbox mon2sb;
  mailbox mon2cov;
  function new(virtual apb_interface vif, mailbox mon2sb, mailbox mon2cov);
    this.vif = vif;
    this.mon2sb = mon2sb;
    this.mon2cov = mon2cov;
    //pkt = new();//*
  endfunction
  task run;
    forever begin
      @(vif.cb_monitor);
      if(vif.cb_monitor.psel)begin
        @(vif.cb_monitor);
        if(vif.cb_monitor.psel && vif.cb_monitor.penable)begin
          wait(vif.cb_monitor.pready == 1);
                    if(vif.cb_monitor.psel && vif.cb_monitor.penable && vif.cb_monitor.pready)begin
            @(vif.cb_monitor);
            pkt = new();
            pkt.paddr = vif.cb_monitor.paddr;
            pkt.pwdata = vif.cb_monitor.pwdata;
            pkt.pwrite = vif.cb_monitor.pwrite;
            pkt.prdata = vif.cb_monitor.prdata;
            mon2sb.put(pkt);
            $display("putting packet:%d",vif.pwdata);
            mon2cov.put(pkt);
            $display("from monitor: %p",pkt);
            $display($time,"monitor --> write = %d, addr = %d, wdata = %d",pkt.pwrite,pkt.paddr,pkt.pwdata);
          end
        end
        $display("out of monitor");
      end
    end
  endtask
endclass
`endif
