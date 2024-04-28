.psx
.create "hellogpu.bin", 0x80010000

.org 0x80010000

IO_BASE_ADDR equ 0x1F80

GP0 equ 0x1810
GP1 equ 0x1814

Main:
    lui $t0, IO_BASE_ADDR

    ; --------------
    ; Setting up GP1
    ; --------------

    ;; reset gpu (gp1)
    li $t1, 0x00000000 ;; command 0x00 resets de gpi
    sw $t1, GP1($t0)   ;; writes the package to gp1

    ;; display enable
    li $t1, 0x03000000 ;; 0x03 = enable display
    sw $t1, GP1($t0)   ;; writes package to gp1

    ;; display mode
    li $t1, 0x08000001 ;; 0x08 = display mode command (320x240, 15-bit, NTSC)
    sw $t1, GP1($t0)

    ;; horizontal range
    li $t1, 0x06C60260 ;; 0x06 = sets the horizontal range
    sw $t1, GP1($t0)
    
    ;; vertical range
    li $t1, 0x07042018 ;; 0x06 = sets the vertical range
    sw $t1, GP1($t0)

    ; --------------
    ; Setting up GP0
    ; --------------

    ;; draw mode
    li $t1, 0xE1000400 ;; 0xE1 = draw mode settings
    sw $t1, GP0($t0)

    ;; drawing area
    li $t1, 0xE3000000 ;; 0xE3 = sets the topleft drawing area (here it will be x=0 and y=0)
    sw $t1, GP0($t0)

    li $t1, 0xE403BD3F ;; 0xE4 = sets the bottomright drawing area (here it will be x=319 and y=239)
    sw $t1, GP0($t0)

    ;; drawing offset
    li $t1, 0xE5000000 ;; 0xE5 = sets the drawing offset (here it will be x=0 and y=0, no offset)
    sw $t1, GP0($t0)
    
    ;; clearing screen
    li $t1, 0x600000FF ;; 0x60 = draws a rectangle (in this case red. Only the R parameter filled, with G and B with zeroes)
    sw $t1, GP0($t0)

    li $t1, 0x00000000 ;; starting at x=0 and y=0
    sw $t1, GP0($t0)

    li $t1, 0x00F00140 ;; with size x=320 and y=240
    sw $t1, GP0($t0)

    ;; drawing a flat shaded triangle
    li $t1, 0x300000FF ;; first vertex red
    sw $t1, GP0($t0)

    li $t1, 0x000000A0 ;; first vertex coordinates (x=160 and y=0)
    sw $t1, GP0($t0)

    li $t1, 0x0000FF00 ;; second vertex green
    sw $t1, GP0($t0)

    li $t1, 0x00E50000 ;; second vertex coordinates (x=0 and y=229)
    sw $t1, GP0($t0)

    li $t1, 0x00FF0000 ;; third vertex blue
    sw $t1, GP0($t0)

    li $t1, 0x00E5013F ;; third vertex coordinates (x=319 and y=229)
    sw $t1, GP0($t0)



LoopForever:
    j LoopForever      ;; locks execution to prevent pcsx-redux default animation to trig
    nop

.close