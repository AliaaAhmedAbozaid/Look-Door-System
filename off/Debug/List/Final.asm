
;CodeVisionAVR C Compiler V4.00a Evaluation
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _pass_sure=R4
	.DEF _pass_sure_msb=R5
	.DEF _n=R6
	.DEF _n_msb=R7
	.DEF __lcd_x=R9
	.DEF __lcd_y=R8
	.DEF __lcd_maxx=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _init_0
	JMP  _init_1
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x70,0x72,0x65,0x73,0x73,0x20,0x2A,0x20
	.DB  0x74,0x6F,0x20,0x73,0x74,0x61,0x72,0x74
	.DB  0x2C,0x70,0x6C,0x65,0x61,0x73,0x65,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x49,0x44,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x79,0x6F,0x75,0x72
	.DB  0x20,0x50,0x43,0x0,0x57,0x65,0x6C,0x63
	.DB  0x6F,0x6D,0x65,0x2C,0x20,0x50,0x72,0x6F
	.DB  0x66,0x20,0x0,0x57,0x65,0x6C,0x63,0x6F
	.DB  0x6D,0x65,0x2C,0x20,0x41,0x68,0x6D,0x65
	.DB  0x64,0x20,0x0,0x57,0x65,0x6C,0x63,0x6F
	.DB  0x6D,0x65,0x2C,0x20,0x41,0x6D,0x72,0x20
	.DB  0x0,0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65
	.DB  0x2C,0x20,0x41,0x64,0x65,0x6C,0x20,0x0
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x2C
	.DB  0x20,0x4F,0x6D,0x61,0x72,0x20,0x0,0x44
	.DB  0x6F,0x6F,0x72,0x20,0x69,0x73,0x20,0x6F
	.DB  0x70,0x65,0x6E,0x0,0x53,0x6F,0x72,0x72
	.DB  0x79,0x20,0x77,0x72,0x6F,0x6E,0x67,0x20
	.DB  0x70,0x61,0x73,0x73,0x77,0x6F,0x72,0x64
	.DB  0x20,0x0,0x53,0x6F,0x72,0x72,0x79,0x20
	.DB  0x77,0x72,0x6F,0x6E,0x67,0x20,0x49,0x44
	.DB  0x20,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x41,0x64,0x6D,0x69,0x6E,0x20,0x50,0x43
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x53
	.DB  0x74,0x75,0x64,0x65,0x6E,0x74,0x20,0x49
	.DB  0x44,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x6E,0x65,0x77,0x20,0x50,0x43,0x0,0x50
	.DB  0x43,0x20,0x69,0x73,0x20,0x73,0x74,0x6F
	.DB  0x72,0x65,0x64,0x0,0x49,0x44,0x20,0x69
	.DB  0x73,0x20,0x6E,0x6F,0x74,0x20,0x66,0x6F
	.DB  0x75,0x6E,0x64,0x0,0x43,0x6F,0x6E,0x74
	.DB  0x61,0x63,0x74,0x20,0x41,0x64,0x6D,0x69
	.DB  0x6E,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x49,0x44,0x0,0x79,0x6F,0x75,0x20,0x64
	.DB  0x6F,0x6E,0x6E,0x6F,0x74,0x20,0x68,0x61
	.DB  0x76,0x65,0x20,0x70,0x65,0x72,0x6D,0x69
	.DB  0x73,0x73,0x69,0x6F,0x6E,0x2C,0x43,0x6F
	.DB  0x6E,0x74,0x61,0x63,0x74,0x20,0x61,0x64
	.DB  0x6D,0x69,0x6E,0x0,0x63,0x6F,0x6E,0x74
	.DB  0x61,0x63,0x74,0x20,0x61,0x64,0x6D,0x69
	.DB  0x6E,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x6F,0x6C,0x64,0x20,0x50,0x43,0x0,0x57
	.DB  0x72,0x6F,0x6E,0x67,0x20,0x70,0x61,0x73
	.DB  0x73,0x2C,0x20,0x20,0x43,0x6F,0x6E,0x74
	.DB  0x61,0x63,0x74,0x20,0x61,0x64,0x6D,0x69
	.DB  0x6E,0x0,0x52,0x65,0x6E,0x74,0x65,0x72
	.DB  0x20,0x50,0x43,0x0,0x4E,0x65,0x77,0x20
	.DB  0x50,0x43,0x20,0x73,0x74,0x6F,0x72,0x65
	.DB  0x64,0x0,0x32,0x20,0x70,0x61,0x73,0x73
	.DB  0x77,0x6F,0x72,0x64,0x73,0x20,0x61,0x72
	.DB  0x65,0x6E,0x6F,0x74,0x20,0x6D,0x61,0x74
	.DB  0x63,0x68,0x2C,0x43,0x6F,0x6E,0x74,0x61
	.DB  0x63,0x74,0x20,0x61,0x64,0x6D,0x69,0x6E
	.DB  0x0,0x25,0x64,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x18
	.DW  _0x17
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x17+24
	.DW  _0x0*2+24

	.DW  0x0E
	.DW  _0x17+38
	.DW  _0x0*2+38

	.DW  0x0F
	.DW  _0x17+52
	.DW  _0x0*2+52

	.DW  0x10
	.DW  _0x17+67
	.DW  _0x0*2+67

	.DW  0x0E
	.DW  _0x17+83
	.DW  _0x0*2+83

	.DW  0x0F
	.DW  _0x17+97
	.DW  _0x0*2+97

	.DW  0x0F
	.DW  _0x17+112
	.DW  _0x0*2+112

	.DW  0x0D
	.DW  _0x17+127
	.DW  _0x0*2+127

	.DW  0x16
	.DW  _0x17+140
	.DW  _0x0*2+140

	.DW  0x10
	.DW  _0x17+162
	.DW  _0x0*2+162

	.DW  0x0F
	.DW  _0x8F
	.DW  _0x0*2+178

	.DW  0x11
	.DW  _0x8F+15
	.DW  _0x0*2+193

	.DW  0x0D
	.DW  _0x8F+32
	.DW  _0x0*2+210

	.DW  0x0D
	.DW  _0x8F+45
	.DW  _0x0*2+223

	.DW  0x10
	.DW  _0x8F+58
	.DW  _0x0*2+236

	.DW  0x0E
	.DW  _0x8F+74
	.DW  _0x0*2+252

	.DW  0x09
	.DW  _0x94
	.DW  _0x0*2+266

	.DW  0x29
	.DW  _0x94+9
	.DW  _0x0*2+275

	.DW  0x0E
	.DW  _0x94+50
	.DW  _0x0*2+316

	.DW  0x0D
	.DW  _0x94+64
	.DW  _0x0*2+330

	.DW  0x1B
	.DW  _0x94+77
	.DW  _0x0*2+343

	.DW  0x0D
	.DW  _0x94+104
	.DW  _0x0*2+210

	.DW  0x0A
	.DW  _0x94+117
	.DW  _0x0*2+370

	.DW  0x0E
	.DW  _0x94+127
	.DW  _0x0*2+380

	.DW  0x27
	.DW  _0x94+141
	.DW  _0x0*2+394

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;unsigned char keypad();
;unsigned char EE_Read(unsigned int address);
;void EE_Write(unsigned int address, unsigned int data);
;void Store();
;int  checkID(unsigned int id);
;int checkPASS(unsigned int id, unsigned int pass);
;int changePASS(unsigned int id, unsigned int npass);
;int check_PASS_Admin(unsigned int pass);
;int read();
;void peep();
;void main(void)
; 0000 0013 {

	.CSEG
_main:
; .FSTART _main
; 0000 0014 
; 0000 0015 
; 0000 0016 DDRB = 0b00000111;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0017 PORTB = 0b11111000;
	LDI  R30,LOW(248)
	OUT  0x18,R30
; 0000 0018 //DDRB.0 = 1;
; 0000 0019 DDRC.1 = 1;
	SBI  0x14,1
; 0000 001A PORTC.1 = 0;
	CBI  0x15,1
; 0000 001B DDRD.4 = 1;
	SBI  0x11,4
; 0000 001C PORTD.4 = 0;
	CBI  0x12,4
; 0000 001D 
; 0000 001E //PORTC.0=0;
; 0000 001F DDRD.2 = 0;
	CBI  0x11,2
; 0000 0020 PORTD.2 = 1;
	SBI  0x12,2
; 0000 0021 DDRD.3 = 0;
	CBI  0x11,3
; 0000 0022 PORTD.3 = 1;
	SBI  0x12,3
; 0000 0023 SREG.7 = 1;
	BSET 7
; 0000 0024 MCUCR |= (1 << 1);  //falling
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 0025 MCUCR |= (1 << 3);  //falling
	IN   R30,0x35
	ORI  R30,8
	OUT  0x35,R30
; 0000 0026 MCUCR &= ~(1 << 0);
	IN   R30,0x35
	ANDI R30,0xFE
	OUT  0x35,R30
; 0000 0027 MCUCR &= ~(1 << 2);
	IN   R30,0x35
	ANDI R30,0xFB
	OUT  0x35,R30
; 0000 0028 GICR |= (1 << 6);//intrrupt_0
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0029 GICR |= (1 << 7);//intrrupt_1
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 002A DDRD.5 = 1;
	SBI  0x11,5
; 0000 002B PORTD.5 = 0;
	CBI  0x12,5
; 0000 002C 
; 0000 002D 
; 0000 002E 
; 0000 002F 
; 0000 0030 
; 0000 0031 //...end */
; 0000 0032 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0033 
; 0000 0034 lcd_puts("press * to start,please");
	__POINTW2MN _0x17,0
	RCALL _lcd_puts
; 0000 0035 //Store();
; 0000 0036 while (1)
_0x18:
; 0000 0037 {
; 0000 0038 char num = keypad();
; 0000 0039 int c1 = 0;
; 0000 003A int c2 = 0;
; 0000 003B lcd_clear();
	SBIW R28,5
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
;	num -> Y+4
;	c1 -> Y+2
;	c2 -> Y+0
	RCALL _keypad
	STD  Y+4,R30
	RCALL _lcd_clear
; 0000 003C 
; 0000 003D if(num == '*')
	LDD  R26,Y+4
	CPI  R26,LOW(0x2A)
	BREQ PC+2
	RJMP _0x1B
; 0000 003E {
; 0000 003F 
; 0000 0040 PORTC.1 = 0;
	CBI  0x15,1
; 0000 0041 PORTD.4=0;
	CBI  0x12,4
; 0000 0042 
; 0000 0043 lcd_puts("Enter your ID");
	__POINTW2MN _0x17,24
	RCALL _lcd_puts
; 0000 0044 
; 0000 0045 c1 = read();
	RCALL _read
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0046 delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0047 lcd_clear();
; 0000 0048 
; 0000 0049 if(checkID(c1) == 1)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x20
; 0000 004A {
; 0000 004B lcd_clear();
	RCALL _lcd_clear
; 0000 004C lcd_puts("Enter your PC");
	__POINTW2MN _0x17,38
	RCALL _lcd_puts
; 0000 004D 
; 0000 004E c2 = read();
	RCALL _read
	ST   Y,R30
	STD  Y+1,R31
; 0000 004F delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0050 lcd_clear();
; 0000 0051 if(checkPASS(c1, c2) == 1)
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL SUBOPT_0x4
	BRNE _0x21
; 0000 0052 {
; 0000 0053 switch(c1)
	LDD  R30,Y+2
	LDD  R31,Y+2+1
; 0000 0054 {
; 0000 0055 case 111:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x25
; 0000 0056 lcd_puts("Welcome, Prof ");
	__POINTW2MN _0x17,52
	RJMP _0xAF
; 0000 0057 break;
; 0000 0058 case 126:
_0x25:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x26
; 0000 0059 
; 0000 005A lcd_puts("Welcome, Ahmed ");
	__POINTW2MN _0x17,67
	RJMP _0xAF
; 0000 005B break;
; 0000 005C case 128:
_0x26:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x27
; 0000 005D lcd_puts("Welcome, Amr ");
	__POINTW2MN _0x17,83
	RJMP _0xAF
; 0000 005E break;
; 0000 005F case 130:
_0x27:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x28
; 0000 0060 lcd_puts("Welcome, Adel ");
	__POINTW2MN _0x17,97
	RJMP _0xAF
; 0000 0061 break;
; 0000 0062 case 132:
_0x28:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x24
; 0000 0063 lcd_puts("Welcome, Omar ");
	__POINTW2MN _0x17,112
_0xAF:
	RCALL _lcd_puts
; 0000 0064 break;
; 0000 0065 }
_0x24:
; 0000 0066 delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0067 lcd_clear();
; 0000 0068 PORTD.4=1;
	SBI  0x12,4
; 0000 0069 delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
; 0000 006A lcd_puts("Door is open");
	__POINTW2MN _0x17,127
	RCALL _lcd_puts
; 0000 006B PORTD.4=0;
	CBI  0x12,4
; 0000 006C 
; 0000 006D 
; 0000 006E 
; 0000 006F 
; 0000 0070 }
; 0000 0071 else
	RJMP _0x2E
_0x21:
; 0000 0072 {
; 0000 0073 lcd_puts("Sorry wrong password ");
	__POINTW2MN _0x17,140
	RCALL _lcd_puts
; 0000 0074 delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0075 lcd_clear();
; 0000 0076 
; 0000 0077 PORTC.1 = 1;
	SBI  0x15,1
; 0000 0078 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 0079 PORTC.1 = 0;     //one peep instead of turning on lamp
	CBI  0x15,1
; 0000 007A delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 007B }
_0x2E:
; 0000 007C }
; 0000 007D 
; 0000 007E else
	RJMP _0x33
_0x20:
; 0000 007F {
; 0000 0080 lcd_puts("Sorry wrong ID ");
	__POINTW2MN _0x17,162
	RCALL SUBOPT_0x5
; 0000 0081 delay_ms(1000);
; 0000 0082 peep();
	RCALL _peep
; 0000 0083 }
_0x33:
; 0000 0084 }
; 0000 0085 }
_0x1B:
	ADIW R28,5
	RJMP _0x18
; 0000 0086 
; 0000 0087 }
_0x34:
	RJMP _0x34
