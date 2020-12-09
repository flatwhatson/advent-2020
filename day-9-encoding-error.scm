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

(define (process-numbers-1 numbers)
  (let-values (((init rest) (split-at numbers 25)))
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

(define (ideque-sum q)
  (ideque-fold (lambda (n acc)
                 (+ acc n))
               0 q))

(define (ideque-minmax q)
  (let loop ((min '()) (max '()) (q q))
    (if (ideque-empty? q)
        (values min max)
        (let* ((n (ideque-front q))
               (q (ideque-remove-front q))
               (min (if (or (null? min) (< n min)) n min))
               (max (if (or (null? max) (> n max)) n max)))
          (loop min max q)))))

(define (process-numbers-2 numbers)
  (let* ((needle (process-numbers-1 numbers))
         (seq (ideque (first numbers) (second numbers)))
         (sum (ideque-sum seq))
         (rest (drop numbers 2)))
    (let loop ((seq seq) (sum sum) (rest rest))
      (cond ((= sum needle)
             (let-values (((min max) (ideque-minmax seq)))
               (+ min max)))
            ((> sum needle)
             (let* ((n (ideque-front seq))
                    (seq (ideque-remove-front seq))
                    (sum (- sum n)))
               (loop seq sum rest)))
            ((< sum needle)
             (let* ((n (car rest))
                    (seq (ideque-add-back seq n))
                    (sum (+ sum n))
                    (rest (cdr rest)))
               (loop seq sum rest)))))))

(run-advent-program
 process-numbers-1
 process-numbers-2
 (lambda (process)
   (process (map string->number (file->lines "data/day-9.txt")))))
