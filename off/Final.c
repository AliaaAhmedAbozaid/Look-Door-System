#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <eeprom.h>
#include <stddef.h>
unsigned char keypad();
unsigned char EE_Read(unsigned int address);            //function to read from eeprom
void EE_Write(unsigned int address, unsigned int data);//function to write in eeprom
void Store();
int  checkID(unsigned int id);                                  //function to check id
int checkPASS(unsigned int id, unsigned int pass);                              //function to check pass
int changePASS(unsigned int id, unsigned int npass);                             //function to change pass
int check_PASS_Admin(unsigned int pass);                                           //function to check pass of admin
int read();
int pass_sure;
void peep();
int n;
void main(void)
{


    DDRB = 0b00000111;
    PORTB = 0b11111000;
    //DDRB.0 = 1;
    DDRC.1 = 1; 
    PORTC.1 = 0;
    DDRD.4 = 1;
    PORTD.4 = 0;

    //PORTC.0=0;
    DDRD.2 = 0;
    PORTD.2 = 1;
    DDRD.3 = 0;
    PORTD.3 = 1;
    SREG.7 = 1;
    MCUCR |= (1 << 1);  //falling
    MCUCR |= (1 << 3);  //falling
    MCUCR &= ~(1 << 0);
    MCUCR &= ~(1 << 2);
    GICR |= (1 << 6);//intrrupt_0
    GICR |= (1 << 7);//intrrupt_1
    DDRD.5 = 1;
    PORTD.5 = 0;





    //...end */
    lcd_init(16);

    lcd_puts("press * to start,please");
    //Store();
    while (1)
        {
        char num = keypad();
        int c1 = 0;
        int c2 = 0;
        lcd_clear();

        if(num == '*')
            { 
            
            PORTC.1 = 0;
            PORTD.4=0;

            lcd_puts("Enter your ID");

            c1 = read();
            delay_ms(500);
            lcd_clear();

            if(checkID(c1) == 1)
                {
                lcd_clear();
                lcd_puts("Enter your PC");

                c2 = read();
                delay_ms(500);
                lcd_clear();
                if(checkPASS(c1, c2) == 1)
                    {
                    switch(c1)
                        {
                        case 111:
                            lcd_puts("Welcome, Prof ");
                            break;
                        case 126:

                            lcd_puts("Welcome, Ahmed ");
                            break;
                        case 128:
                            lcd_puts("Welcome, Amr ");
                            break;
                        case 130:
                            lcd_puts("Welcome, Adel ");
                            break;
                        case 132:
                            lcd_puts("Welcome, Omar ");
                            break;
                        }
                    delay_ms(500);
                    lcd_clear();
                    PORTD.4=1;
                    delay_ms(1500);
                    lcd_puts("Door is open");
                    PORTD.4=0;
                    



                    }
                else
                    {
                    lcd_puts("Sorry wrong password ");
                    delay_ms(500);
                    lcd_clear();

                    PORTC.1 = 1;
                    delay_ms(2000);
                    PORTC.1 = 0;     //one peep instead of turning on lamp
                    delay_ms(2000);
                    }
                }

            else
                {
                lcd_puts("Sorry wrong ID ");
                delay_ms(1000);
                peep();
                }
            }
        }

}
// Function to read keypress from the keypad

unsigned char keypad()
{
    while(1)
        {
        PORTB.0 = 0; PORTB.1 = 1; PORTB.2 = 1;
        //Only B1 is activated
        switch(PINB)
            {
            case 0b11110110:
                while (PINB.3 == 0);
                return 1;
                break;

            case 0b11101110:
                while (PINB.4 == 0);
                return 4;
                break;

            case 0b11011110:
                while (PINB.5 == 0);
                return 7;
                break;

            case 0b10111110:
                while (PINB.6 == 0);
                return '*';
                break;

            }
        PORTB.0 = 1; PORTB.1 = 0; PORTB.2 = 1;
        //Only B2 is activated
        switch(PINB)
            {
            case 0b11110101:
                while (PINB.3 == 0);
                return 2;
                break;

            case 0b11101101:
                while (PINB.4 == 0);
                return 5;
                break;

            case 0b11011101:
                while (PINB.5 == 0);
                return 8;
                break;

            case 0b10111101:
                while (PINB.6 == 0);
                return 0;
                break;

            }
        PORTB.0 = 1; PORTB.1 = 1; PORTB.2 = 0;
        //Only B3 is activated
        switch(PINB)
            {
            case 0b11110011:
                while (PINB.3 == 0);
                return 3;
                break;

            case 0b11101011:
                while (PINB.4 == 0);
                return 6;
                break;

            case 0b11011011:
                while (PINB.5 == 0);
                return 9;
                break;

            case 0b10111011:
                while (PINB.6 == 0);
                return '#';
                break;

            }

        }
}


 // Function to read from EEPROM

unsigned char EE_Read(unsigned int address)
{
    while(EECR.1 == 1);    //Wait till EEPROM is ready
    EEAR = address;        //Prepare the address you want to read from

    EECR.0 = 1;            //Execute read command

    return EEDR;

}

