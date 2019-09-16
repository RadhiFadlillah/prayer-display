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

	_ func()       `slot:"start"`
	_ func(string) `signal:"clockChanged"`
	_ func(string) `signal:"dateChanged"`
}

func (b *Display) start() {
	go b.startDateTicker()
	go b.startClockTicker()
}

func (b *Display) startClockTicker() {
	for now := range time.Tick(time.Second) {
		b.clockChanged(now.Format("15:04:05"))
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
		b.dateChanged(strDate)

		// Sleep until next day
		nextDate := date.AddDate(0, 0, 1)
		nextDate = time.Date(nextDate.Year(), nextDate.Month(), nextDate.Day(),
			0, 0, 1, 0, nextDate.Location())
		duration := nextDate.Sub(date)

		time.Sleep(duration)
	}
}

func getDayName(weekDay int) string {
	switch weekDay {
	case 1:
		return "Senin"
	case 2:
		return "Selasa"
	case 3:
		return "Rabu"
	case 4:
		return "Kamis"
	case 5:
		return "Jumat"
	case 6:
		return "Sabtu"
	case 7:
		return "Minggu"
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
