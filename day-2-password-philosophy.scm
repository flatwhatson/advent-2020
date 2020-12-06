#!/usr/bin/env -S guile --r7rs -s
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

(run-advent-program
 check-policy-1
 check-policy-2
 (lambda (valid)
   (count valid (file->lines "data/day-2.txt"))))
