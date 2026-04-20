`ifndef APB_DRIVER
`define APB_DRIVER
class apb_driver;
  apb_transaction pkt;
  mailbox gen2driv;
  mailbox temp;
  virtual apb_interface vif;
  function new(virtual apb_interface vif, mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
    temp = new();
  endfunction
  task run;
    forever begin
      @(posedge vif.pclk);
      if($isunknown(vif.presetn))begin
        x_reset_check;
        $display("%t DRIVER: x detected in reset");
      end
      else if(!vif.presetn)
        reset_check_logic;
      else begin
        if(temp.num()>0)begin
          temp.get(pkt);
          $display("%t DRIVER: processing packet from mailbox", $time);
          driver_logic(pkt);
        end
        else if(gen2driv.try_get(pkt))begin
          $display("%t DRIVER: got packet from gen2driv", $time);
          driver_logic(pkt);
        end
      end
    end
      endtask
  task reset_logic();
    vif.cb_driver.psel <= 1'b0;
    vif.cb_driver.penable <= 1'b0;
    vif.cb_driver.paddr <= 1'b0;
    vif.cb_driver.pwrite <= 1'b0;
    vif.cb_driver.pwdata <= 1'b0;
    $display("%t DRIVER: reset logic executed", $time);
  endtask
  task reset_check_logic;
    if(!vif.presetn)begin
      reset_logic();
      if(pkt != null)begin
        temp.put(pkt);
        pkt = null;
      end
      wait(vif.presetn == 1);
    end
  endtask
  task x_reset_check;
    if($isunknown(vif.presetn))begin
      wait(!vif.presetn);
      reset_check_logic;
    end
  endtask
  task driver_logic(apb_transaction pkt);
    $display("***********DRIVER*************");
    @(vif.cb_driver);
    vif.cb_driver.psel <= 1'b1;
    vif.cb_driver.penable <= 1'b0;
    vif.cb_driver.paddr <= pkt.paddr;
    vif.cb_driver.pwrite <= pkt.pwrite;
    vif.cb_driver.pwdata <= pkt.pwdata;
        if($isunknown(vif.presetn) || (!vif.presetn))begin
      x_reset_check;
      reset_check_logic;
      disable driver_logic;
    end
    @(vif.cb_driver);
    vif.cb_driver.psel <= 1'b1;
    vif.cb_driver.penable <= 1'b1;
    wait(vif.cb_driver.pready == 1 || $isunknown(vif.presetn));
    if($isunknown(vif.presetn) || (!vif.presetn))begin
      x_reset_check;
      reset_check_logic;
      disable driver_logic;
    end
    @(vif.cb_driver);
    vif.cb_driver.psel <= 1'b0;
    vif.cb_driver.penable <= 1'b0;
    $display($time,"driver --> write = %d, addr = %d, wdata = %d",pkt.pwrite,pkt.paddr,pkt.pwdata);
    if($isunknown(vif.presetn) || (!vif.presetn))begin
      x_reset_check;
      reset_check_logic;
      disable driver_logic;
    end
  endtask
endclass : apb_driver
`endif
