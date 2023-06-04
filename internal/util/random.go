package util

import (
	"math/rand"
	"strings"
	"time"
)

const alphabet = "abcdefghijklmnopqrstuvwxyz"

var r *rand.Rand

func init() {
	// set seed
	// 1. create new source
	src := rand.NewSource(time.Now().UnixNano())
	// 2. create new random generator
	r = rand.New(src)
}

func NewRandomInt(min, max int64) int64 {
	return min + r.Int63n(max-min+1)
}

func NewRandomString(n int) string {
	var sb strings.Builder
	k := len(alphabet)
	for i := 0; i < n; i++ {
		c := alphabet[r.Intn(k)]
		sb.WriteByte(c)
	}
	return sb.String()
}

func RandomOwner() string {
	return NewRandomString(6)
}

func RandomMoney() int64 {
	return NewRandomInt(0, 1000)
}

func RandomCurrency() string {
	currencies := []string{"USD", "EUR", "CAD"}
	n := len(currencies)
	return currencies[r.Intn(n)]
}
