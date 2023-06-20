package db

import (
	"database/sql"
	"os"
	"testing"

	_ "github.com/lib/pq"
)

const (
	dbDriver       = "postgres"
	dataSourceName = "postgresql://simplebank:secret@localhost:5432/simplebank?sslmode=disable"
)

var testQueries *Queries
var testDB *sql.DB
var err error

func TestMain(m *testing.M) {
	testDB, err = sql.Open(dbDriver, dataSourceName)
	if err != nil {
		panic("cannot connect to db:" + err.Error())
	}
	testQueries = New(testDB)
	os.Exit(m.Run())
}
