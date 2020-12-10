#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (scheme sort)
        (advent-utils))

(define (process-joltages-1 numbers)
  (let* ((nums (list-sort! < numbers))
         (nums (append nums (list (+ (last nums) 3))))
         (diffs (vector 0 0 0 0)))
    (let loop ((nums nums) (jolt 0))
      (if (null? nums)
          (* (vector-ref diffs 1)
             (vector-ref diffs 3))
      (let* ((num (car nums))
             (diff (- num jolt)))
        (vector-set! diffs diff (+ (vector-ref diffs diff) 1))
        (loop (cdr nums) num))))))

(define (process-joltages-2 numbers)
  #t)

(run-advent-program
 process-joltages-1
 process-joltages-2
 (lambda (process)
   (process (map string->number (file->lines "data/day-10.txt")))))
