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

`ifndef H_RTL_H_PKG_VH
`define H_RTL_H_PKG_VH

`include "cfg_pkg.vh"

package h_pkg;

// Generic (Opaque) Key type.
typedef logic [cfg_pkg::K_W - 1:0] k_t;

// Generic Value type.
typedef logic [cfg_pkg::V_W - 1:0] v_t;

// Generic Hash type.
typedef logic [cfg_pkg::H_W - 1:0] h_t;

localparam int OPCODE_W = 3;

typedef enum logic [OPCODE_W - 1:0] {
  // Equivalent to: std::unordered_map<K, V>::insert
  OPCODE_INSERT               = OPCODE_W'('b000)

  // Equivalent to: std::unordered_map<K, V>::find
, OPCODE_FIND                 = OPCODE_W'('b100)

  // Equivalent to: std::unordered_map<K, V>::clear
, OPCODE_CLEAR                = OPCODE_W'('b111)
} opcode_t;

localparam int STATUS_W = 3;

typedef enum logic [STATUS_W - 1:0] {
  // Operation has completed successfully
  STATUS_SUCCESS              = STATUS_W'('b000)

  // Equivalent to: return of std::unordered_map<K, V>::end()
, STATUS_NOTFOUND             = STATUS_W'('b111)
} status_t;

endpackage : h_pkg

`endif
