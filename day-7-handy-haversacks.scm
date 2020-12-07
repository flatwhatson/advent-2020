#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme comparator)
        (scheme list)
        (scheme hash-table)
        (scheme regex)
        (advent-utils))

(define string-comparator
  (make-comparator string? string=? string<? string-hash))

(define (parse-inner-bags str)
  (if (string=? str "no other bags.")
      '()
      (let loop ((i 0) (bags '()))
        (let ((m (regexp-search '(: bos
                                    ($ (+ numeric)) " "
                                    ($ (+ alpha) " " (+ alpha))
                                    " bag" (? "s") ($ (or ", " ".")))
                                str i)))
          (if (not m)
              (error "Invalid rule" str)
              (let* ((bag-count (string->number (regexp-match-submatch m 1)))
                     (bag-type (regexp-match-submatch m 2))
                     (end-str (regexp-match-submatch m 3))
                     (end-pos (regexp-match-submatch-end m 3))
                     (bag (cons bag-type bag-count))
                     (bags (cons bag bags)))
                (if (string=? end-str ".")
                    bags
                    (loop end-pos bags))))))))

(define (parse-rule line)
  (let* ((parts (regexp-split " bags contain " line))
         (outer (first parts))
         (inner (parse-inner-bags (second parts))))
    (values outer inner)))

(define (parse-rules lines)
  (let ((rules (make-hash-table string-comparator)))
    (for-each (lambda (line)
                (let-values (((outer inner) (parse-rule line)))
                  (hash-table-set! rules outer inner)))
              lines)
    rules))

(define (contains? rules cache bag want)
  (or (hash-table-ref/default cache bag #f)
      (let ((result
             (or (string=? bag want)
                 (any (lambda (p)
                        (contains? rules cache (car p) want))
                      (hash-table-ref/default rules bag '())))))
        (hash-table-set! cache bag result)
        result)))

(define (process-rules-1 lines)
  (let ((rules (parse-rules lines))
        (cache (make-hash-table string-comparator)))
    (count (lambda (bag)
             (and (not (string=? bag "shiny gold"))
                  (contains? rules cache bag "shiny gold")))
           (hash-table-keys rules))))

(define (bag-sum rules cache bag)
  (or (hash-table-ref/default cache bag #f)
      (let ((result
             (apply + (map (lambda (p)
                             (let ((bag (car p))
                                   (num (cdr p)))
                               (+ num (* num (bag-sum rules cache bag)))))
                           (hash-table-ref/default rules bag '())))))
        (hash-table-set! cache bag result)
        result)))

(define (process-rules-2 lines)
  (let ((rules (parse-rules lines))
        (cache (make-hash-table string-comparator)))
    (bag-sum rules cache "shiny gold")))

(run-advent-program
 process-rules-1
 process-rules-2
 (lambda (process)
   (process (file->lines "data/day-7.txt"))))
