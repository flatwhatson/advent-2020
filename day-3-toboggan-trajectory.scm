#!/usr/bin/env -S guile --r7rs -e main -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (advent-utils))

(define (count-trajectory lines dx dy)
  (let* ((height (vector-length lines))
         (width (string-length (vector-ref lines 0))))
    (let loop ((x 0) (y 0) (num-trees 0))
      (if (>= y height)
          num-trees
          (let* ((line (vector-ref lines y))
                 (char (string-ref line (modulo x width)))
                 (tree (char=? char #\#)))
            (loop (+ x dx) (+ y dy) (+ num-trees (if tree 1 0))))))))

(define (check-first-trajectory lines)
  (count-trajectory lines 3 1))

(define (check-all-trajectories lines)
  (apply * (map (lambda (dx dy)
                  (count-trajectory lines dx dy))
                '(1 3 5 7 1)
                '(1 1 1 1 2))))

(define (print-usage args)
  (let ((prog (first args)))
    (display (string-append "usage: " prog " <input-file> [1-or-2]\n")
             (current-error-port))))

(define (main args)
  (let* ((argc (length args))
         (proc (cond ((= argc 2)
                      check-first-trajectory)
                     ((and (= argc 3) (string=? (third args) "1"))
                      check-first-trajectory)
                     ((and (= argc 3) (string=? (third args) "2"))
                      check-all-trajectories)
                     (else #f))))
    (if proc
        (let* ((file (second args))
               (lines (file->lines file))
               (result (proc (list->vector lines))))
          (write result)
          (newline))
        (print-usage args))))
