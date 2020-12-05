#!/usr/bin/env -S guile --r7rs -e main -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (advent-utils))

(define (count-trajectory file)
  (let* ((lines (list->vector (file->lines file)))
         (finish (vector-length lines))
         (tree-at? (lambda (x y)
                     (let* ((row (vector-ref lines y))
                            (len (string-length row))
                            (chr (string-ref row (modulo x len))))
                       (char=? chr #\#)))))
    (let loop ((x 0) (y 0) (num-trees 0))
      (if (>= y finish)
          num-trees
          (loop (+ x 3) (+ y 1) (if (tree-at? x y)
                                    (+ num-trees 1)
                                    num-trees))))))

(define (print-usage args)
  (let ((prog (first args)))
    (display (string-append "usage: " prog " <input-file>\n")
             (current-error-port))))

(define (main args)
  (let ((argc (length args)))
    (if (= argc 2)
        (let* ((file (second args))
               (result (count-trajectory file)))
          (write result)
          (newline))
        (print-usage args))))
