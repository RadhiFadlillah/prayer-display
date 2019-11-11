// +build ignore

package main

import (
	"log"
	"net/http"

	"github.com/shurcooL/vfsgen"
)

func main() {
	err := vfsgen.Generate(http.Dir("sounds"), vfsgen.Options{
		Filename:     "backend/assets.go",
		PackageName:  "backend",
		VariableName: "assets",
	})

	if err != nil {
		log.Fatalln(err)
	}
}
