#lang racket/base

(require racket/list
         racket/serialize)

(provide (struct-out task)
         add-task!
         remove-task!
         get-task-list
         write-out-task-list
         read-in-task-list)

;;A basic task has a title a description and an optional due date
;;due-date should either be null or a date struct
(struct task (name description due-date) #:prefab)


;;A to-do list is a list of tasks
;;DO NOT PROVIDE OUT! Create functions to work on this instead.
(define task-list '())

(define (add-task! task)
  (set! task-list (cons task task-list)))

(define (remove-task! pos)
  (define-values (front back) (split-at task-list (sub1 pos)))
  (set! task-list (append front (cdr back))))

(define (write-task-list)
  (write task-list))

;;Since racket is call by value we can just provide a getter for the task list
(define (get-task-list)
  task-list)

;;Write out task-list to a file. By default written to task-list.dat which is in
;;the current programs directory. OVERRIDE THIS TO A SPECIFIC FILE OF YOUR CHOOSING ASAP!!
(define (write-out-task-list [file "task-list.dat"])
  (call-with-output-file
      file
    (lambda (out)
      (write (serialize task-list) out))
    #:exists 'replace))

;;Reads in task-list from a file. If it doesn't exist, will throw an error
(define (read-in-task-list [file "task-list.dat"] #:error-port[error-port (current-error-port)])
  (with-handlers ([exn:fail? (lambda (exn) (print "file does not exist yet" error-port))])
    (call-with-input-file
        file
      (lambda (in)
        (set! task-list (deserialize (read in)))))))