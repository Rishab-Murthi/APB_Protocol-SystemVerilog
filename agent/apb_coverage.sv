`ifndef APB_COVERAGE
`define APB_COVERAGE
class apb_coverage;
  mailbox mon2cov;
  apb_transaction pkt;
  virtual apb_interface vif;
  function new(virtual apb_interface vif, mailbox mon2cov);
    this.mon2cov = mon2cov;
    this.vif = vif;
    pkt = new();
    cg_apb = new();
  endfunction
  covergroup cg_apb;
    psel_cov:coverpoint vif.psel{bins psel0 = {0}; bins psel1 = {1};}
    paddr_cov:coverpoint vif.paddr{bins lowrange_addr = {[0:50]};
                                   bins midrange_addr = {[51:150]};
                                   bins highrange_addr = {[151:255]};}
    pwrite_cov:coverpoint vif.pwrite{bins pwrite0 = {0}; bins pwrite1 = {1};}
    pwdata_cov:coverpoint vif.pwdata{bins lowrange_pwdata = {[1:10]};
                                     bins midrange_pwdata = {[11:20]};
                                     bins highrange_pwdata = {[21:30]};}
    prdata_cov:coverpoint vif.prdata{bins lowrange_prdata = {[1:10]};
                                     bins midrange_prdata = {[11:20]};
                                     bins highrange_prdata = {[21:30]};}
  endgroup
  task run;
    forever begin
      mon2cov.get(pkt);
      cg_apb.sample();
    end
  endtask
endclass
`endif
