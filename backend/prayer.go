package backend

import (
	"time"

	"github.com/RadhiFadlillah/go-prayer"
)

// PrayerData is data that related to prayer time.
type PrayerData struct {
	Name   string `json:"name"`
	Adhan  string `json:"adhan"`
	Iqamah string `json:"iqamah"`
	Start  int    `json:"start"`
	Finish int    `json:"finish"`
}

func getPrayerTime(date time.Time) []PrayerData {
	cfg := prayer.Config{
		Latitude:          -2.20833,
		Longitude:         113.91667,
		Elevation:         45,
		CalculationMethod: prayer.Kemenag,
		AsrJuristicMethod: prayer.Shafii,
		PreciseToSeconds:  false,
		Corrections: prayer.TimeCorrections{
			Fajr:    2 * time.Minute,
			Sunrise: -time.Minute,
			Zuhr:    2 * time.Minute,
			Asr:     time.Minute,
			Maghrib: time.Minute,
			Isha:    time.Minute,
		},
		Iqamah: prayer.IqamahDelay{
			Fajr:    20 * time.Minute,
			Zuhr:    15 * time.Minute,
			Asr:     10 * time.Minute,
			Maghrib: 10 * time.Minute,
			Isha:    10 * time.Minute,
		},
	}

	nextDay := date.AddDate(0, 0, 1)
	adhan, iqamah := prayer.GetTimes(date, cfg)
	nextAdhan, nextIqamah := prayer.GetTimes(nextDay, cfg)

	return []PrayerData{
		createPrayerData("Subuh", adhan.Fajr, iqamah.Fajr, false),
		createPrayerData("Syuruq", adhan.Sunrise, adhan.Sunrise, false),
		createPrayerData("Zuhur", adhan.Zuhr, iqamah.Zuhr, false),
		createPrayerData("Ashar", adhan.Asr, iqamah.Asr, false),
		createPrayerData("Maghrib", adhan.Maghrib, iqamah.Maghrib, false),
		createPrayerData("Isha", adhan.Isha, iqamah.Isha, false),
		createPrayerData("Subuh", nextAdhan.Fajr, nextIqamah.Fajr, true),
	}
}

func createPrayerData(name string, adhanTime, iqamahTime time.Time, nextDay bool) PrayerData {
	strAdhan := adhanTime.Format("15:04")
	strIqamah := iqamahTime.Format("15:04")
	secondsAdhan := adhanTime.Hour()*3600 + adhanTime.Minute()*60 + adhanTime.Second()
	secondsIqamah := iqamahTime.Hour()*3600 + iqamahTime.Minute()*60 + iqamahTime.Second()
	if secondsIqamah < secondsAdhan {
		secondsIqamah = secondsAdhan
	}

	if nextDay {
		secondsAdhan += 86400
		secondsIqamah += 86400
	}

	return PrayerData{
		Name:   name,
		Adhan:  strAdhan,
		Iqamah: strIqamah,
		Start:  secondsAdhan,
		Finish: secondsIqamah,
	}
}
