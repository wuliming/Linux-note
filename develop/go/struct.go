package main

import (
	"fmt"
)

type Person struct {
	Name string
	Age  int
}

/* - ref
 *   https://www.cnblogs.com/skymyyang/p/7675488.html
 * - output
 *    {jack 19}
 *    {wlm 32}
 *    {jack 19}
 *    {wlm1 32}
 *    {wlm1 32}
 */
func main() {
	a := Person{
		Name: "jack",
		Age:  19,
	}
	fmt.Println(a)

	b := Person{}
	b.Name = "wlm"
	b.Age = 32
	fmt.Println(b)

	ValueCopy(a)
	fmt.Println(a)

	PointCopy(&a)
	fmt.Println(a)
	PointCopy(&b)
	fmt.Println(b)
}

func ValueCopy(per Person) {
	per.Name = "wlm1"
	per.Age = 32
}

func PointCopy(per *Person) {
	per.Name = "wlm1"
	per.Age = 32
}
