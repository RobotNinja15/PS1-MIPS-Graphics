.psx
.create "RectangleSub.bin", 0x80010000

.org 0x80010000

; ---------------------------
;    IO Port
; ---------------------------

IO_BASE_ADDR equ 0x1F80

; ----------------------------
;   GPU REGISTERS
; ----------------------------
GP0 equ 0x1810                                 
GP1 equ 0x1814

Main:

    ; GPU setup Display Control
    ; --------------------------------
    lui $t0, IO_BASE_ADDR               ; t0 = I/0 Port Base Address (mapped at 0x1F80****)


    li $t1, 0x00000000                  ; Command 0x00 = Reset GPU
    sw $t1, GP1($t0)                    ; Writes the packet to GP1

    li $t1, 0x03000000                  ; 03 = Display enable
    sw $t1, GP1($t0)                    ; write to GP1

    ; setting up Display Mode

    li $t1, 0x08000001                  ; 08 = Display mode (320x240, 15 bit, NTSC)
    sw $t1, GP1($t0)                    ; write to GP1

    li $t1, 0x06C60260                  ; 06 = Horizontal Display Range
    sw $t1, GP1($t0)                    ; write to GP1

    li $t1, 0x07042018                  ; 07 = Vertical Display Range
    sw $t1, GP1($t0)                    ; write to GP1

    ; GPU VRAM Access
    ; ---------------------------------------------------
    li $t1, 0xE1000400                  ; E1 = Draw mode settings
    sw $t1, GP0($t0)                    ; write to GP0

    li $t1, 0xE3000000                  ; E3 = drawing area top left x=0, y=0
    sw $t1, GP0($t0)                    ; write to GP0

    li $t1, 0xE403BD3F                  ; E4 = drawing area bottom right x=319, y=239
    sw $t1, GP0($t0)                    ; write to GP0

    li $t1, 0xE5000000                  ; E5 = Drawing Offset
    sw $t1, GP0($t0)                    ; Write GP0 command packet (set drawing offset to x=0, y=0)

     
    
    ; Clear the screen (draw a rectangle on VRAM)
    ; --------------------------------------------------------

    li $t1, 0x02FFFFFF                  ; 02 = fill rectangle in VRAM 
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x00000000                  ; Fill Area, Parameter : 0xYYYYXXXX = Topleft(0,0)
    sw $t1, GP0($t0)                    ; Write to GP0

    li $t1, 0x00EF013F                  ; fill area, 0xHHHHWWWW (Height=239, width=319)
    sw $t1, GP0($t0)                    ; Write to GP0

    ; ----------------------------------------------------------
    ; Invoke subroutine to draw momo chrome rectangle
    ; ----------------------------------------------------------

    li $s0, 0xFFFF00
    li $s1, 150
    li $s2, 40
    li $s3, 40
    li $s4, 50

    jal DrawMonoChromeRectangle
    nop


    ; -----------------------------------------------------------
    ; Subroutine to draw a Rect
    ; variables = color, y , x, widith, height
    ; -----------------------------------------------------------
    ;  s0 = color
    ;  s1 = y 
    ;  s2 = x 
    ;  s3 = width(x) 
    ;  s4 = height(y) 
    ;  -----------------------------------------------------------


DrawMonoChromeRectangle:

    lui  $t2, 0x6000                     ; Command - 0x60 (rectangle)
    or   $t1, $t2, $s0                   ; Command | color
    sw   $t1, GP0($t0)                   ; write to GP0

    sll  $s1, $s1, 16                    ; y <<= 16 bits
    andi $s2, $s2, 0xFFFF                ; x &= 0xFFFF
    or   $t1, $s1, $s2                   ; x | y
    sw   $t1, GP0($t0)                   ; Write to GP0 

    sll  $s4, $s4, 16                    ; height <<= 16 bits
    andi $s3, $s3, 0xFFFF                ; width  &= 0xFFFF 
    or   $t1, $s4, $s3                   ; width | height
    sw   $t1, GP0($t0)                   ; Write to GP0

    jr	$ra					             ; jump to $ra
    nop


LoopForever:
    j LoopForever                       ; continous Loop
    nop
   


.close
