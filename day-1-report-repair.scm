#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme comparator)
        (scheme hash-table)
        (scheme list)
        (scheme set)
        (advent-utils))

(define number-comparator
  (make-comparator number? = < number-hash))

(define (find-matching-two numbers)
  (let ((num-set (list->set number-comparator numbers)))
    (any (lambda (n)
           (let ((m (- 2020 n)))
             (and (set-contains? num-set m)
                  (* n m))))
         numbers)))

(define (find-matching-three numbers)
  (let ((num-hash (make-hash-table number-comparator)))
    (for-each (lambda (n)
                (for-each (lambda (m)
                            (hash-table-set! num-hash (+ n m) (list n m)))
                          numbers))
              numbers)
    (any (lambda (n)
           (let* ((m (- 2020 n))
                  (r (hash-table-ref/default num-hash m #f)))
             (and r (apply * n r))))
         numbers)))

(run-advent-program
 find-matching-two
 find-matching-three
 (lambda (file process)
   (process (map string->number (file->lines file)))))
