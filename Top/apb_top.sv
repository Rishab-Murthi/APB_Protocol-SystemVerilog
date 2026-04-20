`ifndef APB_TOP
`define APB_TOP
`include "apb_interface.sv"
module apb_top();
import apb_env_pkg::*;
logic pclk;
logic presetn;
apb_interface intf(pclk,presetn);
//instantiation of design
apb_slave slave_inst(intf);
//instantiation of test
apb_write_test w_test(intf);
apb_read_test r_test(intf);
apb_pslverr slverr(intf);
apb_write_read wr_test(intf);
always #5 pclk = ~pclk;
initial begin
    pclk = 0;
    presetn = 1;
    #20 presetn = 0;
    #20 presetn = 1;
    //#100 presetn = 0;
    //#60 presetn = 1'bx;
    //#20 presetn = 0;
    //#60 presetn = 1;
    #1000 $finish;
end
endmodule
`endif
