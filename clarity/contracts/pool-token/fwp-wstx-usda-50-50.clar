(impl-trait .trait-ownable.ownable-trait)
(impl-trait .trait-sip-010.sip-010-trait)

(define-fungible-token fwp-wstx-usda-50-50)

(define-data-var token-uri (string-utf8 256) u"")
(define-data-var CONTRACT-OWNER principal tx-sender)
(define-map approved-contracts principal bool)

;; errors
(define-constant ERR-NOT-AUTHORIZED (err u1000))

;; @desc get-owner
;; @returns (response principal)
(define-read-only (get-owner)
  (ok (var-get CONTRACT-OWNER))
)

;; @desc set-owner
;; @restricted Contract-Owner
;; @params owner
;; @returns (reponse bool)
(define-public (set-owner (owner principal))
  (begin
    (asserts! (is-eq contract-caller (var-get CONTRACT-OWNER)) ERR-NOT-AUTHORIZED)
    (ok (var-set CONTRACT-OWNER owner))
  )
)

;; @desc check-is-approved
;; @restricted Approved-Contracts/Contract-Owner
;; @params sender
;; @returns (response boolean)
(define-private (check-is-approved (sender principal))
  (ok (asserts! (or (default-to false (map-get? approved-contracts sender)) (is-eq sender (var-get CONTRACT-OWNER))) ERR-NOT-AUTHORIZED))
)

;; ---------------------------------------------------------
;; SIP-10 Functions
;; ---------------------------------------------------------

;; @desc get-total-supply
;; @params token-id
;; @returns (response uint)
(define-read-only (get-total-supply)
  (ok (ft-get-supply fwp-wstx-usda-50-50))
)

;; @desc get-name
;; @returns (response string-utf8)
(define-read-only (get-name)
  (ok "fwp-wstx-usda-50-50")
)

;; @desc get-symbol
;; @returns (response string-utf8)
(define-read-only (get-symbol)
  (ok "fwp-wstx-usda-50-50")
)

;; @desc get-decimals
;; @returns (response uint)
(define-read-only (get-decimals)
  (ok u8)
)

;; @desc get-balance
;; @params account
;; @returns (response uint)
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance fwp-wstx-usda-50-50 account))
)

;; @desc set-token-uri
;; @restricted Contract-Owner
;; @params value
;; @returns (response bool)
(define-public (set-token-uri (value (string-utf8 256)))
  (begin
    (asserts! (is-eq contract-caller (var-get CONTRACT-OWNER)) ERR-NOT-AUTHORIZED)
    (ok (var-set token-uri value))
  )
)

;; @desc get-token-uri
;; @returns (response some string-utf-8)
(define-read-only (get-token-uri)
  (ok (some (var-get token-uri)))
)

;; @desc transfer
;; @restricted sender; tx-sender should be sender
;; @params amount
;; @params sender
;; @params recipient
;; @params memo; expiry
;; @returns (response bool uint)/ error
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq sender tx-sender) ERR-NOT-AUTHORIZED)
    (match (ft-transfer? fwp-wstx-usda-50-50 amount sender recipient)
      response (begin
        (print memo)
        (ok response)
      )
      error (err error)
    )
  )
)

;; @desc mint
;; @restricted recipient; tx-sender should be recipient
;; @params amount
;; @params recipient
;; @returns (response bool uint)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (try! (check-is-approved contract-caller))
    (ft-mint? fwp-wstx-usda-50-50 amount recipient)
  )
)

;; @desc burn
;; @restricted sender; tx-sender should be sender
;; @params amount
;; @params sender
;; @returns (response bool uint)
(define-public (burn (amount uint) (sender principal))
  (begin
    (try! (check-is-approved contract-caller))
    (ft-burn? fwp-wstx-usda-50-50 amount sender)
  )
)

(define-constant ONE_8 (pow u10 u8))

;; @desc pow-decimals
;; @returns uint
(define-private (pow-decimals)
  (pow u10 (unwrap-panic (get-decimals)))
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
(define-read-only (get-total-supply-fixed)
  (ok (decimals-to-fixed (ft-get-supply fwp-wstx-usda-50-50)))
)

;; @desc get-balance-fixed
;; @params token-id
;; @params who
;; @returns (response uint)
(define-read-only (get-balance-fixed (account principal))
  (ok (decimals-to-fixed (ft-get-balance fwp-wstx-usda-50-50 account)))
)

;; @desc transfer-fixed
;; @params token-id
;; @params amount
;; @params sender
;; @params recipient
;; @returns (response bool)
(define-public (transfer-fixed (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (transfer (fixed-to-decimals amount) sender recipient memo)
)

;; @desc mint-fixed
;; @params token-id
;; @params amount
;; @params recipient
;; @returns (response bool)
(define-public (mint-fixed (amount uint) (recipient principal))
  (mint (fixed-to-decimals amount) recipient)
)

;; @desc burn-fixed
;; @params token-id
;; @params amount
;; @params sender
;; @returns (response bool)
(define-public (burn-fixed (amount uint) (sender principal))
  (burn (fixed-to-decimals amount) sender)
)

(begin
  (map-set approved-contracts .fixed-weight-pool true)
)