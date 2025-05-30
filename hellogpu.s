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

     
    ; RECTANGLE
    ; ---------------------------------------------------------

    li $t2, 0x60FF00FF                  ; Command for a purple RECTANGLE
    li $t3, 0x000A0014                  ; vertex coords - x = 20, y = 10
    li $t4, 0x003200C8                  ; Height = 50, width = 200

    sw $t2, GP0($t0)                    ; command + color = CCPPPPPP
    sw $t3, GP0($t0)                    ; Coords of rect
    sw $t4, GP0($t0)                    ; height & width

    ; Triangle
    ; ---------------------------------------------------------

    li $t2, 0x20FFFF00
    li $t3, 0x00460096                  ; 1st vertex
    li $t4, 0x005A0078                  ; 2nd vertex
    li $t5, 0x005A00AA                  ; 3rd vertex

    sw $t2, GP0($t0)                    ; Write to GP0 - command + color (Teal)
    sw $t3, GP0($t0)                    ; Write to GP0 - coord of 1st vertex
    sw $t4, GP0($t0)                    ; Write to GP0 - coord of 2nd vertex
    sw $t5, GP0($t0)                    ; Write to GP0 - coord of 3rd vertex
    
   


.close
