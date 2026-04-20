`ifndef APB_PSLVERR
`define APB_PSLVERR
import apb_env_pkg::*;
module apb_pslverr(apb_interface vif);
  apb_env env;
  initial begin
    env = new(vif);
    env.agt.gen.count = 4;
    env.agt.gen.err_enable = 1;
    env.run;
  end
endmodule
`endif
