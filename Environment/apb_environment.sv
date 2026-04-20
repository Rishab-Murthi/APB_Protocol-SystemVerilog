`ifndef APB_ENVIRONMENT
`define APB_ENVIRONMENT
`include "apb_scoreboard.sv"
class apb_env;
  apb_agent agt;
  apb_scoreboard scb;
  apb_coverage cov;
  mailbox mon2sb;
  mailbox gen2driv;
  virtual apb_interface vif;
  function new(virtual apb_interface vif);
    this.vif = vif;
    gen2driv = new();
    mon2sb = new();
    agt = new(vif,gen2driv,mon2sb);
    scb = new(vif,mon2sb);
  endfunction
  task run;
    fork
      agt.run;
      scb.run;
    join
  endtask
endclass
`endif
