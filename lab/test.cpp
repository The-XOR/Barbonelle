#include <wiringPi.h>
#include <stdio.h>
typedef unsigned long uint32_t;
typedef unsigned char uint8_t;

// GPIO pin defs
#define LEDG 22          
#define LEDR 23       
#define LEDB  27

#define ENCODER_DT  6
#define ENCODER_CLK  7
#define ENCODER_BTN  5

#define AUX_LED_RED_OFF digitalWrite(LEDR,HIGH);
#define AUX_LED_RED_ON digitalWrite(LEDR,LOW);
#define AUX_LED_GREEN_OFF digitalWrite(LEDG,HIGH);
#define AUX_LED_GREEN_ON digitalWrite(LEDG,LOW);
#define AUX_LED_BLUE_OFF digitalWrite(LEDB,HIGH);
#define AUX_LED_BLUE_ON digitalWrite(LEDB,LOW);

        uint32_t encBut;
        uint32_t encButFlag;
        uint32_t encTurn;
        uint32_t encTurnFlag;
        uint32_t knobFlag;

uint32_t readEncoder()
{
	int rv = digitalRead(ENCODER_BTN) ? 0x10 : 0;
	rv +=  digitalRead(ENCODER_DT) ? 0 : 0x20;
	rv +=  digitalRead(ENCODER_CLK) ? 0 : 0x40;
	return rv;
}

void getEncoder(uint32_t pinValues)
{
	static uint8_t encoder_last = 0;

	#define PRESS 0
	#define RELEASE 1
	static uint8_t button_last = RELEASE;
	static uint8_t press_count = 0;
	static uint8_t release_count = 0;

	uint8_t button = (pinValues >> 4) & 0x1;
	if (button == PRESS) {
		press_count++;
		release_count = 0;
	
		if ((press_count > 10) && (button_last == RELEASE)){	// press
				button_last = PRESS;
				release_count = 0;
				encBut = 1;
				encButFlag = 1;
		}
	} else if (button == RELEASE) {
		release_count++;
		press_count = 0;
	
		if ((release_count > 10) && (button_last == PRESS)){	// release
				button_last = RELEASE;
				press_count = 0;
				encBut = 0;
				encButFlag = 1;
		}
	}

	// turning
	uint8_t encoder = (pinValues >> 5) & 0x3;
	
    if (encoder != encoder_last) {
		bool oldclk = (encoder_last & 0x02) > 0;
		bool newclk = (encoder & 0x02) > 0; 
		if (oldclk  && !newclk) // verifica se il pin clock e' passato da HIGH a LOW
 		{ 
			 encTurn = (encoder_last & 0x01);
             encTurnFlag = 1;
        }
        encoder_last = encoder;
	}
}

int main()
{
	wiringPiSetupGpio();
	pinMode(LEDB, OUTPUT);
	pinMode(LEDG, OUTPUT);
	pinMode(LEDR, OUTPUT);

    pinMode(ENCODER_BTN, INPUT);
    pinMode(ENCODER_DT, INPUT);
    pinMode(ENCODER_CLK, INPUT);
    pullUpDnControl(ENCODER_BTN, PUD_DOWN);
    pullUpDnControl(ENCODER_DT, PUD_DOWN);
    pullUpDnControl(ENCODER_CLK, PUD_DOWN);

    puts("press encoder key");
	int sum =0;
	while(true)
	{
		getEncoder(readEncoder());
		if (encButFlag) 
		{
			puts("Encoder button down");
		}
        if (encTurnFlag) 
		{
			sum += encTurn == 0 ? -1 : 1;
			printf("Encoder turn %i SUM=%i\n", encTurn, sum);
		}
         encButFlag = 0;
    encTurnFlag = 0;
	}

	/*
	while(true)
{
	AUX_LED_RED_ON;
	delay(1000);

    AUX_LED_RED_OFF
    delay(2000);
}
*/
return 0;
}
