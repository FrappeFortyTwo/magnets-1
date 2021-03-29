// /* */ //

package main

import (
	"fmt"
	"log"
	"net/http"
//	"os"
//	"sort"
//	"strings"
	"github.com/0magnet/magnets/gorilla"
)

const port = 8040

func main() {

	fmt.Printf("listening on http://127.0.0.1:%d using gorilla router\n", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), gorilla.Serve))
}
