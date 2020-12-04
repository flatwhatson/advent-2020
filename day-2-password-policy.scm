#!/usr/bin/env -S guile --r7rs -e main -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (scheme regex))

(define (read-lines port)
  (let loop ((lines '()))
    (let ((line (read-line port)))
      (if (eof-object? line)
          (reverse! lines)
          (loop (cons line lines))))))

(define (read-lines-from-file file)
  (let* ((port (open-input-file file))
         (lines (read-lines port)))
    (close-port port)
    lines))

(define (check-password line)
  (let ((m (regexp-matches '(: ($ (+ num)) "-"
                               ($ (+ num)) " "
                               ($ alpha) ": "
                               ($ (+ alpha)))
                           line)))
    (if (not m)
        (error "Invalid password line" line)
        (let* ((matches (regexp-match->list m))
               (min (string->number (second matches)))
               (max (string->number (third matches)))
               (char (first (string->list (fourth matches))))
               (pass (fifth matches))
               (found (count (lambda (c)
                               (char=? char c))
                             (string->list pass))))
          (and (>= found min)
               (<= found max))))))

(define (check-passwords file)
  (count check-password
         (read-lines-from-file file)))

(define (print-usage args)
  (let ((prog (first args)))
    (display (string-append "usage: " prog " <input-file>\n")
             (current-error-port))))

(define (main args)
  (if (= 2 (length args))
      (let* ((file (second args))
             (result (check-passwords file)))
        (write result)
        (newline))
      (print-usage args)))
