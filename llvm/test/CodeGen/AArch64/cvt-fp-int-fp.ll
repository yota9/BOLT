; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 -o - %s  -mattr=+neon,+fullfp16 | FileCheck %s

define double @t1(double %x) {
; CHECK-LABEL: t1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtzs d0, d0
; CHECK-NEXT:    scvtf d0, d0
; CHECK-NEXT:    ret
entry:
  %conv = fptosi double %x to i64
  %conv1 = sitofp i64 %conv to double
  ret double %conv1
}

define float @t2(float %x) {
; CHECK-LABEL: t2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtzs s0, s0
; CHECK-NEXT:    scvtf s0, s0
; CHECK-NEXT:    ret
entry:
  %conv = fptosi float %x to i32
  %conv1 = sitofp i32 %conv to float
  ret float %conv1
}

define half @t3(half %x)  {
; CHECK-LABEL: t3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtzs h0, h0
; CHECK-NEXT:    scvtf h0, h0
; CHECK-NEXT:    ret
entry:
  %conv = fptosi half %x to i32
  %conv1 = sitofp i32 %conv to half
  ret half %conv1
}

define double @t4(double %x) {
; CHECK-LABEL: t4:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtzu d0, d0
; CHECK-NEXT:    ucvtf d0, d0
; CHECK-NEXT:    ret
entry:
  %conv = fptoui double %x to i64
  %conv1 = uitofp i64 %conv to double
  ret double %conv1
}

define float @t5(float %x) {
; CHECK-LABEL: t5:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtzu s0, s0
; CHECK-NEXT:    ucvtf s0, s0
; CHECK-NEXT:    ret
entry:
  %conv = fptoui float %x to i32
  %conv1 = uitofp i32 %conv to float
  ret float %conv1
}

define half @t6(half %x)  {
; CHECK-LABEL: t6:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtzu h0, h0
; CHECK-NEXT:    ucvtf h0, h0
; CHECK-NEXT:    ret
entry:
  %conv = fptoui half %x to i32
  %conv1 = uitofp i32 %conv to half
  ret half %conv1
}
