-- name: GetAccount :one
SELECT * FROM accounts WHERE id = $1;

-- name: GetAccountByOwner :one
SELECT * FROM accounts WHERE owner = $1;

-- name: CreateAccount :one
INSERT INTO accounts (owner, balance, currency) VALUES ($1, $2, $3) RETURNING *;

-- name: ListAccounts :many
SELECT * FROM accounts ORDER BY id LIMIT $1 OFFSET $2;

-- name: CreateEntry :one
INSERT INTO entries (account_id, amount) VALUES ($1, $2) RETURNING *;

-- name: ListEntries :many
SELECT * FROM entries WHERE account_id = $1 ORDER BY id LIMIT $2 OFFSET $3;

-- name: CreateTransfer :one
INSERT INTO transfers (from_account_id, to_account_id, amount) VALUES ($1, $2, $3) RETURNING *;

-- name: ListTransfers :many
SELECT * FROM transfers WHERE from_account_id = $1 OR to_account_id = $1 ORDER BY id LIMIT $2 OFFSET $3;

-- name: GetTransfer :one
SELECT * FROM transfers WHERE id = $1;

-- name: GetTransfersByIDs :one
SELECT * FROM transfers WHERE from_account_id = $1 AND to_account_id = $2;

-- name: GetTransfersByIDsForUpdate :one
SELECT * FROM transfers WHERE from_account_id = $1 AND to_account_id = $2 FOR UPDATE;

-- name: UpdateAccountBalance :exec
UPDATE accounts SET balance = balance + $1 WHERE id = $2;

-- name: UpdateAccountBalanceAndReturn :one
UPDATE accounts SET balance = $2 WHERE id = $1 RETURNING *;

-- name: DeleteAccount :exec
DELETE FROM accounts WHERE id = $1;

-- name: DeleteEntry :exec
DELETE FROM entries WHERE id = $1;

-- name: DeleteTransfer :exec
DELETE FROM transfers WHERE id = $1;

-- name: DeleteAllAccounts :exec
DELETE FROM accounts;

-- name: DeleteAllEntries :exec
DELETE FROM entries;

-- name: DeleteAllTransfers :exec
DELETE FROM transfers;

-- name: GetBalanceById :one
SELECT balance FROM accounts WHERE id = $1;

-- name: GetBalanceByOwner :one
SELECT balance FROM accounts WHERE owner = $1;

-- name: GetBalanceByIdForUpdate :one
SELECT balance FROM accounts WHERE id = $1 FOR UPDATE;

-- name: GetBalanceByOwnerForUpdate :one
SELECT balance FROM accounts WHERE owner = $1 FOR UPDATE;

-- name: GetBalanceByIDsForUpdate :one
SELECT balance FROM accounts WHERE id IN ($1, $2) FOR UPDATE;

-- name: GetBalanceByOwnersForUpdate :one
SELECT balance FROM accounts WHERE owner IN ($1, $2) FOR UPDATE;
