.psx
.create "hellogpu.bin", 0x80010000

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

    li $t1, 0x02002E1B                  ; 02 = fill rectangle in VRAM 
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x00000000                  ; Fill Area, Parameter : 0xYYYYXXXX = Topleft(0,0)
    sw $t1, GP0($t0)                    ; Write to GP0

    li $t1, 0x00EF013F                  ; fill area, 0xHHHHWWWW (Height=239, width=319)
    sw $t1, GP0($t0)                    ; Write to GP0

    ; Draw a flat-shaded triange 
    ; ------------------------------------------------------------

    li $t1, 0x2000FFFF                  ; 20 = Flat-shaded triangle (Parameter color 0xBBGGRR)
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x00320032                  ; Vertex 1 : x = 50, y=50
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x001E0064                  ; Vertex 2 : x = 100, y = 30
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x0064006E                  ; Vertex 3 : x = 110, y = 100
    sw $t1, GP0($t0)                    ; Write GPO command

    ; Shaded-triangle
    ; ------------------------------------------------------------

    li $t1, 0x300000FF                  ; 30 = Shaded-Triangle (Command + color - red)
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x001E00C8                  ; vertex1
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x00FF0000                  ; color2 (Blue)
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x00640096                  ; vertex2
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x0000FF00                  ; color3 (green)
    sw $t1, GP0($t0)                    ; Write GP0 command

    li $t1, 0x006400FA                  ; vertex3
    sw $t1, GP0($t0)                    ; Write GP0 command

LoopForever:
    j LoopForever                       ; continous Loop
    nop
   


.close
