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

module h_bdy_fe (
// -------------------------------------------------------------------------- //
// Command Interface
  input wire logic                                i_cmd_vld_w
, input wire h_pkg::opcode_t                      i_cmd_opcode_w
, input wire h_pkg::k_t                           i_cmd_k_w
, input wire h_pkg::v_t                           i_cmd_v_w
//
, output wire logic                               o_cmd_rdy_w

// -------------------------------------------------------------------------- //
// User-Supplied Hash Function
, input wire h_pkg::h_t                           i_hash_h_w
, output wire h_pkg::k_t                          o_hash_k_r

// -------------------------------------------------------------------------- //
// Clk/Reset
, input wire logic                                clk
, input wire logic                                arst_n
);

// S0 -> S1:
//
`H_DFF(logic, s1_vld, clk);
`H_DFFE(h_pkg::opcode_t, s1_opcode, i_cmd_vld_w, clk);
`H_DFFE(h_pkg::k_t, s1_k, i_cmd_vld_w, clk);
`H_DFFE(h_pkg::v_t, s1_v, i_cmd_vld_w, clk);

// S1 -> S2:
//
`H_DFF(logic, s2_vld, clk);
`H_DFF(logic, s2_dec_has_k, clk);
`H_DFF(logic, s2_dec_has_v, clk);
`H_DFF(logic, s2_dec_has_hash, clk);
`H_DFFE(h_pkg::opcode_t, s2_opcode, s1_vld_r, clk);
`H_DFFE(h_pkg::k_t, s2_k, s1_vld_r, clk);
`H_DFFE(h_pkg::v_t, s2_v, s1_vld_r, clk);
`H_DFFE(h_pkg::h_t, s2_h, s1_vld_r, clk);

// S2:
//
logic                           queue_push_opcode;
logic                           queue_push_k;
logic                           queue_push_v;
logic                           queue_push_h;

// ========================================================================== //
//                                                                            //
// [S0] Command Decoder                                                       //
//                                                                            //
// ========================================================================== //

assign s1_vld_w = i_cmd_vld_w;

// ========================================================================== //
//                                                                            //
// [S1] Hasher                                                                //
//                                                                            //
// ========================================================================== //

assign o_hash_k_r = s1_k_r;

// -------------------------------------------------------------------------- //
//
h_bdy_fe_dec u_h_bdy_fe_dec (
  //
  .i_opcode                   (s1_opcode_r             )
  //
, .o_has_k                    (s2_dec_has_k_w          )
, .o_has_v                    (s2_dec_has_v_w          )
, .o_has_hash                 (s2_dec_has_hash_w       )
);

assign s2_vld_w = s1_vld_r;
assign s2_opcode_w = s1_opcode_r;
assign s2_k_w = s1_k_r;
assign s2_v_w = s1_v_r;
assign s2_h_w = i_hash_h_w;

// ========================================================================== //
//                                                                            //
// [S2] Command Queues                                                        //
//                                                                            //
// ========================================================================== //

assign queue_push_opcode = s2_vld_r;
assign queue_push_k = s2_vld_r & s2_dec_has_k_r;
assign queue_push_v = s2_vld_r & s2_dec_has_v_r;
assign queue_push_h = s2_vld_r & s2_dec_has_hash_r;

// -------------------------------------------------------------------------- //
//
queue_rf #(
  .N(cfg_pkg::CMD_QUEUE_N),.W(h_pkg::OPCODE_W), .FLOP_OUT(1'b1))
  u_queue_rf_opcode (
//
  .i_push                     (queue_push_opcode       )
, .i_push_dat                 (s2_opcode_r             )
//
, .i_pop                      ()
, .o_pop_dat                  ()
//
, .o_full_w                   ()
, .o_empty_w                  ()
//
, .clk                        (clk                     )
, .arst_n                     (arst_n                  )
);

// -------------------------------------------------------------------------- //
//
queue_rf #(
    .N(cfg_pkg::CMD_QUEUE_N), .W(cfg_pkg::K_W), .FLOP_OUT(1'b1))
  u_queue_rf_k (
//
  .i_push                     (queue_push_k            )
, .i_push_dat                 (s2_k_r                  )
//
, .i_pop                      ()
, .o_pop_dat                  ()
//
, .o_full_w                   ()
, .o_empty_w                  ()
//
, .clk                        (clk                     )
, .arst_n                     (arst_n                  )
);

// -------------------------------------------------------------------------- //
//
queue_rf #(
    .N(cfg_pkg::CMD_QUEUE_N), .W(cfg_pkg::V_W))
  u_queue_rf_v (
//
  .i_push                     (queue_push_v            )
, .i_push_dat                 (s2_v_r                  )
//
, .i_pop                      ()
, .o_pop_dat                  ()
//
, .o_full_w                   ()
, .o_empty_w                  ()
//
, .clk                        (clk                     )
, .arst_n                     (arst_n                  )
);

// -------------------------------------------------------------------------- //
//
queue_rf #(
    .N(cfg_pkg::CMD_QUEUE_N), .W(cfg_pkg::H_W))
  u_queue_rf_hash (
//
  .i_push                     (queue_push_h            )
, .i_push_dat                 (s2_h_r                  )
//
, .i_pop                      ()
, .o_pop_dat                  ()
//
, .o_full_w                   ()
, .o_empty_w                  ()
//
, .clk                        (clk                     )
, .arst_n                     (arst_n                  )
);

endmodule : h_bdy_fe
