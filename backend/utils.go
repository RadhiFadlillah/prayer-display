package backend

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
