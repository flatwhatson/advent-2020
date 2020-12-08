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
  (let run ((pc 0) (acc 0) (seen (set number-comparator)))
    (if (or (>= pc (vector-length program))
            (set-contains? seen pc))
        (cons pc acc)
        (let* ((instruction (vector-ref program pc))
               (opcode (car instruction))
               (number (cdr instruction))
               (seen (set-adjoin! seen pc)))
          (cond ((eq? opcode 'nop)
                 (run (+ pc 1) acc seen))
                ((eq? opcode 'acc)
                 (run (+ pc 1) (+ acc number) seen))
                ((eq? opcode 'jmp)
                 (run (+ pc number) acc seen)))))))

(define (process-program-1 program)
  (let ((result (run-program program)))
    (cdr result)))

(define (patch-program program n)
  (let loop ((i 0) (c 0))
    (let* ((instruction (vector-ref program i))
           (opcode (car instruction))
           (number (cdr instruction)))
      (cond ((eq? opcode 'acc)
             (loop (+ i 1) c))
            ((< c n)
             (loop (+ i 1) (+ c 1)))
            (else
             (let ((patched (vector-copy program))
                   (newcode (if (eq? opcode 'nop) 'jmp 'nop)))
               (vector-set! patched i (cons newcode number))
               patched))))))

(define (process-program-2 program)
  (let loop ((n 0))
    (let* ((patched (patch-program program n))
           (result (run-program patched))
           (pc (car result))
           (acc (cdr result)))
      (if (= pc (vector-length program))
          acc
          (loop (+ n 1))))))

(run-advent-program
 process-program-1
 process-program-2
 (lambda (process)
   (process (parse-program (file->lines "data/day-8.txt")))))
