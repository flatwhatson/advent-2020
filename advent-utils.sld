(define-library (advent-utils)
  (export file->lines)
  (import (scheme base)
          (scheme file)
          (scheme list))
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

    ))
