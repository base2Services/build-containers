package main

import (
    "fmt"
    "os"
    "io"
    "log"
    "io/ioutil"
)

// This script implements the unix cat.
func cat(r io.Reader) ([]byte, error) {
    data, err := ioutil.ReadAll(r);
    if (err != nil) {
        return nil, err
    }
    return data, nil
}

func main() {
    var output []byte
    var err error
    args := os.Args[1:]
    if len(args) > 0 {
        for _, file := range args {
            data, err := os.Open(file)
            defer data.Close()
            if err != nil {
                log.Panic(err)
            }
            output, err = cat(data)
            if err != nil {
                log.Panic(err)
            }
            fmt.Print(string(output))
        }
    } else {
        output, err = cat(os.Stdin)
        if err != nil {
            log.Panic(err)
        }
        fmt.Print(string(output))
    }
}