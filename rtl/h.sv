//========================================================================== //
// Copyright (c) 2023, Stephen Henry
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//========================================================================== //

`include "common_defs.vh"

`include "h_pkg.vh"
`include "cfg_pkg.vh"

module h (

// -------------------------------------------------------------------------- //
// Command Interface
  input wire logic                                cmd_vld
, input wire h_pkg::opcode_t                      cmd_opcode
, input wire h_pkg::k_t                           cmd_k
, input wire h_pkg::v_t                           cmd_v

// -------------------------------------------------------------------------- //
// Response Interface
, output wire logic                               rsp_vld
, output wire h_pkg::status_t                     rsp_status
, output wire h_pkg::v_t                          rsp_v

// -------------------------------------------------------------------------- //
// User-Supplied Hash Function
, input wire h_pkg::h_t                           hash_h
, output wire h_pkg::k_t                          hash_k

// -------------------------------------------------------------------------- //
// Clk/Reset
, input wire logic                                clk
, input wire logic                                arst_n
);

// ========================================================================== //
//                                                                            //
//  Instances                                                                 //
//                                                                            //
// ========================================================================== //

// -------------------------------------------------------------------------- //
//
h_bdy u_h_bdy (
//
  .cmd_vld                    (cmd_vld                      )
, .cmd_opcode                 (cmd_opcode                   )
, .cmd_k                      (cmd_k                        )
, .cmd_v                      (cmd_v                        )
//
, .rsp_vld                    (rsp_vld                      )
, .rsp_status                 (rsp_status                   )
, .rsp_v                      (rsp_v                        )
//
, .clk                        (clk                          )
, .arst_n                     (arst_n                       )
);

// -------------------------------------------------------------------------- //
//
h_rams u_h_rams (
//
  .clk                        (clk                          )
);

endmodule : h
