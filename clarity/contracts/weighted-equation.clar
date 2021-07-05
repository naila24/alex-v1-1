
(impl-trait .trait-equation.equation-trait)

(define-constant no-liquidity-err (err u61))

;; weighted-equation
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

;; private functions
;;

;; public functions
;;
(define-read-only (get-y-given-x (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (dx uint))
    ;; TODO check weights add to 1
    ;; TODO add fee
    (ok (* balance-y (pow (pow (- u1 (/ balance-x (+ balance-x dx))) (/ weight-x u100)) (/ u1 (/ weight-y u100)))))
)

(define-read-only (get-x-given-y (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (dy uint))
    ;; TODO check weights add to 1
    ;; TODO add fee
    (ok (* balance-x (- (pow (pow (/ balance-y (- balance-y dy)) (/ weight-y u100)) (/ u1 (/ weight-x u100))) u1)))
)

(define-read-only (get-x-given-price (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (price uint))
    ;; TODO check weights add to 1
    ;; TODO add fee
    (ok (* balance-x (- (pow (/ price (/ (* balance-x (/ weight-y u100)) (* balance-y (/ weight-x u100)))) (/ weight-y u100)) u1)))
)

(define-read-only (get-token-given-position (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (total-supply uint) (dx uint) (dy uint))
    (ok
        (if (is-eq total-supply u0)
            ;; burn a fraction of initial lp token to avoid attack as described in WP https://uniswap.org/whitepaper.pdf
            {token: (sqrti (* (pow dx (/ weight-x u100)) (pow dy (/ weight-y u100)))), dy: dy}
            {token: (/ (* dx total-supply) balance-x), dy: (/ (* dx balance-y) balance-x)}
        )
    )   
)

(define-read-only (get-position-given-mint (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (total-supply uint) (token uint))
    
    ;; need to ensure total-supply > 0
    ;;(asserts! (> total-supply u0) no-liquidity-err)
    (let 
        (
            (dx (* balance-x (/ token total-supply))) 
            (dy (* dx (/ (/ weight-y u100) (/ weight-x u100))))
        ) 
        (ok {dx: dx, dy: dy})
    )
)

(define-read-only (get-position-given-burn (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (total-supply uint) (token uint))
    ;; this is identical to get-position-given-mint. Can we reduce to one?

    ;; need to ensure total-supply > 0
    ;;(asserts! (> total-supply u0) no-liquidity-err)
    (let 
        (
            (dx (* balance-x (/ token total-supply))) 
            (dy (* dx (/ (/ weight-y u100) (/ weight-x u100))))
        ) 
        (ok {dx: dx, dy: dy})
    )
)