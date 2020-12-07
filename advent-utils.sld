(define-library (advent-utils)

  (export file->lines
          run-advent-program)

  (import (scheme base)
          (scheme file)
          (scheme list)
          (scheme process-context)
          (scheme time)
          (scheme write))

  (begin

    (define (read-lines port)
      (let loop ((lines '()))
        (let ((line (read-line port)))
          (if (eof-object? line)
              (reverse! lines)
              (loop (cons line lines))))))

    (define (file->lines file)
      (let* ((port (open-input-file file))
             (lines (read-lines port)))
        (close-port port)
        lines))

    (define (list-ref/default ls i default)
      (let loop ((ls ls) (i i))
        (cond ((null? ls) default)
              ((zero? i) (car ls))
              (else (loop (cdr ls) (- i 1))))))

    (define (round-to-microsecs s)
      (inexact (/ (floor (* s 1000000)) 1000000)))

    (define (run-advent-program part1 part2 run)
      (let* ((args (command-line))
             (argc (length args))
             (part (list-ref/default args 1 "1"))
             (proc (cond ((string=? part "1") part1)
                         ((string=? part "2") part2)
                         (else #f))))
        (if (and proc (<= argc 2))
            (let* ((start (current-jiffy))
                   (result (run proc))
                   (finish (current-jiffy))
                   (seconds (/ (- finish start) (jiffies-per-second))))
              (for-each display (list result "\ncompleted in "
                                      (round-to-microsecs seconds) "s\n")))
            (display (string-append "usage: " (first args) " [1-or-2]\n")
                     (current-error-port)))))))
