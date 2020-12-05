;;; Use SRFI-1 to provide (scheme list)

(define-library (scheme list)

  (export
;;; Constructors
   cons
   list
   xcons
   cons*
   make-list
   list-tabulate
   list-copy
   circular-list
   iota

;;; Predicates
   proper-list?
   circular-list?
   dotted-list?
   pair?
   null?
   null-list?
   not-pair?
   list=

;;; Selectors
   car
   cdr
   caar
   cadr
   cdar
   cddr
   caaar
   caadr
   cadar
   caddr
   cdaar
   cdadr
   cddar
   cdddr
   caaaar
   caaadr
   caadar
   caaddr
   cadaar
   cadadr
   caddar
   cadddr
   cdaaar
   cdaadr
   cdadar
   cdaddr
   cddaar
   cddadr
   cdddar
   cddddr
   list-ref
   first
   second
   third
   fourth
   fifth
   sixth
   seventh
   eighth
   ninth
   tenth
   car+cdr
   take
   drop
   take-right
   drop-right
   take!
   drop-right!
   split-at
   split-at!
   last
   last-pair

;;; Miscelleneous: length, append, concatenate, reverse, zip & count
   length
   length+
   append
   append!
   concatenate
   concatenate!
   reverse
   reverse!
   append-reverse
   append-reverse!
   zip
   unzip1
   unzip2
   unzip3
   unzip4
   unzip5
   count

;;; Fold, unfold & map
   fold
   fold-right
   pair-fold
   pair-fold-right
   reduce
   reduce-right
   unfold
   unfold-right
   map
   for-each
   append-map
   append-map!
   map!
   map-in-order
   pair-for-each
   filter-map

;;; Filtering & partitioning
   filter
   partition
   remove
   filter!
   partition!
   remove!

;;; Searching
   find
   find-tail
   take-while
   take-while!
   drop-while
   span
   span!
   break
   break!
   any
   every
   list-index
   member
   memq
   memv

;;; Deletion
   delete
   delete!
   delete-duplicates
   delete-duplicates!

;;; Association lists
   assoc
   assq
   assv
   alist-cons
   alist-copy
   alist-delete
   alist-delete!

;;; Set operations on lists
   lset<=
   lset=
   lset-adjoin
   lset-union
   lset-intersection
   lset-difference
   lset-xor
   lset-diff+intersection
   lset-union!
   lset-intersection!
   lset-difference!
   lset-xor!
   lset-diff+intersection!

;;; Primitive side-effects
   set-car!
   set-cdr!
   )

  (import (srfi srfi-1)))
