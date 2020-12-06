#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (advent-utils))

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

(define (parse-boarding-row str)
  (parse-bsp (substring str 0 7) #\F #\B 127))

(define (parse-boarding-col str)
  (parse-bsp (substring str 7 10) #\L #\R 7))

(define (process-boarding-passes-1 lines)
  (apply max (map (lambda (line)
                    (let ((row (parse-boarding-row line))
                          (col (parse-boarding-col line)))
                      (+ (* row 8) col)))
                  lines)))

(define (process-boarding-passes-2 lines)
  #t)

(run-advent-program
 process-boarding-passes-1
 process-boarding-passes-2
 (lambda (process)
   (process (file->lines "data/day-5.txt"))))
