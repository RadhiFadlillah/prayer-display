package main

import (
	"os"

	_ "prayer-display/backend"
)

func main() {
	runQtApp(len(os.Args), os.Args)
}
