package main

import (
	"fmt"

	"github.com/digital-dream-labs/vector-cloud/internal/ipc"
)

type cladClient struct {
	conn ipc.Conn
}

func (c *cladClient) connect(socketName string) error {
	name := ipc.GetSocketPath(socketName)

	var err error
	c.conn, err = ipc.NewUnixgramClient(name, "cli")
	if err != nil {
		fmt.Println("Couldn't create socket", name, ":", err)
	}

	return err
}

func (c *cladClient) close() {
	c.conn.Close()
}
