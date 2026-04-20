`ifndef APB_AGENT
`define APB_AGENT
class apb_agent;
  apb_generator gen;
  apb_driver driv;
  apb_monitor mon;
  apb_coverage cov;
  mailbox gen2driv;
  mailbox mon2sb;
  mailbox mon2cov;
  virtual apb_interface vif;
  function new(virtual apb_interface vif, mailbox gen2driv, mailbox mon2sb);
    this.vif = vif;
    gen2driv = new();
    mon2cov = new();
    this.mon2sb = mon2sb;
    gen = new(vif, gen2driv);
    driv = new(vif, gen2driv);
    mon = new(vif, mon2sb, mon2cov);
    cov = new(vif, mon2cov);
  endfunction
  task run;
    fork
      gen.run;
      driv.run;
      mon.run;
      cov.run;
    join
  endtask
endclass
`endif
