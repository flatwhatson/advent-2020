(define-library (srfi srfi-151)

  (export bitwise-not bitwise-and bitwise-ior bitwise-xor bitwise-eqv
          bitwise-nand bitwise-nor bitwise-andc1 bitwise-andc2
          bitwise-orc1 bitwise-orc2

          arithmetic-shift bit-count integer-length bitwise-if
          bit-set? copy-bit bit-swap any-bit-set? every-bit-set?  first-set-bit

          bit-field bit-field-any? bit-field-every?  bit-field-clear bit-field-set
          bit-field-replace  bit-field-replace-same
          bit-field-rotate bit-field-reverse

          bits->list list->bits bits->vector vector->bits bits
          bitwise-fold bitwise-for-each bitwise-unfold make-bitwise-generator)

  (import (scheme base)
          (scheme case-lambda)
          (only (rnrs arithmetic bitwise)
                bitwise-not bitwise-and bitwise-ior bitwise-xor
                bitwise-bit-count)
          (rename (only (rnrs arithmetic bitwise)
                        bitwise-arithmetic-shift bitwise-length)
                  (bitwise-arithmetic-shift arithmetic-shift)
                  (bitwise-length integer-length)))

  (begin
    (define (bit-count i) ; Negative case different to R6RS bitwise-bit-count
      (if (>= i 0)
          (bitwise-bit-count i)
          (bitwise-bit-count (bitwise-not i)))))

  ;; Stable part of the implementation
  (include "../external/srfi-151/srfi-151/bitwise-33.scm")
  (include "../external/srfi-151/srfi-151/bitwise-60.scm")
  (include "../external/srfi-151/srfi-151/bitwise-other.scm"))
