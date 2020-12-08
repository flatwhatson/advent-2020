#!/usr/bin/env -S guile --r7rs -s
!# ; -*- mode: scheme -*-
(import (scheme base)
        (scheme comparator)
        (scheme list)
        (scheme regex)
        (scheme set)
        (advent-utils))

(define number-comparator
  (make-comparator number? = < number-hash))

(define (parse-opcode str)
  (cond ((string=? str "nop") 'nop)
        ((string=? str "acc") 'acc)
        ((string=? str "jmp") 'jmp)
        (else
         (error "Invalid opcode" str))))


(define (parse-instruction line)
  (let ((m (regexp-matches '(: ($ (or "nop" "acc" "jmp")) " "
                               ($ ("+-") (+ num)))
                           line)))
    (if m
        (let ((opcode (parse-opcode (regexp-match-submatch m 1)))
              (number (string->number (regexp-match-submatch m 2))))
          (cons opcode number))
        (error "Invalid line" line))))

(define (parse-program lines)
  (list->vector (map parse-instruction lines)))

(define (run-program program)
  (let ((last (vector-length program))
        (seen (set number-comparator)))
    (let run ((pc 0) (acc 0))
      (cond ((>= pc last) acc)
            ((set-contains? seen pc) acc)
            (else
             (set! seen (set-adjoin! seen pc))
             (let* ((instruction (vector-ref program pc))
                    (opcode (car instruction))
                    (number (cdr instruction)))
               (cond ((eq? opcode 'nop)
                      (run (+ pc 1) acc))
                     ((eq? opcode 'acc)
                      (run (+ pc 1) (+ acc number)))
                     ((eq? opcode 'jmp)
                      (run (+ pc number) acc)))))))))

(define (process-program-1 program)
  (run-program program))

(define (process-program-2 program)
  program)

(run-advent-program
 process-program-1
 process-program-2
 (lambda (process)
   (process (parse-program (file->lines "data/day-8.txt")))))
