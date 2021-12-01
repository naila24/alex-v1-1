(impl-trait .trait-ownable.ownable-trait)
(impl-trait .trait-semi-fungible-token.semi-fungible-token-trait)

(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-TOO-MANY-POOLS (err u2004))
(define-constant ERR-INVALID-BALANCE (err u2008))

(define-fungible-token yield-wbtc)
(define-map token-balances {token-id: uint, owner: principal} uint)
(define-map token-supplies uint uint)
(define-map token-owned principal (list 2000 uint))

(define-data-var contract-owner principal tx-sender)
(define-map approved-contracts principal bool)

;; @desc get-owner
;; @returns (response principal)
(define-read-only (get-owner)
  (ok (var-get contract-owner))
)

;; @desc set-owner
;; @restricted Contract-Owner
;; @params owner
;; @returns (response bool)
(define-public (set-owner (owner principal))
  (begin
    (asserts! (is-eq contract-caller (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (ok (var-set contract-owner owner))
  )
)

;; @desc check-is-approved
;; @restricted Contract-Owner
;; @params sender
;; @returns (response bool)
(define-private (check-is-approved (sender principal))
  (ok (asserts! (or (default-to false (map-get? approved-contracts sender)) (is-eq sender (var-get contract-owner))) ERR-NOT-AUTHORIZED))
)

;; @desc get-token-owned
;; @params owner
;; @returns list
(define-read-only (get-token-owned (owner principal))
    (default-to (list) (map-get? token-owned owner))
)

;; @desc set-balance
;; @params token-id
;; @params balance
;; @params owner
;; @returns (response bool)
(define-private (set-balance (token-id uint) (balance uint) (owner principal))
    (begin
	    (map-set token-balances {token-id: token-id, owner: owner} balance)
        (map-set token-owned owner (unwrap! (as-max-len? (append (get-token-owned owner) token-id) u2000) ERR-TOO-MANY-POOLS))
        (ok true)
    )
)

;; @desc get-balance-or-default
;; @params token-id
;; @params who
;; @returns (response uint)
(define-private (get-balance-or-default (token-id uint) (who principal))
	(default-to u0 (map-get? token-balances {token-id: token-id, owner: who}))
)

;; @desc get-balance
;; @params token-id
;; @params who
;; @returns (response uint)
(define-read-only (get-balance (token-id uint) (who principal))
	(ok (get-balance-or-default token-id who))
)

;; @desc get-overall-balance
;; @params who
;; @returns (response uint)
(define-read-only (get-overall-balance (who principal))
	(ok (ft-get-balance yield-wbtc who))
)

;; @desc get-total-supply
;; @params token-id
;; @returns (response uint)
(define-read-only (get-total-supply (token-id uint))
	(ok (default-to u0 (map-get? token-supplies token-id)))
)

;; @desc get-overall-supply
;; @returns (response uint)
(define-read-only (get-overall-supply)
	(ok (ft-get-supply yield-wbtc))
)

;; @desc get-decimals
;; @params token-id
;; @returns (response uint)
(define-read-only (get-decimals (token-id uint))
  	(ok u8)
)

;; @desc get-token-uri
;; @params token-id
;; @returns (response none)
(define-read-only (get-token-uri (token-id uint))
	(ok none)
)

;; @desc transfer
;; @restricted sender ; tx-sender should be sender
;; @params token-id
;; @params amount
;; @params sender
;; @params recipient
;; @returns (response bool)
(define-public (transfer (token-id uint) (amount uint) (sender principal) (recipient principal))
	(let
		(
			(sender-balance (get-balance-or-default token-id sender))
		)
		(asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
		(asserts! (<= amount sender-balance) ERR-INVALID-BALANCE)
		(try! (ft-transfer? yield-wbtc amount sender recipient))
		(try! (set-balance token-id (- sender-balance amount) sender))
		(try! (set-balance token-id (+ (get-balance-or-default token-id recipient) amount) recipient))
		(print {type: "sft_transfer_event", token-id: token-id, amount: amount, sender: sender, recipient: recipient})
		(ok true)
	)
)

;; @desc transfer-memo
;; @restricted sender ; tx-sender should be sender
;; @params token-id
;; @params amount
;; @params sender
;; @params recipient
;; @params memo; expiry
;; @returns (response bool)
(define-public (transfer-memo (token-id uint) (amount uint) (sender principal) (recipient principal) (memo (buff 34)))
	(let
		(
			(sender-balance (get-balance-or-default token-id sender))
		)
		(asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
		(asserts! (<= amount sender-balance) ERR-INVALID-BALANCE)
		(try! (ft-transfer? yield-wbtc amount sender recipient))
		(try! (set-balance token-id (- sender-balance amount) sender))
		(try! (set-balance token-id (+ (get-balance-or-default token-id recipient) amount) recipient))
		(print {type: "sft_transfer_event", token-id: token-id, amount: amount, sender: sender, recipient: recipient, memo: memo})
		(ok true)
	)
)

;; @desc mint
;; @params token-id
;; @params amount
;; @params recipient
;; @returns (response bool)
(define-public (mint (token-id uint) (amount uint) (recipient principal))
	(begin
		(try! (check-is-approved contract-caller))
		(try! (ft-mint? yield-wbtc amount recipient))
		(try! (set-balance token-id (+ (get-balance-or-default token-id recipient) amount) recipient))
		(map-set token-supplies token-id (+ (unwrap-panic (get-total-supply token-id)) amount))
		(print {type: "sft_mint_event", token-id: token-id, amount: amount, recipient: recipient})
		(ok true)
	)
)

;; @desc burn
;; @restricted Contract-Owner/Approved Contract
;; @params token-id
;; @params amount
;; @params sender
;; @returns (response bool)
(define-public (burn (token-id uint) (amount uint) (sender principal))
	(begin
		(try! (check-is-approved contract-caller))
		(try! (ft-burn? yield-wbtc amount sender))
		(try! (set-balance token-id (- (get-balance-or-default token-id sender) amount) sender))
		(map-set token-supplies token-id (- (unwrap-panic (get-total-supply token-id)) amount))
		(print {type: "sft_burn_event", token-id: token-id, amount: amount, sender: sender})
		(ok true)
	)
)

(define-constant ONE_8 (pow u10 u8))

;; @desc pow-decimals
;; @returns uint
(define-private (pow-decimals)
  	(pow u10 (unwrap-panic (get-decimals u0)))
)

;; @desc fixed-to-decimals
;; @params amount
;; @returns uint
(define-read-only (fixed-to-decimals (amount uint))
  	(/ (* amount (pow-decimals)) ONE_8)
)

;; @desc decimals-to-fixed 
;; @params amount
;; @returns uint
(define-private (decimals-to-fixed (amount uint))
  	(/ (* amount ONE_8) (pow-decimals))
)

;; @desc get-total-supply-fixed
;; @params token-id
;; @returns (response uint)
(define-read-only (get-total-supply-fixed (token-id uint))
  	(ok (decimals-to-fixed (default-to u0 (map-get? token-supplies token-id))))
)

;; @desc get-balance-fixed
;; @params token-id
;; @params who
;; @returns (response uint)
(define-read-only (get-balance-fixed (token-id uint) (who principal))
  	(ok (decimals-to-fixed (get-balance-or-default token-id who)))
)

;; @desc get-overall-supply-fixed
;; @returns (response uint)
(define-read-only (get-overall-supply-fixed)
	(ok (decimals-to-fixed (ft-get-supply yield-wbtc)))
)

;; @desc get-overall-balance-fixed
;; @params who
;; @returns (response uint)
(define-read-only (get-overall-balance-fixed (who principal))
	(ok (decimals-to-fixed (ft-get-balance yield-wbtc who)))
)

;; @desc transfer-fixed
;; @params token-id
;; @params amount
;; @params sender
;; @params recipient
;; @returns (response boolean)
(define-public (transfer-fixed (token-id uint) (amount uint) (sender principal) (recipient principal))
  	(transfer token-id (fixed-to-decimals amount) sender recipient)
)

;; @desc transfer-memo-fixed
;; @params token-id
;; @params amount
;; @params sender
;; @params recipient
;; @params memo ; expiry
;; @returns (response boolean)
(define-public (transfer-memo-fixed (token-id uint) (amount uint) (sender principal) (recipient principal) (memo (buff 34)))
  	(transfer token-id (fixed-to-decimals amount) sender recipient memo)
)

;; @desc mint-fixed
;; @params token-id
;; @params amount
;; @params recipient
;; @returns (response boolean)
(define-public (mint-fixed (token-id uint) (amount uint) (recipient principal))
  	(mint token-id (fixed-to-decimals amount) recipient)
)

;; @desc burn-fixed
;; @params token-id
;; @params amount
;; @params sender
;; @returns (response boolean)
(define-public (burn-fixed (token-id uint) (amount uint) (sender principal))
  	(burn token-id (fixed-to-decimals amount) sender)
)

(begin
  (map-set approved-contracts .collateral-rebalancing-pool true)
)