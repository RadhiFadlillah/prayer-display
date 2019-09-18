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

// Display is back end for the app.
type Display struct {
	qamel.QmlObject

	_ func()               `slot:"start"`
	_ func(string, int)    `signal:"clockChanged"`
	_ func(string, string) `signal:"dateChanged"`
	_ func(string)         `signal:"imageChanged"`
}

func (b *Display) start() {
	go b.startDateTicker()
	go b.startClockTicker()
	go b.startImageSlides()
}

func (b *Display) startClockTicker() {
	for {
		now := time.Now()
		seconds := now.Hour()*3600 + now.Minute()*60 + now.Second()
		b.clockChanged(now.Format("15:04:05"), seconds)

		time.Sleep(time.Second)
	}
}

func (b *Display) startDateTicker() {
	for {
		// Generate date value to show
		date := time.Now()
		hYear, hMonth, hDay, _ := hijri.ToUmmAlQura(date)

		dayName := getDayName(int(date.Weekday()))
		monthName := getMonthName(int(date.Month()))
		hMonthName := getHijriMonthName(hMonth)

		strDate := fmt.Sprintf("%s, %d %s %d M / %d %s %d H", dayName,
			date.Day(), monthName, date.Year(),
			hDay, hMonthName, hYear)

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

func (b *Display) startImageSlides() {
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
