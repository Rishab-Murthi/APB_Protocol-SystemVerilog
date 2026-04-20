`ifndef APB_READ_TEST
`define APB_READ_TEST
import apb_env_pkg::*;
module apb_read_test(apb_interface vif);
apb_env env;
initial begin
    env = new(vif);
    env.agt.gen.count = 15;
    env.agt.gen.read = 1;
    env.run();
end
endmodule
`endif
