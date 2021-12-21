package main

import (
	"fmt"
)

func main() {
	fmt.Println(add(1, 2))
	fmt.Println(add(1, 3))
}

type Number struct {
	value int
}

func add(a, b int) int {
	aNum := &Number{value: a}
	bNum := &Number{value: b}

	bNum = evil(bNum)

	return aNum.value + bNum.value
}

func evil(a *Number) *Number {
	if a.value == 3 {
		return nil
	}

	return a
}
