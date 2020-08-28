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
	// Calculate adhan times
	calc := (&prayer.Calculator{
		Latitude:          -2.2307069,
		Longitude:         113.9301163,
		Elevation:         5,
		CalculationMethod: prayer.Kemenag,
		AsrConvention:     prayer.Shafii,
		PreciseToSeconds:  false,
		AngleCorrection: prayer.AngleCorrection{
			prayer.Fajr:    0.66667,
			prayer.Sunrise: -0.66667,
			prayer.Zuhr:    1,
			prayer.Asr:     0.66667,
			prayer.Maghrib: 0.75,
			prayer.Isha:    0.66667,
		},
	}).Init().SetDate(date)

	fajr := calc.Calculate(prayer.Fajr)
	sunrise := calc.Calculate(prayer.Sunrise)
	zuhr := calc.Calculate(prayer.Zuhr)
	asr := calc.Calculate(prayer.Asr)
	maghrib := calc.Calculate(prayer.Maghrib)
	isha := calc.Calculate(prayer.Isha)
	nextFajr := fajr.AddDate(0, 0, 1)

	// Calculate iqamah times
	iqamahFajr := fajr.Add(20 * time.Minute)
	iqamahZuhr := zuhr.Add(15 * time.Minute)
	iqamahAsr := asr.Add(10 * time.Minute)
	iqamahMaghrib := maghrib.Add(10 * time.Minute)
	iqamahIsha := isha.Add(10 * time.Minute)
	iqamahNextFajr := nextFajr.Add(20 * time.Minute)

	return []PrayerData{
		createPrayerData("Subuh", fajr, iqamahFajr, false),
		createPrayerData("Syuruq", sunrise, sunrise, false),
		createPrayerData("Zuhur", zuhr, iqamahZuhr, false),
		createPrayerData("Ashar", asr, iqamahAsr, false),
		createPrayerData("Maghrib", maghrib, iqamahMaghrib, false),
		createPrayerData("Isha", isha, iqamahIsha, false),
		createPrayerData("Subuh", nextFajr, iqamahNextFajr, true),
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
