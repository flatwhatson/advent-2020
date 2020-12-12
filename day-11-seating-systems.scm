#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme cxr)
        (scheme list)
        (advent-utils))

(define (layout-ref l x y)
  (string-ref (vector-ref l y) x))

(define (layout-ref/default l x y default)
  (or (and (>= x 0)
           (>= y 0)
           (< y (vector-length l))
           (let ((r (vector-ref l y)))
             (and (< x (string-length r))
                  (string-ref r x))))
      default))

(define (layout-set! l x y c)
  (string-set! (vector-ref l y) x c))

(define (layout-fold f acc l)
  (let ((last-y (vector-length l))
        (last-x (string-length (vector-ref l 0))))
    (let loop ((x 0) (y 0) (acc acc))
      (cond ((= y last-y)
             acc)
            ((= x last-x)
             (loop 0 (+ y 1) acc))
            (else
             (let ((c (layout-ref l x y)))
               (loop (+ x 1) y (f x y c acc))))))))

(define (layout-copy l)
  (vector-map string-copy l))

(define (layout-transform f l1)
  (let* ((l2 (layout-copy l1))
         (mod (layout-fold
               (lambda (x y c mod)
                 (let ((n (f l1 x y c)))
                   (if (char=? c n)
                       mod
                       (begin
                         (layout-set! l2 x y n)
                         (+ mod 1)))))
               0 l1)))
    (values l2 mod)))

(define (layout-count l d)
  (layout-fold (lambda (x y c acc)
                 (if (char=? c d)
                     (+ acc 1)
                     acc))
               0 l))

(define adjacent-offsets
  '((-1 -1) ( 0 -1) ( 1 -1)
    (-1  0)         ( 1  0)
    (-1  1) ( 0  1) ( 1  1)))

(define (n-adjacent? l x y c limit)
  (let loop ((offsets adjacent-offsets)
             (count 0))
    (cond
     ((= count limit) #t)
     ((null? offsets) #f)
     (else (let* ((x1 (+ x (caar offsets)))
                  (y1 (+ y (cadar offsets)))
                  (d (layout-ref/default l x1 y1 #f))
                  (i (if (and d (char=? c d)) 1 0)))
             (loop (cdr offsets) (+ count i)))))))

(define (layout-look/default l x y dx dy default)
  (let loop ((x (+ x dx))
             (y (+ y dy)))
    (let ((c (layout-ref/default l x y #f)))
      (cond ((not c) default)
            ((not (char=? c #\.)) c)
            (else (loop (+ x dx) (+ y dy)))))))

(define (n-visible? l x y c limit)
  (let loop ((offsets adjacent-offsets)
             (count 0))
    (cond
     ((= count limit) #t)
     ((null? offsets) #f)
     (else (let* ((dx (caar offsets))
                  (dy (cadar offsets))
                  (d (layout-look/default l x y dx dy #f))
                  (i (if (and d (char=? c d)) 1 0)))
             (loop (cdr offsets) (+ count i)))))))

(define (next-state-1 l x y c)
  (cond ((and (char=? c #\L)
              (not (n-adjacent? l x y #\# 1)))
         #\#)
        ((and (char=? c #\#)
              (n-adjacent? l x y #\# 4))
         #\L)
        (else c)))

(define (next-state-2 l x y c)
  (cond ((and (char=? c #\L)
              (not (n-visible? l x y #\# 1)))
         #\#)
        ((and (char=? c #\#)
              (n-visible? l x y #\# 5))
         #\L)
        (else c)))

(define (process-layout layout next-state)
  (let loop ((l1 layout))
    (let-values (((l2 mod) (layout-transform next-state l1)))
      (if (zero? mod)
          (layout-count l1 #\#)
          (loop l2)))))

(define (process-layout-1 layout)
  (process-layout layout next-state-1))

(define (process-layout-2 layout)
  (process-layout layout next-state-2))

(run-advent-program
 process-layout-1
 process-layout-2
 (lambda (process)
   (process (list->vector (file->lines "data/day-11.txt")))))
