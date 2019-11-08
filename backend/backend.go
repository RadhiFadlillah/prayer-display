package backend

import (
	"fmt"
	"io/ioutil"
	"os"
	fp "path/filepath"
	"time"

	hijri "github.com/RadhiFadlillah/go-hijri"
	"github.com/RadhiFadlillah/qamel"
	"github.com/sirupsen/logrus"
)

func init() {
	RegisterQmlBackEnd("BackEnd", 1, 0, "BackEnd")
}

// BackEnd is back end for the app.
type BackEnd struct {
	qamel.QmlObject

	_ func()               `slot:"start"`
	_ func(string, int)    `signal:"clockChanged"`
	_ func(string, string) `signal:"dateChanged"`
	_ func(string)         `signal:"imageChanged"`
}

func (b *BackEnd) start() {
	go b.startDateTicker()
	go b.startClockTicker()
	go b.startImageSlides()
}

func (b *BackEnd) startClockTicker() {
	for {
		now := time.Now()
		seconds := now.Hour()*3600 + now.Minute()*60 + now.Second()
		b.clockChanged(now.Format("15:04:05"), seconds)

		time.Sleep(time.Second)
	}
}

func (b *BackEnd) startDateTicker() {
	for {
		// Generate date value to show
		date := time.Now()
		hYear, hMonth, hDay, _ := hijri.ToUmmAlQura(date)

		dayName := getDayName(int(date.Weekday()))
		strDate := fmt.Sprintf("%s, %02d-%02d-%04d M / %02d-%02d-%04d H", dayName,
			date.Day(), date.Month(), date.Year(),
			hDay, hMonth, hYear)

		// Get prayer data
		prayerData := getPrayerTime(date)

		// Encode data and send to UI
		jsonPrayerData, _ := encodeJSON(prayerData)
		b.dateChanged(strDate, jsonPrayerData)

		// Sleep until next day
		nextDay := date.AddDate(0, 0, 1)
		nextDay = time.Date(nextDay.Year(), nextDay.Month(), nextDay.Day(),
			0, 0, 1, 0, nextDay.Location())
		duration := nextDay.Sub(date)

		time.Sleep(duration)
	}
}

func (b *BackEnd) startImageSlides() {
	// Get executable directory
	exePath, err := os.Executable()
	if err != nil {
		logrus.WithError(err).Errorln("failed to find exe path")
	}
	exeDir := fp.Dir(exePath)

	// Read `display` directory
	imageDir := fp.Join(exeDir, "display")
	files, err := ioutil.ReadDir(imageDir)
	if err != nil {
		logrus.WithError(err).Errorln("failed to read image dir")
	}

	imageSlides := []string{}
	for _, file := range files {
		filePath := fp.Join(imageDir, file.Name())
		if imageIsJPG(filePath) {
			imageSlides = append(imageSlides, filePath)
		}
	}

	// Send image to GUI
	slideIndex := -1
	for {
		slideIndex++
		if slideIndex >= len(imageSlides) {
			slideIndex = 0
		}

		b.imageChanged(imageSlides[slideIndex])
		time.Sleep(30 * time.Second)
	}
}
