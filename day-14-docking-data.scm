#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme bitwise)
        (scheme comparator)
        (scheme hash-table)
        (scheme list)
        (scheme regex)
        (advent-utils))

(define number-comparator
  (make-comparator number? = < number-hash))

(define (parse-mask mask)
  (let loop ((i 0) (index '()) (value '()))
    (cond ((= i 36)
           (list (list->bits index)
                 (list->bits value)))
          ((char=? (string-ref mask i) #\0)
           (loop (+ i 1) (cons #t index) (cons #f value)))
          ((char=? (string-ref mask i) #\1)
           (loop (+ i 1) (cons #t index) (cons #t value)))
          (else
           (loop (+ i 1) (cons #f index) (cons #f value))))))

(define (parse-instruction line)
  (let ((m (regexp-matches
            '(or (: "mask = " ($ (= 36 ("01X"))))
                 (: "mem[" ($ (+ num)) "] = " ($ (+ num))))
            line)))
    (if (not m)
        (error "Invalid instruction" line)
        (let ((mask (regexp-match-submatch m 1))
              (addr (regexp-match-submatch m 2))
              (value (regexp-match-submatch m 3)))
          (if mask
              (cons 'mask (parse-mask mask))
              (list (string->number addr)
                    (string->number value)))))))

(define (process-program-1 program)
  (let ((mem (make-hash-table number-comparator)))
    (let loop ((cmds program) (index 0) (mask 0))
      (if (null? cmds)
          (apply + (hash-table-values mem))
          (let* ((cmd (car cmds))
                 (cmds (cdr cmds)))
            (if (eq? (first cmd) 'mask)
                (let ((index (second cmd))
                      (value (third cmd)))
                  (loop cmds index value))
                (let* ((addr (first cmd))
                       (value (second cmd))
                       (masked (bitwise-if index mask value)))
                  (hash-table-set! mem addr masked)
                  (loop cmds index mask))))))))

(define (process-program-2 program)
  #t)

(run-advent-program
 process-program-1
 process-program-2
 (lambda (process)
   (process (map parse-instruction (file->lines "data/day-14.txt")))))
