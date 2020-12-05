#!/usr/bin/env -S guile --r7rs -e main -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (scheme regex)
        (advent-utils))

(define (parse-policy-line line)
  (let ((m (regexp-matches '(: ($ (+ num)) "-"
                               ($ (+ num)) " "
                               ($ alpha) ": "
                               ($ (+ alpha)))
                           line)))
    (if (not m)
        (error "Invalid password line" line)
        (let ((min (string->number (regexp-match-submatch m 1)))
              (max (string->number (regexp-match-submatch m 2)))
              (char (first (string->list (regexp-match-submatch m 3))))
              (pass (regexp-match-submatch m 4)))
          (values min max char pass)))))

(define (check-policy-1 line)
  (let-values (((min max char pass) (parse-policy-line line)))
    (let ((found (count (lambda (c)
                          (char=? char c))
                        (string->list pass))))
      (and (>= found min)
           (<= found max)))))

(define (check-policy-2 line)
  (let-values (((1st 2nd char pass) (parse-policy-line line)))
    (let ((p1 (char=? char (string-ref pass (- 1st 1))))
          (p2 (char=? char (string-ref pass (- 2nd 1)))))
      (or (and p1 (not p2))
          (and p2 (not p1))))))

(define (print-usage args)
  (let ((prog (first args)))
    (display (string-append "usage: " prog " <input-file> [1-or-2]\n")
             (current-error-port))))

(define (main args)
  (let* ((argc (length args))
         (proc (cond ((= 2 argc)
                      check-policy-1)
                     ((and (= 3 argc) (string=? (third args) "1"))
                      check-policy-1)
                     ((and (= 3 argc) (string=? (third args) "2"))
                      check-policy-2)
                     (else #f))))
    (if proc
        (let* ((file (second args))
               (lines (file->lines file))
               (result (count proc lines)))
          (write result)
          (newline))
        (print-usage args))))
