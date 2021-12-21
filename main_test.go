package main

import "testing"

func TestAdd(t *testing.T) {
	type args struct {
		a int
		b int
	}
	cases := []struct {
		name string
		args args
		want int
	}{
		{
			name: "success",
			args: args{a: 1, b: 2},
			want: 3,
		},
		{
			name: "failed",
			args: args{a: 1, b: 3},
			want: 4,
		},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			if got := add(c.args.a, c.args.b); got != c.want {
				t.Errorf("got=%v, want=%v", got, c.want)
			}
		})
	}
}
