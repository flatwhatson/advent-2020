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

(define (process-passports-1 passports)
  (count (lambda (passport)
           (every (lambda (field)
                    (assoc field passport))
                  '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid")))
         passports))

(define (verify key check passport)
  (check (cdr (assoc key passport))))

(define (check-birth-year value)
  (let ((byr (string->number value)))
    (and (>= byr 1920) (<= byr 2002))))

(define (check-issue-year value)
  (let ((iyr (string->number value)))
    (and (>= iyr 2010) (<= iyr 2020))))

(define (check-expiration-year value)
  (let ((eyr (string->number value)))
    (and (>= eyr 2020) (<= eyr 2030))))

(define (check-height value)
  (let* ((m (regexp-matches '(: ($ (+ num)) ($ (or "cm" "in"))) value))
         (hgt (string->number (regexp-match-submatch m 1)))
         (unit (regexp-match-submatch m 2)))
    (or (and (string=? unit "cm") (>= hgt 150) (<= hgt 193))
        (and (string=? unit "in") (>= hgt  59) (<= hgt  76)))))

(define (check-hair-color value)
  (regexp-matches? '(: #\# (= 6 hex-digit)) value))

(define (check-eye-color value)
  (regexp-matches? '(or "amb" "blu" "brn" "gry" "grn" "hzl" "oth") value))

(define (check-passport-id value)
  (regexp-matches? '(= 9 numeric) value))

(define (process-passports-2 passports)
  (count (lambda (p)
           (guard (error (else #f))
             (and (verify "byr" check-birth-year p)
                  (verify "iyr" check-issue-year p)
                  (verify "eyr" check-expiration-year p)
                  (verify "hgt" check-height p)
                  (verify "hcl" check-hair-color p)
                  (verify "ecl" check-eye-color p)
                  (verify "pid" check-passport-id p))))
         passports))

(run-advent-program
 process-passports-1
 process-passports-2
 (lambda (file process)
   (process (parse-passports (file->lines file)))))
