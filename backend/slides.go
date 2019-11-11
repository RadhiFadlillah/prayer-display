package backend

import (
	"fmt"
	"image"
	"os"

	"github.com/disintegration/imaging"
	"github.com/lucasb-eyer/go-colorful"
	ce "github.com/marekm4/color-extractor"

	// We only want to check jpeg image
	_ "image/jpeg"
)

// ImageSlide is data for an image slide
type ImageSlide struct {
	Path string `json:"path"`

	HeaderFont   string `json:"headerFont"`
	HeaderMain   string `json:"headerMain"`
	HeaderAccent string `json:"headerAccent"`

	FooterFont   string `json:"footerFont"`
	FooterMain   string `json:"footerMain"`
	FooterAccent string `json:"footerAccent"`
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

	// Get header and footer of image
	imgSize := img.Bounds().Size()
	headerHeight := int(float64(imgSize.X) / 1600.0 * 80.0)
	footerHeight := int(float64(imgSize.X) / 1600.0 * 160.0)

	headerPart := imaging.CropAnchor(img, imgSize.X, headerHeight, imaging.TopLeft)
	footerPart := imaging.CropAnchor(img, imgSize.X, footerHeight, imaging.BottomLeft)

	// Get color palette
	headerMain, headerAccent, headerFont := getColorPalette(headerPart)
	footerMain, footerAccent, footerFont := getColorPalette(footerPart)

	return ImageSlide{
		Path: imgPath,

		HeaderFont:   headerFont,
		HeaderMain:   headerMain,
		HeaderAccent: headerAccent,

		FooterFont:   footerFont,
		FooterMain:   footerMain,
		FooterAccent: footerAccent,
	}, nil
}

func getColorPalette(img image.Image) (main, accent, font string) {
	// Get color palettes
	colors := ce.ExtractColors(img)

	// Get dominant color as main
	mainColor, ok := colorful.MakeColor(colors[0])
	if !ok {
		return "#000", "#000", "#000"
	}

	// Get complementary color as accent
	h, _, l := mainColor.Hsl()
	h -= 180
	if h < 0 {
		h += 360
	}

	if l >= 0.9 {
		l -= 0.2
	}

	if l <= 0.1 {
		l += 0.2
	}

	accentColor := colorful.Hsl(h, 1, l)

	// Get font color depending on lightness
	fontColor := "#000"
	if l <= 0.5 {
		fontColor = "#FFF"
	}

	return mainColor.Hex(), accentColor.Hex(), fontColor
}
