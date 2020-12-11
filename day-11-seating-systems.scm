#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme cxr)
        (scheme list)
        (advent-utils))

(define (layout-ref l x y)
  (and (>= x 0)
       (>= y 0)
       (< y (vector-length l))
       (let ((r (vector-ref l y)))
         (and (< x (string-length r))
              (string-ref r x)))))

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
             (loop (+ x 1) y (f x y acc)))))))

(define (layout-copy l)
  (vector-map string-copy l))

(define adjacent-offsets
  '((-1 -1) ( 0 -1) ( 1 -1)
    (-1  0)         ( 1  0)
    (-1  1) ( 0  1) ( 1  1)))

(define (count-adjacent l x y c)
  (let loop ((offsets adjacent-offsets)
             (count 0))
    (if (null? offsets)
        count
        (let* ((xd (+ x (caar offsets)))
               (yd (+ y (cadar offsets)))
               (cd (layout-ref l xd yd)))
          (loop (cdr offsets)
                (+ count (if (and cd (char=? c cd)) 1 0)))))))

(define (count-occupied l x y)
  (count-adjacent l x y #\#))

(define (next-state l x y)
  (let ((c (layout-ref l x y)))
    (cond ((and (char=? c #\L)
                (zero? (count-occupied l x y)))
           #\#)
          ((and (char=? c #\#)
                (>= (count-occupied l x y) 4))
           #\L)
          (else #f))))

(define (process-layout-1 layout)
  (let loop ((l layout) (iter 0))
    (let* ((ld (layout-copy l))
           (mod (layout-fold
                 (lambda (x y mod)
                   (let ((next (next-state l x y)))
                     (if next
                         (begin
                           (layout-set! ld x y next)
                           (+ mod 1))
                         mod)))
                 0 l)))
      (if (zero? mod)
          (layout-fold
           (lambda (x y mod)
             (if (char=? (layout-ref l x y) #\#)
                 (+ mod 1)
                 mod))
           0 l)
          (loop ld (+ iter 1))))))

(define (process-layout-2 layout)
  #t)

(run-advent-program
 process-layout-1
 process-layout-2
 (lambda (process)
   (process (list->vector (file->lines "data/day-11.txt")))))
