; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv6m-eabi -verify-machineinstrs < %s | FileCheck %s

define i32 @subs(i32 %a, i32 %b) {
; CHECK-LABEL: subs:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, r0, r1
; CHECK-NEXT:    beq .LBB0_2
; CHECK-NEXT:  @ %bb.1: @ %false
; CHECK-NEXT:    movs r0, #5
; CHECK-NEXT:    bx lr
; CHECK-NEXT:  .LBB0_2: @ %true
; CHECK-NEXT:    movs r0, #4
; CHECK-NEXT:    bx lr
entry:
  %c = sub i32 %a, %b
  %d = icmp eq i32 %c, 0
  br i1 %d, label %true, label %false

true:
  ret i32 4

false:
  ret i32 5
}

define i32 @addsrr(i32 %a, i32 %b) {
; CHECK-LABEL: addsrr:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r0, r0, r1
; CHECK-NEXT:    beq .LBB1_2
; CHECK-NEXT:  @ %bb.1: @ %false
; CHECK-NEXT:    movs r0, #5
; CHECK-NEXT:    bx lr
; CHECK-NEXT:  .LBB1_2: @ %true
; CHECK-NEXT:    movs r0, #4
; CHECK-NEXT:    bx lr
entry:
  %c = add i32 %a, %b
  %d = icmp eq i32 %c, 0
  br i1 %d, label %true, label %false

true:
  ret i32 4

false:
  ret i32 5
}

define i32 @lslri(i32 %a, i32 %b) {
; CHECK-LABEL: lslri:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsls r0, r0, #3
; CHECK-NEXT:    beq .LBB2_2
; CHECK-NEXT:  @ %bb.1: @ %false
; CHECK-NEXT:    movs r0, #5
; CHECK-NEXT:    bx lr
; CHECK-NEXT:  .LBB2_2: @ %true
; CHECK-NEXT:    movs r0, #4
; CHECK-NEXT:    bx lr
entry:
  %c = shl i32 %a, 3
  %d = icmp eq i32 %c, 0
  br i1 %d, label %true, label %false

true:
  ret i32 4

false:
  ret i32 5
}

define i32 @lslrr(i32 %a, i32 %b) {
; CHECK-LABEL: lslrr:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsls r0, r1
; CHECK-NEXT:    beq .LBB3_2
; CHECK-NEXT:  @ %bb.1: @ %false
; CHECK-NEXT:    movs r0, #5
; CHECK-NEXT:    bx lr
; CHECK-NEXT:  .LBB3_2: @ %true
; CHECK-NEXT:    movs r0, #4
; CHECK-NEXT:    bx lr
entry:
  %c = shl i32 %a, %b
  %d = icmp eq i32 %c, 0
  br i1 %d, label %true, label %false

true:
  ret i32 4

false:
  ret i32 5
}
