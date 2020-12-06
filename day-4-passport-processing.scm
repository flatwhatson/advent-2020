#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme list)
        (scheme regex)
        (advent-utils))

(define (parse-passport-line line record)
  (let loop ((tokens (regexp-split 'space line))
             (record record))
    (if (null? tokens)
        record
        (let* ((parts (regexp-split #\: (car tokens)))
               (pair (cons (first parts) (second parts))))
          (loop (cdr tokens) (cons pair record))))))

(define (parse-passports lines)
  (let loop ((lines lines) (record '()) (records '()))
    (if (null? lines)
        (cons record records)
        (let* ((end (string=? (car lines) ""))
               (records (if end (cons record records) records))
               (record (if end '() (parse-passport-line (car lines) record)))
               (lines (cdr lines)))
          (loop lines record records)))))

(define (process-passports-1 lines)
  (count (lambda (passport)
           (every (lambda (field)
                    (assoc field passport string=?))
                  '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid")))
         (parse-passports lines)))

(define (process-passports-2 lines)
  #t)

(run-advent-program
 process-passports-1
 process-passports-2
 (lambda (file process)
   (process (file->lines file))))
