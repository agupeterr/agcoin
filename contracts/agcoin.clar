;; AGCOIN fungible token example contract

(define-constant ERR-INVALID-AMOUNT u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)

(define-data-var total-supply uint u0)

(define-map balances
  { account: principal }
  { amount: uint })

(define-data-var token-name (string-ascii 32) "Agcoin")
(define-data-var token-symbol (string-ascii 10) "AGC")
(define-data-var token-decimals uint u6)

(define-read-only (get-name)
  (ok (var-get token-name)))

(define-read-only (get-symbol)
  (ok (var-get token-symbol)))

(define-read-only (get-decimals)
  (ok (var-get token-decimals)))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-balance (owner principal))
  (ok (default-to u0 (get amount (map-get? balances { account: owner })))))

(define-private (is-valid-amount (amount uint))
  (not (is-eq amount u0)))

(define-private (internal-transfer (sender principal) (recipient principal) (amount uint))
  (let (
        (sender-balance (default-to u0 (get amount (map-get? balances { account: sender }))))
        (recipient-balance (default-to u0 (get amount (map-get? balances { account: recipient }))))
       )
    (if (< sender-balance amount)
        (err ERR-INSUFFICIENT-BALANCE)
        (begin
          (map-set balances { account: sender } { amount: (- sender-balance amount) })
          (map-set balances { account: recipient } { amount: (+ recipient-balance amount) })
          (ok true)))))

;; Public Functions

;; Permissionless mint for demonstration purposes. Any caller can mint new AGC
;; to any principal. This is NOT suitable for production use.
(define-public (mint (amount uint) (recipient principal))
  (if (not (is-valid-amount amount))
      (err ERR-INVALID-AMOUNT)
      (let ((recipient-balance (default-to u0 (get amount (map-get? balances { account: recipient }))))
            (current-supply (var-get total-supply)))
        (begin
          (map-set balances { account: recipient } { amount: (+ recipient-balance amount) })
          (var-set total-supply (+ current-supply amount))
          (ok true)))))

(define-public (transfer (recipient principal) (amount uint))
  (if (not (is-valid-amount amount))
      (err ERR-INVALID-AMOUNT)
      (internal-transfer tx-sender recipient amount)))
