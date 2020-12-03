(define-library (srfi srfi-125)

  (export

   make-hash-table
   hash-table
   hash-table-unfold
   alist->hash-table

   hash-table?
   hash-table-contains?
   hash-table-empty?
   hash-table=?
   hash-table-mutable?

   hash-table-ref
   hash-table-ref/default

   hash-table-set!
   hash-table-delete!
   hash-table-intern!
   hash-table-update!
   hash-table-update!/default
   hash-table-pop!
   hash-table-clear!

   hash-table-size
   hash-table-keys
   hash-table-values
   hash-table-entries
   hash-table-find
   hash-table-count

   hash-table-map
   hash-table-for-each
   hash-table-map!
   hash-table-map->list
   hash-table-fold
   hash-table-prune!

   hash-table-copy
   hash-table-empty-copy
   hash-table->alist

   hash-table-union!
   hash-table-intersection!
   hash-table-difference!
   hash-table-xor!

   ;; The following procedures are deprecated by SRFI 125:

   hash
   string-hash
   string-ci-hash
   hash-by-identity

   hash-table-equivalence-function
   hash-table-hash-function
   hash-table-exists?
   hash-table-walk
   hash-table-merge!
   )

  (import (scheme base)
          (scheme char)
          (scheme write) ; for warnings about deprecated features
          (srfi srfi-126)
          (except (srfi srfi-128)
                  hash-salt      ; exported by (srfi 126)
                  string-hash    ; exported by (srfi 126)
                  string-ci-hash ; exported by (srfi 126)
                  symbol-hash    ; exported by (srfi 126)
                  ))

  (include "../external/srfi-125/srfi/125.body.scm")

  (begin
    (define hash                     deprecated:hash)
    (define string-hash              deprecated:string-hash)
    (define string-ci-hash           deprecated:string-ci-hash)
    (define hash-by-identity         deprecated:hash-by-identity)

    (define hash-table-equivalence-function
      deprecated:hash-table-equivalence-function)
    (define hash-table-hash-function deprecated:hash-table-hash-function)
    (define hash-table-exists?       deprecated:hash-table-exists?)
    (define hash-table-walk          deprecated:hash-table-walk)
    (define hash-table-merge!        deprecated:hash-table-merge!)))
