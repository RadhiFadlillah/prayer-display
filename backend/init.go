package backend

import (
	"bytes"
	"encoding/json"
)

func init() {
	RegisterQmlDisplay("BackEnd", 1, 0, "Display")
}

func encodeJSON(src interface{}) (string, error) {
	bt, err := json.Marshal(src)
	return string(bt), err
}

func decodeJSON(jsonString string, dst interface{}) error {
	buffer := bytes.NewBufferString(jsonString)
	err := json.NewDecoder(buffer).Decode(dst)
	return err
}
