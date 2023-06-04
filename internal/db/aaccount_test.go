package db

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/mkm29/simple_bank/internal/util"
	"github.com/stretchr/testify/require"
)

func createRandomAccount() (Account, error) {
	arg := CreateAccountParams{
		Owner:    util.RandomOwner(),
		Balance:  util.RandomMoney(),
		Currency: util.RandomCurrency(),
	}
	return testQueries.CreateAccount(context.Background(), arg)
}

func TestCreateAccount(t *testing.T) {
	// create random account
	account, err := createRandomAccount()
	require.NoError(t, err)
	require.NotEmpty(t, account)
	require.NotZero(t, account.ID)
	require.NotZero(t, account.CreatedAt)
}

func TestGetAccount(t *testing.T) {
	account1, error := createRandomAccount()
	require.NoError(t, error)
	require.NotEmpty(t, account1)
	account2, err := testQueries.GetAccount(context.Background(), account1.ID)
	require.NoError(t, err)
	require.Equal(t, account1.ID, account2.ID)
	require.Equal(t, account1.Owner, account2.Owner)
	require.Equal(t, account1.Balance, account2.Balance)
	require.WithinDuration(t, account1.CreatedAt, account2.CreatedAt, time.Second)
}

func TestUpdateAccountBalance(t *testing.T) {
	account, error := createRandomAccount()
	require.NoError(t, error)
	require.NotEmpty(t, account)
	// update account
	arg := UpdateAccountBalanceParams{
		ID:      account.ID,
		Balance: util.RandomMoney(),
	}
	updatedAccount, err := testQueries.UpdateAccountBalance(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, updatedAccount)
	require.Equal(t, account.ID, updatedAccount.ID)
	require.Equal(t, account.Owner, updatedAccount.Owner)
}

func TestDeleteAccount(t *testing.T) {
	account, error := createRandomAccount()
	require.NoError(t, error)
	require.NotEmpty(t, account)
	// delete account
	err := testQueries.DeleteAccount(context.Background(), account.ID)
	require.NoError(t, err)
	// get account
	account2, err := testQueries.GetAccount(context.Background(), account.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, account2)
}

func TestListAccount(t *testing.T) {
	for i := 0; i < 10; i++ {
		createRandomAccount()
	}
	arg := ListAccountsParams{
		Limit:  5,
		Offset: 5,
	}
	accounts, err := testQueries.ListAccounts(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, accounts, 5)
	for _, account := range accounts {
		require.NotEmpty(t, account)
	}
}
