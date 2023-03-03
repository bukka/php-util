// Copyright 2022 Jakob Ackermann <das7pad@outlook.com>. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found at https://github.com/golang/go/blob/master/LICENSE
package main

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/textproto"
	"time"
)

func main() {
	nParts := flag.Int("n-parts", 5555555, "number of parts")
	nRequests := flag.Int("n-requests", 1, "number of total requests")
	c := flag.Int("concurrency", 1, "number of concurrent requests")
	partBodySize := flag.Int("part-body-size", 0, "part body size")
	createFieldParts := flag.Bool("create-field-parts", false, "create field parts")
	createFileParts := flag.Bool("create-file-parts", false, "create file parts")
	target := flag.String("target", "http://127.0.0.1:8080", "target")
	flag.Parse()

	b := bytes.NewBuffer(nil)
	w := multipart.NewWriter(b)
	if err := w.SetBoundary("B"); err != nil {
		panic(err)
	}

	h := textproto.MIMEHeader{}
	if *createFieldParts {
		h.Set("Content-Disposition", "form-data;name=N")
	} else if *createFileParts {
		h.Set("Content-Disposition", "form-data;name=N;filename=F")
	}
	partBody := bytes.Repeat([]byte{42}, *partBodySize)
	for i := 0; i < *nParts; i++ {
		p, err := w.CreatePart(h)
		if err != nil {
			panic(err)
		}
		if _, err = p.Write(partBody); err != nil {
			panic(err)
		}
	}
	if err := w.Close(); err != nil {
		panic(err)
	}
	fmt.Println("Number of parts:", *nParts)
	fmt.Println("Request body size:", b.Len())

	work := make(chan int, *nRequests)
	for i := 0; i < *nRequests; i++ {
		work <- i
	}
	close(work)
	completed := make(chan int, *nRequests)
	t0 := time.Now()
	for i := 0; i < *c; i++ {
		go func() {
			for task := range work {
				t1 := time.Now()
				body := bytes.NewReader(b.Bytes())
				ct := "multipart/form-data; boundary=B"
				r, err := http.Post(*target, ct, body)
				if err != nil {
					panic(err)
				}
				fmt.Println(task, "Duration:", time.Since(t1))
				fmt.Println(task, "StatusCode:", r.StatusCode)
				fmt.Println(task, "Header:", r.Header)
				blob, err := io.ReadAll(r.Body)
				if err != nil {
					panic(err)
				}
				fmt.Println(task, "Response Body:", string(blob))
				if err = r.Body.Close(); err != nil {
					panic(err)
				}
				completed <- task
			}
		}()
	}
	for pending := *nRequests; pending > 0; pending-- {
		<-completed
	}
	fmt.Println("Total Duration:", time.Since(t0))
}