#include "ssd1306_i2c.h"
#include <cstring>
#include <wiringPiI2C.h>

int _vccstate;
int i2cd;
void ssd1306_command(unsigned int c)
{
	// I2C
	unsigned int control = 0x00;	// Co = 0, D/C = 0
	wiringPiI2CWriteReg8(i2cd, control, c);
}

// Init SSD1306
void ssd1306_begin(unsigned int vccstate, unsigned int i2caddr)
{
	// I2C Init

	_vccstate = vccstate;

	i2cd = wiringPiI2CSetup(i2caddr);
	if (i2cd < 0) {
		return;
	}
	// Init sequence
	ssd1306_command(SSD1306_DISPLAYOFF);	// 0xAE
	ssd1306_command(SSD1306_SETDISPLAYCLOCKDIV);	// 0xD5
	ssd1306_command(0x80);	// the suggested ratio 0x80

	ssd1306_command(SSD1306_SETMULTIPLEX);	// 0xA8
	ssd1306_command(SSD1306_LCDHEIGHT - 1);

	ssd1306_command(SSD1306_SETDISPLAYOFFSET);	// 0xD3
	ssd1306_command(0x0);	// no offset
	ssd1306_command(SSD1306_SETSTARTLINE | 0x0);	// line #0
	ssd1306_command(SSD1306_CHARGEPUMP);	// 0x8D
	if (vccstate == SSD1306_EXTERNALVCC) {
		ssd1306_command(0x10);
	} else {
		ssd1306_command(0x14);
	}
	ssd1306_command(SSD1306_MEMORYMODE);	// 0x20
	ssd1306_command(0x00);	// 0x0 act like ks0108
	ssd1306_command(SSD1306_SEGREMAP | 0x1);
	ssd1306_command(SSD1306_COMSCANDEC);

	ssd1306_command(SSD1306_SETCOMPINS);	// 0xDA
	ssd1306_command(0x12);
	ssd1306_command(SSD1306_SETCONTRAST);	// 0x81
	if (vccstate == SSD1306_EXTERNALVCC) {
		ssd1306_command(0x9F);
	} else {
		ssd1306_command(0xCF);
	}

	ssd1306_command(SSD1306_SETPRECHARGE);	// 0xd9
	if (vccstate == SSD1306_EXTERNALVCC) {
		ssd1306_command(0x22);
	} else {
		ssd1306_command(0xF1);
	}
	ssd1306_command(SSD1306_SETVCOMDETECT);	// 0xDB
	ssd1306_command(0x40);
	ssd1306_command(SSD1306_DISPLAYALLON_RESUME);	// 0xA4
	ssd1306_command(SSD1306_NORMALDISPLAY);	// 0xA6

	ssd1306_command(SSD1306_DEACTIVATE_SCROLL);

	ssd1306_command(SSD1306_DISPLAYON);	// --turn on oled panel
}


void ssd1306_display(unsigned char *tmp)
{
	unsigned char buffer[1024];
	memcpy(buffer, tmp, 1024);
	ssd1306_command(SSD1306_COLUMNADDR);
	ssd1306_command(0);	// Column start address (0 = reset)
	ssd1306_command(SSD1306_LCDWIDTH - 1);	// Column end address (127 
	// = reset)

	ssd1306_command(SSD1306_PAGEADDR);
	ssd1306_command(0);	// Page start address (0 = reset)
	ssd1306_command(7);	// Page end address

	// I2C
	int i;
	for (i = 0; i < (SSD1306_LCDWIDTH * SSD1306_LCDHEIGHT / 8); i++) {
		wiringPiI2CWriteReg8(i2cd, 0x40, buffer[i]); 
		//This sends byte by byte. 
		//Better to send all buffer without 0x40 first
		//Should be optimized
	}
}
