(define-library (srfi srfi-115)

  (export regexp regexp? valid-sre? rx regexp->sre char-set->sre
          regexp-matches regexp-matches? regexp-search
          regexp-replace regexp-replace-all regexp-match->list
          regexp-fold regexp-extract regexp-split regexp-partition
          regexp-match? regexp-match-count
          regexp-match-submatch
          regexp-match-submatch-start regexp-match-submatch-end)

  (import (scheme base)
          (scheme char)
          (srfi srfi-1)
          (srfi srfi-14)
          (srfi srfi-69)
          (srfi srfi-130)
          (srfi srfi-151))

  (begin
    (define %char-set:letter
      (char-set-intersection char-set:ascii char-set:letter))
    (define %char-set:lower-case
      (char-set-intersection char-set:ascii char-set:lower-case))
    (define %char-set:upper-case
      (char-set-intersection char-set:ascii char-set:upper-case))
    (define %char-set:digit
      (char-set-intersection char-set:ascii char-set:digit))
    (define %char-set:letter+digit
      (char-set-intersection char-set:ascii char-set:letter+digit))
    (define %char-set:punctuation
      (char-set-intersection char-set:ascii char-set:punctuation))
    (define %char-set:symbol
      (char-set-intersection char-set:ascii char-set:symbol))
    (define %char-set:graphic
      (char-set-intersection char-set:ascii char-set:graphic))
    (define %char-set:whitespace
      (char-set-intersection char-set:ascii char-set:whitespace))
    (define %char-set:printing
      (char-set-intersection char-set:ascii char-set:printing))
    (define %char-set:iso-control
      (char-set-intersection char-set:ascii char-set:iso-control))
    (define (string-start-arg s o)
      (if (pair? o) (string-index->cursor s (car o)) (string-cursor-start s)))
    (define (string-end-arg s o)
      (if (pair? o) (string-index->cursor s (car o)) (string-cursor-end s)))
    (define string-cursor-ref string-ref/cursor)
    (define substring-cursor substring/cursors)
    (define (immutable-char-set cs) cs))

  (include "../external/srfi-115/contrib/duy-nguyen/srfi/115/boundary.scm")
  (include "../external/srfi-115/contrib/duy-nguyen/srfi/115.scm"))
