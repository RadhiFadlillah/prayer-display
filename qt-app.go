// +build !dev

package main

import (
	"os"

	"github.com/RadhiFadlillah/qamel"
)

func runQtApp(argc int, argv []string) {
	app := qamel.NewApplication(len(os.Args), os.Args)
	app.SetApplicationDisplayName("Prayer Display")
	app.SetWindowIcon(":/res/icon.png")

	view := qamel.NewViewer()
	view.SetSource("qrc:/res/main.qml")
	view.SetResizeMode(qamel.SizeRootObjectToView)
	view.SetHeight(600)
	view.SetWidth(800)
	view.ShowFullScreen()

	app.Exec()
}
