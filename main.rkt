#lang racket

(require syntax/parse/define)
(provide #%app #%datum
         (rename-out [saa-module-begin #%module-begin]))

(define-syntax-parser saa-module-begin
  [(_ prog ...) #'(#%module-begin prog ...)])