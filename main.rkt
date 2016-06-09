#lang racket/base

(require racket/list)

(provide (struct-out task)
         add-task!
         remove-task!
         write-task-list)

;;A basic task has a title a description and an optional due date
;;due-date should either be null or a date struct
(struct task (name description due-date) #:prefab)


;;A to-do list is a list of tasks
;;DO NOT PROVIDE OUT! Create functions to work on this instead.
(define task-list '())

(define (add-task! task)
  (set! task-list (cons task task-list)))

(define (remove-task! pos)
    (define-values (front back) (split-at task-list pos))
    (set! task-list (append front (cdr back))))

(define (write-task-list)
  (write task-list))