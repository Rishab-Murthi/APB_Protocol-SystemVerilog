`ifndef APB_INTERFACE
`define APB_INTERFACE
interface apb_interface #(parameter N = 16, parameter ADDR_WIDTH = 32)(input logic pclk, input logic presetn);
  //control signals
  logic        psel;
  logic        penable;
  logic        pready;
  //side-band signals
  logic [ADDR_WIDTH-1:0] paddr;
  logic        pwrite;
  logic [N-1:0] pwdata;
  //logic [7:0]   pstrb;
  logic [N-1:0] prdata;
  logic        pslverr;
  //logic        pwakeup;
  //user signals
  /*logic        pauser;
  logic [N-1:0] pwuser;
  logic [N-1:0] pbuser;
  logic        pruser;*/

  clocking cb_driver @(posedge pclk);
    input pready,prdata,pslverr;
    output paddr,psel,penable,pwrite,pwdata;
  endclocking
  clocking cb_monitor @(negedge pclk);
    input pready,prdata,pslverr;
    input paddr,psel,penable,pwrite,pwdata;
  endclocking
    modport mp_design(input paddr,psel,penable,pwrite,pwdata,
                    output pready,prdata,pslverr);
  modport mp_test(clocking cb_driver);

  property p1;
    @(posedge pclk)
    disable iff(!presetn)
    $rose(psel) |=> penable;
  endproperty
  setup:assert property (p1);

  property p2;
    @(posedge pclk)
    disable iff(!presetn)
    psel && penable && pready |=> !psel && !penable;
  endproperty
  access:assert property (p2);

  property p3;
    @(posedge pclk)
    disable iff(!presetn)
    psel && penable && !pready |-> $stable(psel) && $stable(penable);
  endproperty
  idle:assert property (p3);
endinterface
`endif
