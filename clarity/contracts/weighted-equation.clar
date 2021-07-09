
(impl-trait .trait-equation.equation-trait)

(define-constant no-liquidity-err (err u61))
(define-constant weight-sum-err (err u62))

;; following https://github.com/balancer-labs/balancer-v2-monorepo/blob/master/pkg/solidity-utils/contracts/math/FixedPoint.sol
(define-constant ONE18 u1000000000000000000) ;;18 decimal places
(define-constant MAX_POW_RELATIVE_ERROR u10000) 

;; weighted-equation
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

;; private functions
;;
(define-read-only (mulDown (a uint) (b uint))
    (let 
        (
            (product (* a b))
        )
        (ok (/ product ONE18))
    )
)

(define-read-only (mulUp (a uint) (b uint))
    (let
        (
            (product (* a b))
        )
        (if (is-eq product u0)
            (ok u0)
            (ok (+ u1 (/ (- product u1) ONE18)))
        )
    )
)

(define-read-only (divDown (a uint) (b uint))
    (let
        (
            (a-inflated (* a ONE18))
        )
        (if (is-eq a u0)
            (ok u0)
            (ok (/ a-inflated b))
        )
    )
)

(define-read-only (divUp (a uint) (b uint))
    (let
        (
            (a-inflated (* a ONE18))
        )
        (if (is-eq a u0)
            (ok u0)
            (ok (+ u1 (/ (- a-inflated u1) b)))
        )
    )
)

(define-read-only (powDown (a uint) (b uint))    
    (let
        (
            (raw (pow u2 (/ (* b (log2 a)) ONE18)))
            (max-error (+ u1 (unwrap-panic (mulUp raw MAX_POW_RELATIVE_ERROR))))
        )
        (if (< raw max-error)
            (ok u0)
            (ok (- raw max-error))
        )
    )
)

;; public functions
;;
(define-read-only (get-y-given-x (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (dx uint))
    ;; TODO add fee
    (let ()
        (asserts! (is-eq (+ weight-x weight-y) u100) weight-sum-err)
        (ok (* balance-y (pow (pow (- u1 (/ balance-x (+ balance-x dx))) (/ weight-x u100)) (/ u1 (/ weight-y u100)))))        
    )
)

(define-read-only (get-x-given-y (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (dy uint))
    ;; TODO add fee
    (let ()
        (asserts! (is-eq (+ weight-x weight-y) u100) weight-sum-err)
        (ok (* balance-x (- (pow (pow (/ balance-y (- balance-y dy)) (/ weight-y u100)) (/ u1 (/ weight-x u100))) u1)))    
    )
)

(define-read-only (get-x-given-price (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (price uint))
    ;; TODO add fee
    (let ()
        (asserts! (is-eq (+ weight-x weight-y) u100) weight-sum-err)
        (ok (* balance-x (- (pow (/ price (/ (* balance-x (/ weight-y u100)) (* balance-y (/ weight-x u100)))) (/ weight-y u100)) u1)))
    )
)

(define-read-only (get-token-given-position (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (total-supply uint) (dx uint) (dy uint))
    ;;(asserts! (is-eq (+ weight-x weight-y) u100) weight-sum-err)

    (ok
        (if (is-eq total-supply u0)
            ;; burn a fraction of initial lp token to avoid attack as described in WP https://uniswap.org/whitepaper.pdf
            {token: (sqrti (* (pow dx (/ weight-x u100)) (pow dy (/ weight-y u100)))), dy: dy}
            {token: (/ (* dx total-supply) balance-x), dy: (/ (* dx balance-y) balance-x)}
        )
    )   
)

(define-read-only (get-position-given-mint (balance-x uint) (balance-y uint) (weight-x uint) (weight-y uint) (total-supply uint) (token uint))
    ;;(asserts! (is-eq (+ weight-x weight-y) u100) weight-sum-err)

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
    ;;(asserts! (is-eq (+ weight-x weight-y) u100) weight-sum-err)

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