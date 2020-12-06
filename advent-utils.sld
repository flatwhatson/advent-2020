(define-library (advent-utils)

  (export file->lines
          run-advent-program)

  (import (scheme base)
          (scheme file)
          (scheme list)
          (scheme process-context)
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

    (define (run-advent-program part1 part2 run)
      (let* ((args (command-line))
             (argc (length args))
             (prog (first args))
             (file (list-ref/default args 1 #f))
             (part (list-ref/default args 2 "1"))
             (proc (if (string=? part "1") part1 part2)))
        (if (or (not file) (> argc 3))
            (display (string-append "usage: " prog " <input-file> [1-or-2]\n")
                     (current-error-port))
            (begin
              (write (run file proc))
              (newline)))))

    ))
