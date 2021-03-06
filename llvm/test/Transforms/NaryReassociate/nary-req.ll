; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -nary-reassociate -S | FileCheck %s
; RUN: opt < %s -passes='nary-reassociate' -S | FileCheck %s

declare i32 @llvm.smax.i32(i32 %a, i32 %b)

; This is a negative test. We should not optimize if intermediate result
; has a use outside of optimizaple pattern. In other words %smax2 has one
; use from %smax3 and side use from %res2.
define i32 @smax_test1(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @smax_test1(
; CHECK-NEXT:    [[C1:%.*]] = icmp sgt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[SMAX1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[B]], [[C:%.*]]
; CHECK-NEXT:    [[SMAX2:%.*]] = select i1 [[C2]], i32 [[B]], i32 [[C]]
; CHECK-NEXT:    [[C3:%.*]] = icmp sgt i32 [[SMAX2]], [[A]]
; CHECK-NEXT:    [[SMAX3:%.*]] = select i1 [[C3]], i32 [[SMAX2]], i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[SMAX1]], [[SMAX3]]
; CHECK-NEXT:    [[RES2:%.*]] = add i32 [[RES]], [[SMAX2]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp sgt i32 %a, %b
  %smax1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp sgt i32 %b, %c
  %smax2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp sgt i32 %smax2, %a
  %smax3 = select i1 %c3, i32 %smax2, i32 %a
  %res = add i32 %smax1, %smax3
  %res2 = add i32 %res, %smax2
  ret i32 %res
}

