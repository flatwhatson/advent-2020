#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme comparator)
        (scheme list)
        (scheme hash-table)
        (scheme sort)
        (advent-utils))

(define number-comparator
  (make-comparator number? = < number-hash))

(define (process-joltages-1 numbers)
  (let* ((nums (list-sort! < numbers))
         (nums (append nums (list (+ (last nums) 3))))
         (diffs (vector 0 0 0 0)))
    (let loop ((nums nums) (jolt 0))
      (if (null? nums)
          (* (vector-ref diffs 1)
             (vector-ref diffs 3))
          (let* ((num (car nums))
                 (diff (- num jolt))
                 (count (+ (vector-ref diffs diff) 1)))
            (vector-set! diffs diff count)
            (loop (cdr nums) num))))))

(define (permutations nums)
  (let ((num (car nums)))
    (let loop ((nums (cdr nums)) (perms '()))
      (if (or (null? nums)
              (> (car nums) (+ num 3)))
          (reverse! perms)
          (loop (cdr nums) (cons nums perms))))))

(define (count-permutations* cache nums)
  (let ((perms (permutations nums)))
    (if (null? perms) 1
        (apply + (map (lambda (perm)
                        (count-permutations cache perm))
                      perms)))))

(define (count-permutations cache nums)
  (or (hash-table-ref/default cache (car nums) #f)
      (let ((count (count-permutations* cache nums)))
        (hash-table-set! cache (car nums) count)
        count)))

(define (process-joltages-2 numbers)
  (let* ((nums (cons 0 (list-sort! < numbers)))
         (cache (make-hash-table number-comparator)))
    (count-permutations cache nums)))

(run-advent-program
 process-joltages-1
 process-joltages-2
 (lambda (process)
   (process (map string->number (file->lines "data/day-10.txt")))))