// Function to write in EEPROM
void EE_Write(unsigned int address, unsigned int data)
{
    while(EECR.1 == 1);    //Wait till EEPROM is ready
    EEAR = address;        //Prepare the address you want to read from
    EEDR = data;           //Prepare the data you want to write in the address above
    EECR.2 = 1;            //Master write enable
    EECR.1 = 1;            //Write Enable
}


// Interrupt service routine for INT0
interrupt [2]  void init_0(void)

{

    int pass = 0;
    int pass1 = 0;
    int new_pass = 0;
    int id = 0;

    lcd_clear();
    lcd_puts("Enter Admin PC");
    pass = read();


    delay_ms(500);
    lcd_clear();
    if(check_PASS_Admin(pass) == 1)
        {
        lcd_puts("Enter Student ID");

        id = read();
        delay_ms(500);
        lcd_clear();
        if(checkID(id) == 1)
            {
            lcd_puts("Enter new PC");

            pass = read();

            delay_ms(1000);
            delay_ms(500);
            lcd_clear();
            pass1 = pass / 10;
            new_pass = pass1 * 10 + pass % 10;

            changePASS(id, pass);


            delay_ms(500);
            lcd_clear();

            lcd_puts("PC is stored");
            delay_ms(1000);
            lcd_clear();
            }
        else
            {
            lcd_puts("ID is not found");
            peep();
            }

        }
    else
        {
        lcd_puts("Contact Admin");
        delay_ms(500);
        lcd_clear();
        peep();
        }


}

// Interrupt service routine for INT1
interrupt [3]  void init_1(void)
{


    int id = 0;
    int pass_new = 0;
    int new_pass1 = 0;
    int pass_old = 0;
    int pass2 = 0;
    SREG.7 = 1;
    lcd_clear();
    lcd_puts("Enter ID");
    id = read();
    delay_ms(500);
    lcd_clear();
    if(id == 111)
        {
        lcd_puts("you donnot have permission,Contact admin");
        peep();
        }
    else
        {
        if(checkID(id) == 0)
            {
            lcd_puts("contact admin"); delay_ms(500);
            peep();
            }
        else
            {
            lcd_puts("Enter old PC"); delay_ms(500);
            pass_old = read();


            delay_ms(500);
            lcd_clear();

            if(checkPASS(id, pass_old) != 1)
                {
                lcd_puts("Wrong pass,  Contact admin");
                peep();
                }
            else
                {
                lcd_puts("Enter new PC");


                delay_ms(1000);
                lcd_clear();

                pass_new = read();

                delay_ms(500);
                lcd_clear();
                lcd_puts("Renter PC");
                pass_sure = read();

                delay_ms(500);
                lcd_clear();
                if(pass_new == pass_sure)
                    {
                    pass2 = pass_new / 10;
                    new_pass1 = pass2 * 10 + pass_new % 10;


                    changePASS(id, pass_new);
                    lcd_puts("New PC stored");
                    delay_ms(500);
                    lcd_clear();
                    }
                else
                    {
                    lcd_puts("2 passwords arenot match,Contact admin");
                    peep();
                    delay_ms(500);
                    lcd_clear();
                    }


                }

            }
        }

}


void Store()
{
    EE_Write(111, 20); //devide  pass to 2 sections(2 bits ,1 bit)in 2 different Consecutive ids
    EE_Write(112, 3);

    EE_Write(126, 12);
    EE_Write(127, 9);

    EE_Write(128, 32);
    EE_Write(129, 5);

    EE_Write(130, 42);
    EE_Write(131, 6);

    EE_Write(132, 07);
    EE_Write(133, 9);


}

int checkID(unsigned int id)
{
    if(EE_Read(id) != 255)
        return 1;
    return 0;
}

int checkPASS(unsigned int id, unsigned int pass)
{
    if(EE_Read(id) == pass / 10 && EE_Read(id + 1) == pass % 10)
        return 1;
    return 0;
}
int check_PASS_Admin(unsigned int pass)
{
    int admin_id = 111;
    if(EE_Read(admin_id) == pass / 10 && EE_Read(admin_id + 1) == pass % 10)
        return 1;
    return 0;
}

 // Function to change password
int changePASS(unsigned int id, unsigned int npass)
{
    EE_Write(id, npass / 10);
    EE_Write(id + 1, npass % 10);
    return 1;

}
// Function to read multiple keypresses from the keypad
int read()
{
    int i = 3 , c = 0, c1 = 0;
    while(i)
        {
        c = keypad();

        lcd_clear();
        c1 = c1 * 10 + c;
        lcd_printf("%d ", c1);
        i = i - 1;
        }

    return c1;



}

 // Function to generate peep sounds
void peep()
{
    PORTC.1 = 1;
    delay_ms(1000);
    PORTC.1 = 0;         // two peeps instead of turning on lamp
    delay_ms(1000);
    PORTC.1 = 1;
    delay_ms(1000);
    PORTC.1 = 0;
    delay_ms(1000);
} 