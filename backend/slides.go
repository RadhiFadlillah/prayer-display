package backend

import (
	"fmt"
	"image"
	"os"

	dc "github.com/cenkalti/dominantcolor"
	"github.com/lucasb-eyer/go-colorful"

	// We only want to check jpeg image
	_ "image/jpeg"
)

// ImageSlide is data for an image slide
type ImageSlide struct {
	Path        string `json:"path"`
	MainColor   string `json:"mainColor"`
	AccentColor string `json:"accentColor"`
	FontColor   string `json:"fontColor"`
}

func createImageSlide(imgPath string) (ImageSlide, error) {
	// Open image
	imgFile, err := os.Open(imgPath)
	if err != nil {
		return ImageSlide{}, fmt.Errorf("failed to open image: %w", err)
	}
	defer imgFile.Close()

	// Make sure it's jpeg
	img, format, err := image.Decode(imgFile)
	if err != nil {
		return ImageSlide{}, fmt.Errorf("failed to decode image: %w", err)
	}

	if format != "jpeg" {
		return ImageSlide{}, fmt.Errorf("image is not jpeg")
	}

	// Get dominant color as main
	dominantColor, ok := colorful.MakeColor(dc.Find(img))
	if !ok {
		return ImageSlide{}, fmt.Errorf("failed to get dominant color")
	}

	// Get complementary color as accent
	h, _, l := dominantColor.Hsl()
	h -= 180
	if h < 0 {
		h += 360
	}

	complementaryColor := colorful.Hsl(h, 1, l)

	// Get font color depending on lightness
	fontColor := "#000"
	if l <= 0.5 {
		fontColor = "#FFF"
	}

	return ImageSlide{
		Path:        imgPath,
		MainColor:   dominantColor.Hex(),
		AccentColor: complementaryColor.Hex(),
		FontColor:   fontColor,
	}, nil
}
