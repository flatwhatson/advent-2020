#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme cxr)
        (scheme list)
        (scheme regex)
        (advent-utils))

(define (parse-direction c)
  (cond ((char=? c #\N) 'north)
        ((char=? c #\S) 'south)
        ((char=? c #\E) 'east)
        ((char=? c #\W) 'west)
        ((char=? c #\L) 'left)
        ((char=? c #\R) 'right)
        ((char=? c #\F) 'forward)
        (else
         (error "Invalid direction char" c))))

(define (parse-commmand line)
  (let ((m (regexp-matches '(: ($ alpha)
                               ($ (+ num)))
                           line)))
    (if (not m)
        (error "Invalid commmand line" line)
        (let ((d (parse-direction (string-ref (regexp-match-submatch m 1) 0)))
              (n (string->number (regexp-match-submatch m 2))))
          (cons d n)))))

(define (rotate-left* d)
  (cond ((eq? d 'north) 'west)
        ((eq? d 'east) 'north)
        ((eq? d 'south) 'east)
        ((eq? d 'west) 'south)))

(define (rotate-right* d)
  (cond ((eq? d 'north) 'east)
        ((eq? d 'east) 'south)
        ((eq? d 'south) 'west)
        ((eq? d 'west) 'north)))

(define (rotate d cmd deg)
  (let ((f (cond ((eq? cmd 'left) rotate-left*)
                 ((eq? cmd 'right) rotate-right*)))
        (n (/ deg 90)))
    (let loop ((d d) (i 0))
      (if (= i n) d
          (loop (f d) (+ i 1))))))

(define (follow-commands commands)
  (let loop ((x 0) (y 0) (d 'east) (commands commands))
    (if (null? commands)
        (values x y d)
        (let* ((cmd (caar commands))
               (num (cdar commands))
               (cmds (cdr commands)))
          (cond ((eq? cmd 'north)
                 (loop x (+ y num) d cmds))
                ((eq? cmd 'south)
                 (loop x (- y num) d cmds))
                ((eq? cmd 'east)
                 (loop (+ x num) y d cmds))
                ((eq? cmd 'west)
                 (loop (- x num) y d cmds))
                ((or (eq? cmd 'left) (eq? cmd 'right))
                 (loop x y (rotate d cmd num) cmds))
                ((eq? cmd 'forward)
                 (loop x y d (cons (cons d num) cmds)))
                (else
                 (error "Invalid command" cmd)))))))

(define (process-commmands-1 commands)
  (let-values (((x y d) (follow-commands commands)))
    (+ (abs x) (abs y))))

(define (process-commmands-2 commmands)
  #t)

(run-advent-program
 process-commmands-1
 process-commmands-2
 (lambda (process)
   (process (map parse-commmand (file->lines "data/day-12.txt")))))
