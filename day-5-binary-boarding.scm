#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme comparator)
        (scheme list)
        (scheme set)
        (advent-utils))

(define number-comparator
  (make-comparator number? = < number-hash))

(define (parse-bsp str lower upper max)
  (let loop ((i 0) (min 0) (max max))
    (if (= min max) max
        (let ((c (string-ref str i))
              (mid (+ min (/ (- max min) 2))))
          (cond ((char=? c lower)
                 (loop (+ i 1) min (floor mid)))
                ((char=? c upper)
                 (loop (+ i 1) (ceiling mid) max))
                (else
                 (error "Invalid BSP" string)))))))

(define (boarding-pass->id str)
  (let ((row (parse-bsp (substring str 0 7) #\F #\B 127))
        (col (parse-bsp (substring str 7 10) #\L #\R 7)))
    (+ (* row 8) col)))

(define (process-boarding-passes-1 lines)
  (apply max (map boarding-pass->id lines)))

(define (process-boarding-passes-2 lines)
  (let ((seen (list->set number-comparator
                         (map boarding-pass->id lines))))
    (find (lambda (i)
            (and (not (set-contains? seen i))
                 (set-contains? seen (- i 1))
                 (set-contains? seen (+ i 1))))
          (iota (+ (* 127 8) 6) 1))))

(run-advent-program
 process-boarding-passes-1
 process-boarding-passes-2
 (lambda (process)
   (process (file->lines "data/day-5.txt"))))
