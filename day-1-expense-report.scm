#!/usr/bin/env -S guile --r7rs -e main -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme comparator)
        (scheme list)
        (scheme set)
        (scheme sort))

(define (read-numbers-from-port port)
  (let loop ((nums '()))
    (let ((line (read-line port)))
      (if (eof-object? line) nums
          (loop (cons (string->number line) nums))))))

(define (read-numbers-from-file file)
  (let* ((port (open-input-file file))
         (numbers (read-numbers-from-port port)))
    (close-port port)
    numbers))

(define (list->number-set numbers)
  (list->set (make-comparator number? = < number-hash) numbers))

(define (process-expense-report file)
  (let* ((num-list (read-numbers-from-file file))
         (num-set (list->number-set num-list)))
    (any (lambda (n)
           (let ((m (- 2020 n)))
             (if (set-contains? num-set m)
                 (* n m)
                 #f)))
         num-list)))

(define (main args)
  (if (= (length args) 2)
      (let* ((file (second args))
             (result (process-expense-report file)))
        (write result)
        (newline))
      (let ((prog (first args)))
        (display (string-append "usage: " prog " <input-file>\n")
                 (current-error-port)))))
