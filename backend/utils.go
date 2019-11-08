package backend

import (
	"bytes"
	"encoding/json"
	"image"
	"os"

	// We only want to check jpeg image
	_ "image/jpeg"
)

var indonesianDays = []string{
	"Minggu",
	"Senin",
	"Selasa",
	"Rabu",
	"Kamis",
	"Jumat",
	"Sabtu",
}

func getDayName(weekDay int) string {
	if weekDay >= 0 && weekDay <= 6 {
		return indonesianDays[weekDay]
	}

	return ""
}

func getMonthName(month int) string {
	switch month {
	case 1:
		return "Januari"
	case 2:
		return "Februari"
	case 3:
		return "Maret"
	case 4:
		return "April"
	case 5:
		return "Mei"
	case 6:
		return "Juni"
	case 7:
		return "Juli"
	case 8:
		return "Agustus"
	case 9:
		return "September"
	case 10:
		return "Oktober"
	case 11:
		return "November"
	case 12:
		return "Desember"
	}

	return ""
}

func getHijriMonthName(month int) string {
	switch month {
	case 1:
		return "Muharram"
	case 2:
		return "Safar"
	case 3:
		return "Rabiul Awal"
	case 4:
		return "Rabiul Akhir"
	case 5:
		return "Jumadil Awal"
	case 6:
		return "Jumadil Akhir"
	case 7:
		return "Rajab"
	case 8:
		return "Sya'ban"
	case 9:
		return "Ramadhan"
	case 10:
		return "Syawal"
	case 11:
		return "Dzulkaidah"
	case 12:
		return "Dzulhijjah"
	}

	return ""
}

func imageIsJPG(imgPath string) bool {
	imgFile, err := os.Open(imgPath)
	if err != nil {
		return false
	}
	defer imgFile.Close()

	_, format, err := image.DecodeConfig(imgFile)
	if err != nil {
		return false
	}

	return format == "jpeg"
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
