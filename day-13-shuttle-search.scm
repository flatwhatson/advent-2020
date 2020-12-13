#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (scheme regex)
        (advent-utils))

(define (process-schedule-1 time busses)
  (write time)
  (newline)
  (let loop ((busses busses) (bus 'x) (wait 0))
    (cond ((null? busses)
           (* bus wait))
          ((eq? (car busses) 'x)
           (loop (cdr busses) bus wait))
          (else
           (let* ((next-bus (car busses))
                  (next-wait (- next-bus (modulo time next-bus))))
             (write (list next-bus next-wait))
             (write (list (* next-bus next-wait)))
             (newline)
             (if (or (eq? bus 'x) (< next-wait wait))
                 (loop (cdr busses) next-bus next-wait)
                 (loop (cdr busses) bus wait)))))))

(define (process-schedule-2 time busses)
  #t)

(define (parse-bus str)
  (if (string=? str "x") 'x
      (string->number str)))

(run-advent-program
 process-schedule-1
 process-schedule-2
 (lambda (process)
   (let* ((lines (file->lines "data/day-13.txt"))
          (time (string->number (car lines)))
          (busses (map parse-bus (regexp-split "," (cadr lines)))))
     (process time busses))))
