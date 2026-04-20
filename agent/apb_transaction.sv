`ifndef APB_TRANSACTION
`define APB_TRANSACTION
class apb_transaction;
  bit        psel;
  bit        penable;
  bit        pready;
  randc bit [31:0] paddr;
  rand bit         pwrite;
  rand bit  [15:0] pwdata;
  bit       [7:0]  pstrb;
  bit       [15:0] prdata;
  bit              pslverr;
  bit              pwakeup;

  constraint c_paddr{soft paddr inside{[1:255]};}
  constraint d_paddr{!{paddr inside{0,4,8,12}};}
  constraint c_pwdata{pwdata inside{[1:30]};}
  constraint c_pwd{unique{pwdata};}
endclass :apb_transaction
`endif
