#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme ideque)
        (scheme list)
        (advent-utils))

(define (calc-init-sums init)
  (list->ideque
   (apply append (map (lambda (n)
                        (map (lambda (m)
                               (+ n m))
                             init))
                      init))))

(define (calc-new-sums sums prev n)
  (ideque-append
   (ideque-drop sums 24)
   (ideque-map (lambda (m)
                 (+ n m))
               prev)))

(define (process-numbers-1 data)
  (let-values (((init rest) (split-at data 25)))
    (let loop ((prev (list->ideque init))
               (sums (calc-init-sums init))
               (rest rest))
      (let ((n (car rest)))
        (if (not (ideque-find (lambda (m)
                                (= n m))
                              sums))
            n
            (let* ((prev (ideque-remove-front prev))
                   (sums (calc-new-sums sums prev n))
                   (prev (ideque-add-back prev n)))
              (loop prev sums (cdr rest))))))))

(define (process-numbers-2 numbers)
  #t)

(run-advent-program
 process-numbers-1
 process-numbers-2
 (lambda (process)
   (process (map string->number (file->lines "data/day-9.txt")))))
