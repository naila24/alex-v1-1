;; alex-reserve-pool
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

;; private functions
;;

;; public functions
;;

(define-data-var rebate-rate uint u50000000) ;;50%

(define-read-only (get-rebate-rate)
    (ok (var-get rebate-rate))
)

;; TODO: access control
(define-public (set-rebate-rate (rate uint))
    (ok (var-set rebate-rate rate))
)