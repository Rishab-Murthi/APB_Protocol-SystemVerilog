`ifndef APB_GENERATOR
`define APB_GENERATOR
class apb_generator;
  apb_transaction pkt;
  mailbox gen2driv;
  virtual apb_interface vif;
  bit read,write,err_enable;
  int count;
  function new(virtual apb_interface vif, mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction
  task run;
    $display("**********GENERATOR***********");
    repeat(count)begin
      pkt = new();
      if(write == 1)
        pkt.randomize() with {pwrite==1;};
      else if(read == 1)
        pkt.randomize() with {pwrite==0;};
      else if(err_enable == 1)begin
        pkt.randomize() with {paddr == 32'hffff_ffff;};
        $display("plsverr occured");
      end
      else
        pkt.randomize();
      gen2driv.put(pkt);
      $display($time,"generator --> write = %d, addr = %d, wdata = %d",pkt.pwrite,pkt.paddr,pkt.pwdata);
    end
  endtask
endclass
`endif
