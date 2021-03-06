; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=m68k-linux | FileCheck %s
; FIXME: When using SelectionDAGISel, the following cases use
; `sub` rather than the expected `neg`

define i32 @mul4294967295_32(i32 %A) {
; CHECK-LABEL: mul4294967295_32:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0:
; CHECK-NEXT:    move.l #0, %d0
; CHECK-NEXT:    sub.l (4,%sp), %d0
; CHECK-NEXT:    rts
    %mul = mul i32 %A, 4294967295
    ret i32 %mul
}

; NOTE: If returning a 64-bit integer, d0 will be the higher 32-bit!
define i64 @mul18446744073709551615_64(i64 %A) {
; CHECK-LABEL: mul18446744073709551615_64:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    move.l #0, %d1
; CHECK-NEXT:    sub.l (8,%sp), %d1
; CHECK-NEXT:    negx.l %d0
; CHECK-NEXT:    rts
    %mul = mul i64 %A, 18446744073709551615
    ret i64 %mul
}
