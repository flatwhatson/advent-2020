#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme charset)
        (scheme list)
        (advent-utils))

(define (new-form)
  (char-set))

(define (add-form form line)
  (char-set-union form (string->char-set line)))

(define (form-count form)
  (char-set-size form))

(define (parse-forms lines)
  (let loop ((lines lines) (form (new-form)) (forms '()))
    (if (null? lines)
        (cons form forms)
        (let* ((line (car lines))
               (lines (cdr lines))
               (end (string=? line ""))
               (forms (if end (cons form forms) forms))
               (form (if end (new-form) (add-form form line))))
          (loop lines form forms)))))

(define (process-customs-form-1 lines)
  (fold + 0 (map form-count (parse-forms lines))))

(define (process-customs-form-2 lines)
  #t)

(run-advent-program
 process-customs-form-1
 process-customs-form-2
 (lambda (process)
   (process (file->lines "data/day-6.txt"))))
