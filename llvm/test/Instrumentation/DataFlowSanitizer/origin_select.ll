; RUN: opt < %s -dfsan -dfsan-track-select-control-flow=1 -dfsan-track-origins=1 -dfsan-fast-8-labels=true  -S | FileCheck %s --check-prefixes=CHECK,TRACK_CONTROL_FLOW
; RUN: opt < %s -dfsan -dfsan-track-select-control-flow=0 -dfsan-track-origins=1 -dfsan-fast-8-labels=true  -S | FileCheck %s --check-prefixes=CHECK,NO_TRACK_CONTROL_FLOW
; RUN: opt < %s -dfsan -dfsan-track-select-control-flow=1 -dfsan-track-origins=1 -dfsan-fast-16-labels=true -S | FileCheck %s --check-prefixes=CHECK,TRACK_CONTROL_FLOW
; RUN: opt < %s -dfsan -dfsan-track-select-control-flow=0 -dfsan-track-origins=1 -dfsan-fast-16-labels=true -S | FileCheck %s --check-prefixes=CHECK,NO_TRACK_CONTROL_FLOW
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; CHECK: @__dfsan_arg_tls = external thread_local(initialexec) global [[TLS_ARR:\[100 x i64\]]]
; CHECK: @__dfsan_retval_tls = external thread_local(initialexec) global [[TLS_ARR]]
; CHECK: @__dfsan_shadow_width_bits = weak_odr constant i32 [[#SBITS:]]
; CHECK: @__dfsan_shadow_width_bytes = weak_odr constant i32 [[#SBYTES:]]

define i8 @select8(i1 %c, i8 %t, i8 %f) {
  ; TRACK_CONTROL_FLOW: @"dfs$select8"
  ; TRACK_CONTROL_FLOW: [[CO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; TRACK_CONTROL_FLOW: [[FO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 2), align 4
  ; TRACK_CONTROL_FLOW: [[TO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 1), align 4
  ; TRACK_CONTROL_FLOW: [[CS:%.*]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([[TLS_ARR]]* @__dfsan_arg_tls to i[[#SBITS]]*), align 2
  ; TRACK_CONTROL_FLOW: [[TFO:%.*]] = select i1 %c, i32 [[TO]], i32 [[FO]]
  ; TRACK_CONTROL_FLOW: [[CS_NE:%.*]] = icmp ne i[[#SBITS]] [[CS]], 0
  ; TRACK_CONTROL_FLOW: [[CTFO:%.*]] = select i1 [[CS_NE]], i32 [[CO]], i32 [[TFO]]
  ; TRACK_CONTROL_FLOW: store i32 [[CTFO]], i32* @__dfsan_retval_origin_tls, align 4

  ; NO_TRACK_CONTROL_FLOW: @"dfs$select8"
  ; NO_TRACK_CONTROL_FLOW: [[FO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 2), align 4
  ; NO_TRACK_CONTROL_FLOW: [[TO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 1), align 4
  ; NO_TRACK_CONTROL_FLOW: [[TFO:%.*]] = select i1 %c, i32 [[TO]], i32 [[FO]]
  ; NO_TRACK_CONTROL_FLOW: store i32 [[TFO]], i32* @__dfsan_retval_origin_tls, align 4

  %a = select i1 %c, i8 %t, i8 %f
  ret i8 %a
}

define i8 @select8e(i1 %c, i8 %tf) {
  ; TRACK_CONTROL_FLOW: @"dfs$select8e"
  ; TRACK_CONTROL_FLOW: [[CO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; TRACK_CONTROL_FLOW: [[TFO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 1), align 4
  ; TRACK_CONTROL_FLOW: [[CS:%.*]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([[TLS_ARR]]* @__dfsan_arg_tls to i[[#SBITS]]*), align 2
  ; TRACK_CONTROL_FLOW: [[CS_NE:%.*]] = icmp ne i[[#SBITS]] [[CS]], 0
  ; TRACK_CONTROL_FLOW: [[CTFO:%.*]] = select i1 [[CS_NE]], i32 [[CO]], i32 [[TFO]]
  ; TRACK_CONTROL_FLOW: store i32 [[CTFO]], i32* @__dfsan_retval_origin_tls, align 4

  ; NO_TRACK_CONTROL_FLOW: @"dfs$select8e"
  ; NO_TRACK_CONTROL_FLOW: [[TFO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 1), align 4
  ; NO_TRACK_CONTROL_FLOW: store i32 [[TFO]], i32* @__dfsan_retval_origin_tls, align 4

%a = select i1 %c, i8 %tf, i8 %tf
  ret i8 %a
}

define <4 x i8> @select8v(<4 x i1> %c, <4 x i8> %t, <4 x i8> %f) {
  ; TRACK_CONTROL_FLOW: @"dfs$select8v"
  ; TRACK_CONTROL_FLOW: [[CO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; TRACK_CONTROL_FLOW: [[FO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 2), align 4
  ; TRACK_CONTROL_FLOW: [[TO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 1), align 4
  ; TRACK_CONTROL_FLOW: [[FS:%.*]] = load i[[#SBITS]], i[[#SBITS]]* inttoptr (i64 add (i64 ptrtoint ([[TLS_ARR]]* @__dfsan_arg_tls to i64), i64 4) to i[[#SBITS]]*), align 2
  ; TRACK_CONTROL_FLOW: [[CS:%.*]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([[TLS_ARR]]* @__dfsan_arg_tls to i[[#SBITS]]*), align 2
  ; TRACK_CONTROL_FLOW: [[FS_NE:%.*]] = icmp ne i[[#SBITS]] [[FS]], 0
  ; TRACK_CONTROL_FLOW: [[FTO:%.*]] = select i1 [[FS_NE]], i32 [[FO]], i32 [[TO]]
  ; TRACK_CONTROL_FLOW: [[CS_NE:%.*]] = icmp ne i[[#SBITS]] [[CS]], 0
  ; TRACK_CONTROL_FLOW: [[CFTO:%.*]] = select i1 [[CS_NE]], i32 [[CO]], i32 [[FTO]]
  ; TRACK_CONTROL_FLOW: store i32 [[CFTO]], i32* @__dfsan_retval_origin_tls, align 4

  ; NO_TRACK_CONTROL_FLOW: @"dfs$select8v"
  ; NO_TRACK_CONTROL_FLOW: [[FO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 2), align 4
  ; NO_TRACK_CONTROL_FLOW: [[TO:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 1), align 4
  ; NO_TRACK_CONTROL_FLOW: [[FS:%.*]] = load i[[#SBITS]], i[[#SBITS]]* inttoptr (i64 add (i64 ptrtoint ([[TLS_ARR]]* @__dfsan_arg_tls to i64), i64 4) to i[[#SBITS]]*), align 2
  ; NO_TRACK_CONTROL_FLOW: [[FS_NE:%.*]] = icmp ne i[[#SBITS]] [[FS]], 0
  ; NO_TRACK_CONTROL_FLOW: [[FTO:%.*]] = select i1 [[FS_NE]], i32 [[FO]], i32 [[TO]]
  ; NO_TRACK_CONTROL_FLOW: store i32 [[FTO]], i32* @__dfsan_retval_origin_tls, align 4

  %a = select <4 x i1> %c, <4 x i8> %t, <4 x i8> %f
  ret <4 x i8> %a
}