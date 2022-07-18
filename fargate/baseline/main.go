package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

var greeting = map[string]string{
	"hello": "world",
}

func homePage(w http.ResponseWriter, r *http.Request) {

	jsonString, err := json.Marshal(greeting)
	fmt.Fprintf(w, string(jsonString))

	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Endpoint Hit: homePage")
}

func main() {
	http.HandleFunc("/", homePage)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