; .FEND

	.DSEG
_0x17:
	.BYTE 0xB2
;unsigned char keypad()
; 0000 008B {

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 008C while(1)
_0x35:
; 0000 008D {
; 0000 008E PORTB.0 = 0; PORTB.1 = 1; PORTB.2 = 1;
	CBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
; 0000 008F //Only B1 is activated
; 0000 0090 switch(PINB)
	IN   R30,0x16
; 0000 0091 {
; 0000 0092 case 0b11110110:
	CPI  R30,LOW(0xF6)
	BRNE _0x41
; 0000 0093 while (PINB.3 == 0);
_0x42:
	SBIS 0x16,3
	RJMP _0x42
; 0000 0094 return 1;
	LDI  R30,LOW(1)
	RET
; 0000 0095 break;
	RJMP _0x40
; 0000 0096 
; 0000 0097 case 0b11101110:
_0x41:
	CPI  R30,LOW(0xEE)
	BRNE _0x45
; 0000 0098 while (PINB.4 == 0);
_0x46:
	SBIS 0x16,4
	RJMP _0x46
; 0000 0099 return 4;
	LDI  R30,LOW(4)
	RET
; 0000 009A break;
	RJMP _0x40
; 0000 009B 
; 0000 009C case 0b11011110:
_0x45:
	CPI  R30,LOW(0xDE)
	BRNE _0x49
; 0000 009D while (PINB.5 == 0);
_0x4A:
	SBIS 0x16,5
	RJMP _0x4A
; 0000 009E return 7;
	LDI  R30,LOW(7)
	RET
; 0000 009F break;
	RJMP _0x40
; 0000 00A0 
; 0000 00A1 case 0b10111110:
_0x49:
	CPI  R30,LOW(0xBE)
	BRNE _0x40
; 0000 00A2 while (PINB.6 == 0);
_0x4E:
	SBIS 0x16,6
	RJMP _0x4E
; 0000 00A3 return '*';
	LDI  R30,LOW(42)
	RET
; 0000 00A4 break;
; 0000 00A5 
; 0000 00A6 }
_0x40:
; 0000 00A7 PORTB.0 = 1; PORTB.1 = 0; PORTB.2 = 1;
	SBI  0x18,0
	CBI  0x18,1
	SBI  0x18,2
; 0000 00A8 //Only B2 is activated
; 0000 00A9 switch(PINB)
	IN   R30,0x16
; 0000 00AA {
; 0000 00AB case 0b11110101:
	CPI  R30,LOW(0xF5)
	BRNE _0x5A
; 0000 00AC while (PINB.3 == 0);
_0x5B:
	SBIS 0x16,3
	RJMP _0x5B
; 0000 00AD return 2;
	LDI  R30,LOW(2)
	RET
; 0000 00AE break;
	RJMP _0x59
; 0000 00AF 
; 0000 00B0 case 0b11101101:
_0x5A:
	CPI  R30,LOW(0xED)
	BRNE _0x5E
; 0000 00B1 while (PINB.4 == 0);
_0x5F:
	SBIS 0x16,4
	RJMP _0x5F
; 0000 00B2 return 5;
	LDI  R30,LOW(5)
	RET
; 0000 00B3 break;
	RJMP _0x59
; 0000 00B4 
; 0000 00B5 case 0b11011101:
_0x5E:
	CPI  R30,LOW(0xDD)
	BRNE _0x62
; 0000 00B6 while (PINB.5 == 0);
_0x63:
	SBIS 0x16,5
	RJMP _0x63
; 0000 00B7 return 8;
	LDI  R30,LOW(8)
	RET
; 0000 00B8 break;
	RJMP _0x59
; 0000 00B9 
; 0000 00BA case 0b10111101:
_0x62:
	CPI  R30,LOW(0xBD)
	BRNE _0x59
; 0000 00BB while (PINB.6 == 0);
_0x67:
	SBIS 0x16,6
	RJMP _0x67
; 0000 00BC return 0;
	LDI  R30,LOW(0)
	RET
; 0000 00BD break;
; 0000 00BE 
; 0000 00BF }
_0x59:
; 0000 00C0 PORTB.0 = 1; PORTB.1 = 1; PORTB.2 = 0;
	SBI  0x18,0
	SBI  0x18,1
	CBI  0x18,2
; 0000 00C1 //Only B3 is activated
; 0000 00C2 switch(PINB)
	IN   R30,0x16
; 0000 00C3 {
; 0000 00C4 case 0b11110011:
	CPI  R30,LOW(0xF3)
	BRNE _0x73
; 0000 00C5 while (PINB.3 == 0);
_0x74:
	SBIS 0x16,3
	RJMP _0x74
; 0000 00C6 return 3;
	LDI  R30,LOW(3)
	RET
; 0000 00C7 break;
	RJMP _0x72
; 0000 00C8 
; 0000 00C9 case 0b11101011:
_0x73:
	CPI  R30,LOW(0xEB)
	BRNE _0x77
; 0000 00CA while (PINB.4 == 0);
_0x78:
	SBIS 0x16,4
	RJMP _0x78
; 0000 00CB return 6;
	LDI  R30,LOW(6)
	RET
; 0000 00CC break;
	RJMP _0x72
; 0000 00CD 
; 0000 00CE case 0b11011011:
_0x77:
	CPI  R30,LOW(0xDB)
	BRNE _0x7B
; 0000 00CF while (PINB.5 == 0);
_0x7C:
	SBIS 0x16,5
	RJMP _0x7C
; 0000 00D0 return 9;
	LDI  R30,LOW(9)
	RET
; 0000 00D1 break;
	RJMP _0x72
; 0000 00D2 
; 0000 00D3 case 0b10111011:
_0x7B:
	CPI  R30,LOW(0xBB)
	BRNE _0x72
; 0000 00D4 while (PINB.6 == 0);
_0x80:
	SBIS 0x16,6
	RJMP _0x80
; 0000 00D5 return '#';
	LDI  R30,LOW(35)
	RET
; 0000 00D6 break;
; 0000 00D7 
; 0000 00D8 }
_0x72:
; 0000 00D9 
; 0000 00DA }
	RJMP _0x35
; 0000 00DB }
; .FEND
;unsigned char EE_Read(unsigned int address)
; 0000 00E1 {
_EE_Read:
; .FSTART _EE_Read
; 0000 00E2 while(EECR.1 == 1);    //Wait till EEPROM is ready
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	address -> R16,R17
_0x83:
	SBIC 0x1C,1
	RJMP _0x83
; 0000 00E3 EEAR = address;        //Prepare the address you want to read from
	__OUTWR 16,17,30
; 0000 00E4 
; 0000 00E5 EECR.0 = 1;            //Execute read command
	SBI  0x1C,0
; 0000 00E6 
; 0000 00E7 return EEDR;
	IN   R30,0x1D
	RJMP _0x20A0004
; 0000 00E8 
; 0000 00E9 }
; .FEND
;void EE_Write(unsigned int address, unsigned int data)
; 0000 00ED {
_EE_Write:
; .FSTART _EE_Write
; 0000 00EE while(EECR.1 == 1);    //Wait till EEPROM is ready
	RCALL SUBOPT_0x6
;	address -> R18,R19
;	data -> R16,R17
_0x88:
	SBIC 0x1C,1
	RJMP _0x88
; 0000 00EF EEAR = address;        //Prepare the address you want to read from
	__OUTWR 18,19,30
; 0000 00F0 EEDR = data;           //Prepare the data you want to write in the address above
	OUT  0x1D,R16
; 0000 00F1 EECR.2 = 1;            //Master write enable
	SBI  0x1C,2
; 0000 00F2 EECR.1 = 1;            //Write Enable
	SBI  0x1C,1
; 0000 00F3 }
	RCALL __LOADLOCR4
	RJMP _0x20A0003
