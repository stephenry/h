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

module h_bdy_fe_dec (
// -------------------------------------------------------------------------- //
// Command Interface
  input wire h_pkg::opcode_t                      i_opcode

// Microcode
, output wire logic                               o_has_k
, output wire logic                               o_has_v
, output wire logic                               o_has_hash
);

import h_pkg::*;

// Opcode has KEY
assign o_has_k = i_opcode inside {OPCODE_INSERT, OPCODE_FIND};

// Opcode has VALUE
assign o_has_v = i_opcode inside {OPCODE_INSERT};

// Opcode has Hash
assign o_has_hash = i_opcode inside {OPCODE_INSERT, OPCODE_FIND};

endmodule : h_bdy_fe_dec
