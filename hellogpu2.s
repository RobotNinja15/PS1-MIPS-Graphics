.psx
.create "hellogpu.bin", 0x80010000

.org 0x80010000

; ---------------------
; IO Port
; ---------------------
IO_BASE_ADDR equ 0x1F80      ; IO Ports Memory map base address

; ---------------------
; GPU Registers
; ---------------------
GP0 equ 0x1810               ; GP0 @ $1F801810: Rendering data & VRAM Access
GP1 equ 0x1814               ; GP1 @ $1F801814: Display Control & Environment setup

Main:
  lui $t0, IO_BASE_ADDR      ; t0 = I/O Port Base Address (mapped at 0x1F80****)

  ; ---------------------------------------------------------------------------
  ; Send commands to GP1 (mapped at 0x1F801814)
  ; These GP1 is for display control and environment setup
  ; (Command = 8-Bit MSB, Parameter = 24-Bit LSB)
  ; CCPPPPPP: CC=Command PPPPPP=Parameter
  ; ---------------------------------------------------------------------------
  li $t1, 0x00000000         ; 00 = Reset GPU
  sw $t1, GP1($t0)           ; Write to GP1

  li $t1, 0x03000000         ; 03 = Display enable
  sw $t1, GP1($t0)           ; Write to GP1

  li $t1, 0x08000001         ; 08 = Display mode (320x240, 15-bit, NTSC)
  sw $t1, GP1($t0)           ; Write to GP1

  li $t1, 0x06C60260         ; 06 = Horz Display Range - 0bxxxxxxxxxxXXXXXXXXXX (3168..608)
  sw $t1, GP1($t0)           ; Write to GP1
  
  li $t1, 0x07042018         ; 07 = Vert Display Range - 0byyyyyyyyyyYYYYYYYYYY (264..24)
  sw $t1, GP1($t0)           ; Write to GP1

  ; ---------------------------------------------------------------------------
  ; Send commands to GP0 (mapped at 0x1F801810)
  ; These GP0 commands are to setup the drawing area
  ; (Command = 8-Bit MSB, Parameter = 24-Bit LSB)
  ; CCPPPPPP  CC=Command PPPPPP=Parameter
  ; ---------------------------------------------------------------------------
  li $t1, 0xE1000400         ; E1 = Draw Mode Settings
  sw $t1, GP0($t0)			     ; Write to GP0

  li $t1, 0xE3000000		     ; E3 = Drawing Area TopLeft - 0bYYYYYYYYYYXXXXXXXXXX (10 bits for Y and X)
  sw $t1, GP0($t0)	         ; Write to GP0
  
  li $t1, 0xE403BD3F         ; E4 = Drawing area BottomRight - 0bYYYYYYYYYYXXXXXXXXXX (10 bits for X=319 and Y=239)
  sw $t1, GP0($t0)           ; Write to GP0

  li $t1, 0xE5000000         ; E5 = Drawing Offset - 0bYYYYYYYYYYYXXXXXXXXXXXX (X=0, Y=0)
  sw $t1, GP0($t0)		       ; Write to GP0

  ; ---------------------------------------------------------------------------
  ; TODO: Clear the screen (draw a rectangle on VRAM).
  ; ---------------------------------------------------------------------------
  
  ; ---------------------------------------------------------------------------
  ; TODO: Draw a flat-shaded triangle
  ; ---------------------------------------------------------------------------

LoopForever:
  j LoopForever              ; Continuous loop
  nop

.close
