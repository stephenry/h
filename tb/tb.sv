//========================================================================== //
// Copyright (c) 2022, Stephen Henry
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

`include "cfg_pkg.vh"
`include "tb_pkg.vh"
`include "h_pkg.vh"

module tb (

// -------------------------------------------------------------------------- //
// Command Interface
  input wire logic                                i_cmd_vld_w
, input wire h_pkg::opcode_t                      i_cmd_opcode_w
, input wire h_pkg::k_t                           i_cmd_k_w
, input wire h_pkg::v_t                           i_cmd_v_w
//
, output wire logic                               o_cmd_rdy_w

// -------------------------------------------------------------------------- //
// Response Interface
, output wire logic                               o_rsp_vld
, output wire h_pkg::status_t                     o_rsp_status
, output wire h_pkg::v_t                          o_rsp_v

// -------------------------------------------------------------------------- //
// Testbench State
, output wire logic [31:0]                        o_tb_cycle

// -------------------------------------------------------------------------- //
// Clk/Reset
, input wire logic                                clk
, input wire logic                                arst_n
);

// ========================================================================== //
//                                                                            //
//  Wires                                                                     //
//                                                                            //
// ========================================================================== //

int                                     tb_cycle;

h_pkg::h_t                              hash_h_w;
h_pkg::k_t                              hash_k_r;

// ========================================================================== //
//                                                                            //
//  UUT                                                                       //
//                                                                            //
// ========================================================================== //

h u_h (
//
  .i_cmd_vld_w                         (i_cmd_vld_w)
, .i_cmd_opcode_w                      (i_cmd_opcode_w)
, .i_cmd_k_w                           (i_cmd_k_w)
, .i_cmd_v_w                           (i_cmd_v_w)
, .o_cmd_rdy_w                         (o_cmd_rdy_w)
//
, .o_rsp_vld                           (o_rsp_vld)
, .o_rsp_status                        (o_rsp_status)
, .o_rsp_v                             (o_rsp_v)
//
, .i_hash_h_w                          (hash_h_w)
, .o_hash_k_r                          (hash_k_r)
//
, .clk                                 (clk)
, .arst_n                              (arst_n)
);

// ========================================================================== //
//                                                                            //
//  Hashes                                                                    //
//                                                                            //
// ========================================================================== //

// -------------------------------------------------------------------------- //
//
case (tb_pkg::HASH_TYPE)

"PATHOLOGICAL": begin

hash_pathological #(.K(cfg_pkg::K_W), .H(cfg_pkg::H_W)) u_hash_pathological (
//
  .i_k                                 (hash_k_r)
//
, .o_h                                 (hash_h_w)
);

end // "PATHOLOGICAL"

endcase

// ========================================================================== //
//                                                                            //
//  TB                                                                        //
//                                                                            //
// ========================================================================== //

// -------------------------------------------------------------------------- //
//
initial tb_cycle = 0;

always_ff @(posedge clk)
  tb_cycle <= tb_cycle + 'b1;

// ========================================================================== //
//                                                                            //
//  Outputs                                                                   //
//                                                                            //
// ========================================================================== //

assign o_tb_cycle = tb_cycle;

endmodule : tb
