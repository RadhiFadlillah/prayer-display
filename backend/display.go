package backend

import (
	"fmt"
	"time"

	hijri "github.com/RadhiFadlillah/go-hijri"
	"github.com/RadhiFadlillah/qamel"
)

// Display is back end for the app.
type Display struct {
	qamel.QmlObject

	_ func()               `slot:"start"`
	_ func(string, int)    `signal:"clockChanged"`
	_ func(string, string) `signal:"dateChanged"`
}

func (b *Display) start() {
	go b.startDateTicker()
	go b.startClockTicker()
}

func (b *Display) startClockTicker() {
	for now := range time.Tick(time.Second) {
		seconds := now.Hour()*3600 + now.Minute()*60 + now.Second()
		b.clockChanged(now.Format("15:04:05"), seconds)
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
