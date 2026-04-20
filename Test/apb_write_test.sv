`ifndef APB_WRITE_TEST
`define APB_WRITE_TEST
`include "apb_interface.sv"
import apb_env_pkg::*;
module apb_write_test(apb_interface vif);
apb_env env;
initial begin
    env = new(vif);
    env.agt.gen.count = 4;
    env.agt.gen.write = 1;
    env.run;
end
endmodule
`endif
