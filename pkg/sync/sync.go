package sync

import (
	"os"

	"github.com/rs/zerolog"
	"github.com/urfave/cli"
)

var GenerateCommand = cli.Command{
	Name:   "sync",
	Usage:  "sync token validity",
	Action: sync,
	Flags: []cli.Flag{
		// Add the OVH_CREATE_TOKEN_ENDPOINT flag here
		&cli.StringFlag{
			Name:  "provider",
			Usage: "Specify the external secret store provider",
			Value: "",
		},
	},
}

var logger = zerolog.New(os.Stdout).With().Timestamp().Logger()

func sync(clicontext *cli.Context) error {
	provider := clicontext.String("provider")
	logger.Info().Msgf("Using provider: %s", provider)
	return nil
}
