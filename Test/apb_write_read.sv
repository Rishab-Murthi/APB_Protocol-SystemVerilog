`ifndef APB_WRITE_READ
`define APB_WRITE_READ
import apb_env_pkg::*;
module apb_write_read(apb_interface vif);
  apb_env env;
  initial begin
    env = new(vif);
    env.agt.gen.count = 14;
    env.run;
  end
endmodule
`endif
