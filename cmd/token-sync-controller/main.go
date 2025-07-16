package main

import (
	"log/slog"
	"os"

	"github.com/urfave/cli"
	"github.com/wiremind/token-sync-controller/pkg/cmd"
	"github.com/wiremind/token-sync-controller/pkg/sync"
)

func main() {
	var exitValue int

	app := cli.NewApp()
	app.Name = "token-sync-controller"
	app.Usage = "Sync token validity between Kubernetes and external secret stores"
	app.Version = cmd.Version

	app.Flags = []cli.Flag{
		cli.IntFlag{
			Name:        "exit, e",
			Value:       1,
			Usage:       "value returned on error",
			Destination: &exitValue,
		},
	}

	app.Commands = []cli.Command{
		sync.GenerateCommand,
	}

	err := app.Run(os.Args)
	if err != nil {
		slog.Error(
			"main() error",
			slog.String("error", err.Error()),
		)
		os.Exit(exitValue)
	}
}