; .FEND
;interrupt [2]  void init_0(void)
; 0000 00F8 
; 0000 00F9 {
_init_0:
; .FSTART _init_0
	RCALL SUBOPT_0x7
; 0000 00FA 
; 0000 00FB int pass = 0;
; 0000 00FC int pass1 = 0;
; 0000 00FD int new_pass = 0;
; 0000 00FE int id = 0;
; 0000 00FF 
; 0000 0100 lcd_clear();
	SBIW R28,2
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x8
;	pass -> R16,R17
;	pass1 -> R18,R19
;	new_pass -> R20,R21
;	id -> Y+6
	RCALL _lcd_clear
; 0000 0101 lcd_puts("Enter Admin PC");
	__POINTW2MN _0x8F,0
	RCALL SUBOPT_0x9
; 0000 0102 pass = read();
; 0000 0103 
; 0000 0104 
; 0000 0105 delay_ms(500);
; 0000 0106 lcd_clear();
; 0000 0107 if(check_PASS_Admin(pass) == 1)
	MOVW R26,R16
	RCALL _check_PASS_Admin
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x90
; 0000 0108 {
; 0000 0109 lcd_puts("Enter Student ID");
	__POINTW2MN _0x8F,15
	RCALL _lcd_puts
; 0000 010A 
; 0000 010B id = read();
	RCALL _read
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 010C delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 010D lcd_clear();
; 0000 010E if(checkID(id) == 1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x3
	BRNE _0x91
; 0000 010F {
; 0000 0110 lcd_puts("Enter new PC");
	__POINTW2MN _0x8F,32
	RCALL _lcd_puts
; 0000 0111 
; 0000 0112 pass = read();
	RCALL _read
	MOVW R16,R30
; 0000 0113 
; 0000 0114 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0115 delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0116 lcd_clear();
; 0000 0117 pass1 = pass / 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOVW R18,R30
; 0000 0118 new_pass = pass1 * 10 + pass % 10;
	RCALL SUBOPT_0xA
	MOVW R26,R16
	RCALL SUBOPT_0xB
; 0000 0119 
; 0000 011A changePASS(id, pass);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RCALL _changePASS
; 0000 011B 
; 0000 011C 
; 0000 011D delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 011E lcd_clear();
; 0000 011F 
; 0000 0120 lcd_puts("PC is stored");
	__POINTW2MN _0x8F,45
	RCALL SUBOPT_0x5
; 0000 0121 delay_ms(1000);
; 0000 0122 lcd_clear();
	RCALL _lcd_clear
; 0000 0123 }
; 0000 0124 else
	RJMP _0x92
_0x91:
; 0000 0125 {
; 0000 0126 lcd_puts("ID is not found");
	__POINTW2MN _0x8F,58
	RCALL _lcd_puts
; 0000 0127 peep();
	RCALL _peep
; 0000 0128 }
_0x92:
; 0000 0129 
; 0000 012A }
; 0000 012B else
	RJMP _0x93
_0x90:
; 0000 012C {
; 0000 012D lcd_puts("Contact Admin");
	__POINTW2MN _0x8F,74
	RCALL _lcd_puts
; 0000 012E delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 012F lcd_clear();
; 0000 0130 peep();
	RCALL _peep
; 0000 0131 }
_0x93:
; 0000 0132 
; 0000 0133 
; 0000 0134 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RJMP _0xB1
; .FEND

	.DSEG
_0x8F:
	.BYTE 0x58
;interrupt [3]  void init_1(void)
; 0000 0138 {

	.CSEG
_init_1:
; .FSTART _init_1
	RCALL SUBOPT_0x7
; 0000 0139 
; 0000 013A 
; 0000 013B int id = 0;
; 0000 013C int pass_new = 0;
; 0000 013D int new_pass1 = 0;
; 0000 013E int pass_old = 0;
; 0000 013F int pass2 = 0;
; 0000 0140 SREG.7 = 1;
	SBIW R28,4
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
;	id -> R16,R17
;	pass_new -> R18,R19
;	new_pass1 -> R20,R21
;	pass_old -> Y+8
;	pass2 -> Y+6
	BSET 7
; 0000 0141 lcd_clear();
	RCALL _lcd_clear
; 0000 0142 lcd_puts("Enter ID");
	__POINTW2MN _0x94,0
	RCALL SUBOPT_0x9
; 0000 0143 id = read();
; 0000 0144 delay_ms(500);
; 0000 0145 lcd_clear();
; 0000 0146 if(id == 111)
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x95
; 0000 0147 {
; 0000 0148 lcd_puts("you donnot have permission,Contact admin");
	__POINTW2MN _0x94,9
	RCALL _lcd_puts
; 0000 0149 peep();
	RCALL _peep
; 0000 014A }
; 0000 014B else
	RJMP _0x96
_0x95:
; 0000 014C {
; 0000 014D if(checkID(id) == 0)
	MOVW R26,R16
	RCALL _checkID
	SBIW R30,0
	BRNE _0x97
; 0000 014E {
; 0000 014F lcd_puts("contact admin"); delay_ms(500);
	__POINTW2MN _0x94,50
	RCALL SUBOPT_0xC
; 0000 0150 peep();
	RCALL _peep
; 0000 0151 }
; 0000 0152 else
	RJMP _0x98
_0x97:
; 0000 0153 {
; 0000 0154 lcd_puts("Enter old PC"); delay_ms(500);
	__POINTW2MN _0x94,64
	RCALL SUBOPT_0xC
; 0000 0155 pass_old = read();
	RCALL _read
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0156 
; 0000 0157 
; 0000 0158 delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0159 lcd_clear();
; 0000 015A 
; 0000 015B if(checkPASS(id, pass_old) != 1)
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x4
	BREQ _0x99
; 0000 015C {
; 0000 015D lcd_puts("Wrong pass,  Contact admin");
	__POINTW2MN _0x94,77
	RCALL _lcd_puts
; 0000 015E peep();
	RCALL _peep
; 0000 015F }
; 0000 0160 else
	RJMP _0x9A
_0x99:
; 0000 0161 {
; 0000 0162 lcd_puts("Enter new PC");
	__POINTW2MN _0x94,104
	RCALL SUBOPT_0x5
; 0000 0163 
; 0000 0164 
; 0000 0165 delay_ms(1000);
; 0000 0166 lcd_clear();
	RCALL _lcd_clear
; 0000 0167 
; 0000 0168 pass_new = read();
	RCALL _read
	MOVW R18,R30
; 0000 0169 
; 0000 016A delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 016B lcd_clear();
; 0000 016C lcd_puts("Renter PC");
	__POINTW2MN _0x94,117
	RCALL _lcd_puts
; 0000 016D pass_sure = read();
	RCALL _read
	MOVW R4,R30
; 0000 016E 
; 0000 016F delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0170 lcd_clear();
; 0000 0171 if(pass_new == pass_sure)
	__CPWRR 4,5,18,19
	BRNE _0x9B
; 0000 0172 {
; 0000 0173 pass2 = pass_new / 10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0174 new_pass1 = pass2 * 10 + pass_new % 10;
	RCALL SUBOPT_0xA
	MOVW R26,R18
	RCALL SUBOPT_0xB
; 0000 0175 
; 0000 0176 
; 0000 0177 changePASS(id, pass_new);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	RCALL _changePASS
; 0000 0178 lcd_puts("New PC stored");
	__POINTW2MN _0x94,127
	RCALL _lcd_puts
; 0000 0179 delay_ms(500);
	RJMP _0xB0
; 0000 017A lcd_clear();
; 0000 017B }
; 0000 017C else
_0x9B:
; 0000 017D {
; 0000 017E lcd_puts("2 passwords arenot match,Contact admin");
	__POINTW2MN _0x94,141
	RCALL _lcd_puts
; 0000 017F peep();
	RCALL _peep
; 0000 0180 delay_ms(500);
_0xB0:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0181 lcd_clear();
	RCALL _lcd_clear
; 0000 0182 }
; 0000 0183 
; 0000 0184 
; 0000 0185 }
_0x9A:
; 0000 0186 
; 0000 0187 }
_0x98:
; 0000 0188 }
_0x96:
; 0000 0189 
; 0000 018A }
	RCALL __LOADLOCR6
	ADIW R28,10
_0xB1:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x94:
	.BYTE 0xB4
;void Store()
; 0000 018E {

	.CSEG
; 0000 018F EE_Write(111, 20); //devide  pass to 2 sections(2 bits ,1 bit)in 2 different Consecutive ids
; 0000 0190 EE_Write(112, 3);
; 0000 0191 
; 0000 0192 EE_Write(126, 12);
; 0000 0193 EE_Write(127, 9);
; 0000 0194 
; 0000 0195 EE_Write(128, 32);
; 0000 0196 EE_Write(129, 5);
; 0000 0197 
; 0000 0198 EE_Write(130, 42);
; 0000 0199 EE_Write(131, 6);
; 0000 019A 
; 0000 019B EE_Write(132, 07);
; 0000 019C EE_Write(133, 9);
; 0000 019D 
; 0000 019E 
; 0000 019F }
;int checkID(unsigned int id)
; 0000 01A2 {
_checkID:
; .FSTART _checkID
; 0000 01A3 if(EE_Read(id) != 255)
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	id -> R16,R17
	RCALL _EE_Read
	CPI  R30,LOW(0xFF)
	BREQ _0x9D
; 0000 01A4 return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20A0004
; 0000 01A5 return 0;
_0x9D:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20A0004:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 01A6 }
; .FEND
;int checkPASS(unsigned int id, unsigned int pass)
; 0000 01A9 {
_checkPASS:
; .FSTART _checkPASS
; 0000 01AA if(EE_Read(id) == pass / 10 && EE_Read(id + 1) == pass % 10)
	RCALL SUBOPT_0x6
;	id -> R18,R19
;	pass -> R16,R17
	MOVW R26,R18
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	BRNE _0x9F
	MOVW R26,R18
	ADIW R26,1
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	BREQ _0xA0
_0x9F:
	RJMP _0x9E
_0xA0:
; 0000 01AB return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL __LOADLOCR4
	RJMP _0x20A0003
; 0000 01AC return 0;
_0x9E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __LOADLOCR4
	RJMP _0x20A0003
; 0000 01AD }
; .FEND
;int check_PASS_Admin(unsigned int pass)
; 0000 01AF {
_check_PASS_Admin:
; .FSTART _check_PASS_Admin
; 0000 01B0 int admin_id = 111;
; 0000 01B1 if(EE_Read(admin_id) == pass / 10 && EE_Read(admin_id + 1) == pass % 10)
	RCALL __SAVELOCR4
	MOVW R18,R26
;	pass -> R18,R19
;	admin_id -> R16,R17
	__GETWRN 16,17,111
	MOVW R26,R16
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xE
	BRNE _0xA2
	MOVW R26,R16
	ADIW R26,1
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xF
	BREQ _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
; 0000 01B2 return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20A0002
; 0000 01B3 return 0;
_0xA1:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0002
; 0000 01B4 }
; .FEND
;int changePASS(unsigned int id, unsigned int npass)
; 0000 01B8 {
_changePASS:
; .FSTART _changePASS
; 0000 01B9 EE_Write(id, npass / 10);
	RCALL SUBOPT_0x6
;	id -> R18,R19
;	npass -> R16,R17
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	RCALL _EE_Write
; 0000 01BA EE_Write(id + 1, npass % 10);
	MOVW R30,R18
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOVW R26,R30
	RCALL _EE_Write
; 0000 01BB return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL __LOADLOCR4
	RJMP _0x20A0003
; 0000 01BC 
; 0000 01BD }
; .FEND
;int read()
; 0000 01C0 {
_read:
; .FSTART _read
; 0000 01C1 int i = 3 , c = 0, c1 = 0;
; 0000 01C2 while(i)
	RCALL __SAVELOCR6
;	i -> R16,R17
;	c -> R18,R19
;	c1 -> R20,R21
	__GETWRN 16,17,3
	__GETWRN 18,19,0
	__GETWRN 20,21,0
_0xA4:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0xA6
; 0000 01C3 {
; 0000 01C4 c = keypad();
	RCALL _keypad
	MOV  R18,R30
	CLR  R19
; 0000 01C5 
; 0000 01C6 lcd_clear();
	RCALL _lcd_clear
; 0000 01C7 c1 = c1 * 10 + c;
	MOVW R30,R20
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	ADD  R30,R18
	ADC  R31,R19
	MOVW R20,R30
; 0000 01C8 lcd_printf("%d ", c1);
	__POINTW1FN _0x0,433
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
; 0000 01C9 i = i - 1;
	__SUBWRN 16,17,1
; 0000 01CA }
	RJMP _0xA4
_0xA6:
; 0000 01CB 
; 0000 01CC return c1;
	MOVW R30,R20
	RCALL __LOADLOCR6
_0x20A0003:
	ADIW R28,6
	RET
; 0000 01CD 
; 0000 01CE 
; 0000 01CF 
; 0000 01D0 }
; .FEND
;void peep()
; 0000 01D4 {
_peep:
; .FSTART _peep
; 0000 01D5 PORTC.1 = 1;
	RCALL SUBOPT_0x11
; 0000 01D6 delay_ms(1000);
; 0000 01D7 PORTC.1 = 0;         // two peeps instead of turning on lamp
; 0000 01D8 delay_ms(1000);
; 0000 01D9 PORTC.1 = 1;
	RCALL SUBOPT_0x11
; 0000 01DA delay_ms(1000);
; 0000 01DB PORTC.1 = 0;
; 0000 01DC delay_ms(1000);
; 0000 01DD }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R9,R16
	MOV  R8,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x12
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x12
	LDI  R30,LOW(0)
	MOV  R8,R30
	MOV  R9,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	CP   R9,R11
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R8
	MOV  R26,R8
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x20A0001
_0x2000004:
	INC  R9
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
_0x20A0002:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	MOV  R11,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x13
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	LD   R17,Y+
	RET
; .FEND

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x14
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	RCALL SUBOPT_0x14
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	RCALL SUBOPT_0x15
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x16
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x17
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x17
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x15
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x15
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	__GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x14
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x16
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x16
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_put_lcd_G102:
; .FSTART _put_lcd_G102
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _lcd_putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_lcd_printf:
; .FSTART _lcd_printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_lcd_G102)
	LDI  R31,HIGH(_put_lcd_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL _checkID
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL _checkPASS
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	RCALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	RCALL __SAVELOCR6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	RCALL _lcd_puts
	RCALL _read
	MOVW R16,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	ADD  R30,R22
	ADC  R31,R23
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	RCALL _lcd_puts
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	RCALL _EE_Read
	MOV  R22,R30
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	RCALL __DIVW21U
	MOV  R26,R22
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	RCALL __MODW21U
	MOV  R26,R22
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	RCALL _EE_Read
	MOV  R22,R30
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	SBI  0x15,1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
	CBI  0x15,1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x15:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12:
__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
