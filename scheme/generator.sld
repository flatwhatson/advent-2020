;;; Use the SRFI-158 reference implementation to provide (scheme generator)

(define-library (scheme generator)

  (export generator circular-generator make-iota-generator make-range-generator
          make-coroutine-generator list->generator vector->generator
          reverse-vector->generator string->generator
          bytevector->generator
          make-for-each-generator make-unfold-generator

          gcons* gappend gcombine gfilter gremove
          gtake gdrop gtake-while gdrop-while
          gflatten ggroup gmerge gmap gstate-filter
          gdelete gdelete-neighbor-dups gindex gselect

          generator->list generator->reverse-list
          generator->vector generator->vector!  generator->string
          generator-fold generator-map->list generator-for-each generator-find
          generator-count generator-any generator-every generator-unfold

          make-accumulator count-accumulator list-accumulator
          reverse-list-accumulator vector-accumulator
          reverse-vector-accumulator vector-accumulator!
          string-accumulator bytevector-accumulator bytevector-accumulator!
          sum-accumulator product-accumulator)

  (import (srfi srfi-158)))
