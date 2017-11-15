package main

import (
	"regexp"
	"testing"
)

func TestVersion(t *testing.T) {

	version := getVersion()

	matched, err := regexp.MatchString(`^[0-9]+.[0-9]+.[0-9]+`, string(version))
	if err != nil {
		t.Errorf("%v", err)
	} else if !matched {
		t.Errorf("vertion should n.n.n format: %s", string(version))
	}
}
