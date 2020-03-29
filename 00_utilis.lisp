;;;; Funções para o estudo do livro "The Little Schemer", usando o dialeto
;;;; Common Lisp (implementação SBCL) ao invés do dialeto Scheme.
;;;; Abrantes Araújo Silva Filho
;;;; abrantesasf@gmail.com

;;; Chapter 01: Toys

;; Cria função "atom?" para indicar os atoms. Esta função considera que a lista
;; vazia não é um atom (diferentemente do padrão de Common Lisp).
(defun atom? (x)
  (not (listp x)))

;; Cria função "list?" apenas para padronizar a chamada:
(defun list? (x)
  (listp x))

;; Cria função "null?" apenas para padronizar a chamada.
(defun null? (x)
  (null x))

;; Cria grupo de funções de comparação para padronizar a chamada:
(defun eq? (x y)
  (eq x y))

(defun eql? (x y)
  (eql x y))

(defun equal? (x y)
  (equal x y))

(defun equalp? (x y)
  (equalp x y))




;;; Chapter 02: Again

;; Cria função "lat?" para verificar se uma lista é composta somente por atoms.
;; Atenção: esta função utiliza funções definidas anteriormente!
(defun lat? (l)
  (cond
    ((atom? l) nil)                   ; previne erro se argumento for atom
    ((null? l) t)                     ; NIL é lat!
    ((atom? (car l)) (lat? (cdr l)))  ; CAR é lat? avalia CDR recursivamente
    (t nil)))                         ; retorna falso

;; Cria função "member?' para verificar se um atom está contido em uma lat.
;; Atenção: esta função utiliza funções definidas anteriormente!
(defun member? (a lat)
  (cond
    ((null? lat) nil)
    ((or (eql? a (car lat))
         (member? a (cdr lat))))))

;; Cria função "memberl?" que generaliza a função "member?" para verificar
;; se listas estão contidas em outras listas.
(defun memberl? (s l)
  (cond
    ((null? l) nil)
    ((or (equal? s (car l))
         (memberl? s (cdr l))))))




;;; Chapter 03: CONS

;; Cria função "rember" que procura a primeira ocorrência de um atom em uma
;; lista, e retorna uma nova lista sem essa primeira ocorrência.
(defun rember (a lat)
  (cond
    ((null? lat) '())
    ((eql? a (car lat)) (cdr lat))
    ((cons (car lat) (rember a (cdr lat))))))

;; Cria função "remberl" que expande a função anterior para lidar com listas.
(defun remberl (s l)
  (cond
    ((null? l) '())
    ((equal? s (car l)) (cdr l))
    ((cons (car l) (remberl s (cdr l))))))

;; Cria função "firsts" que retorna uma lista com todos os primeiros elementos
;; de outras listas recebidas como argumento
(defun firsts (l)
  (cond
    ((null? l) '())
    ((cons (car (car l)) (firsts (cdr l))))))

;; Cria função "insertR" que insere um elemento novo após um elemento
;; antigo em uma lat, retornando uma nova lista:
(defun insertR (new old lat)
  (cond
    ((null? lat) '())
    ((equal? old (car lat)) (cons old (cons new (cdr lat))))
    ((cons (car lat) (insertR new old (cdr lat))))))

;; Cria função "insertL" que insere um elemento novo antes de um elemento antigo
;; em uma lat, retornando uma nova lista:
(defun insertL (new old lat)
  (cond
    ((null? lat) '())
    ((equal? old (car lat)) (cons new (cons old (cdr lat))))
    ((cons (car lat) (insertL new old (cdr lat))))))

;; Cria função "substS" que troca um elemento old por um new em uma lat,
;; retornando uma nova lista. ATENÇÃO: CLisp já tem uma função "subst",
;; por isso essa aqui é chamada de "substS", de "substituiu uma S-exp".
(defun substS (new old lat)
  (cond
    ((null? lat) '())
    ((equal? old (car lat)) (cons new (cdr lat)))
    ((cons (car lat) (substS new old (cdr lat))))))

;; Cria função "substS2" que troca OU a primeira ocorrência de o1 OU a primeira
;; ocorrência de o2 por new.
(defun substS2 (new o1 o2 lat)
  (cond
    ((null? lat) '())
    ((or (equal? o1 (car lat))
         (equal? o2 (car lat)))
     (cons new (cdr lat)))
    ((cons (car lat) (substS2 new o1 o2 (cdr lat))))))

;; Cria a função "multirember" que remove TODAS as ocorrências de um atom de uma
;; lat, retornando uma nova lista.
(defun multirember (a lat)
  (cond
    ((null? lat) '())
    ((equal? a (car lat)) (multirember a (cdr lat)))
    ((cons (car lat) (multirember a (cdr lat))))))

;; Cria a função "multiinsertR" que insere um novo elemento após (à direita) de
;; TODAS as ocorrências de um elemento antigo em uma lat, e retorna nova lat.
(defun multiinsertR (new old lat)
  (cond
    ((null? lat) '())
    ((equal? old (car lat)) (cons old
                                  (cons new (multiinsertR new old (cdr lat)))))
    ((cons (car lat) (multiinsertR new old (cdr lat))))))

;; Cria função "multiinsertL" que insere um novo elemento antes (à esquerda) de
;; TODAS as ocorrências de um elemento antigo em uma lat, retornando nova lat.
(defun multiinsertL (new old lat)
  (cond
    ((null? lat) '())
    ((equal? old (car lat)) (cons new
                                  (cons old (multiinsertL new old (cdr lat)))))
    ((cons (car lat) (multiinsertL new old (cdr lat))))))

;; Cria função "multisubst" que troca TODAS as ocorrências de um elemento antigo
;; em uma lat por um elemento novo, retornando uma nova lat.
(defun multisubst (new old lat)
  (cond
    ((null? lat) '())
    ((equal? old (car lat)) (cons new (multisubst new old (cdr lat))))
    ((cons (car lat) (multisubst new old (cdr lat))))))

;; Cria função "multisubst2" que troca TODAS as ocorrência de um elemento antigo
;; OU outro elemento antigo em uma lat, por um elemento novo, retorna nova lat.
(defun multisubst2 (new o1 o2 l)
  (cond
    ((null? l) '())
    ((or (equal? o1 (car l))
         (equal? o2 (car l)))
     (cons new (multisubst2 new o1 o2 (cdr l))))
    ((cons (car l) (multisubst2 new o1 o2 (cdr l))))))
