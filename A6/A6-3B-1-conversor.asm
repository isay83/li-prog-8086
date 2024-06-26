.MODEL MEDIUM

.STACK 100H

.DATA
    
    FLAG DW ?
    COUNT DB ?
    REMAINDER DW 0
    COUNT_HEX DW 0
    OUTD DW ?
    IND DB ? 
    SELECT DB ?    
    INP1 DW ?   ; save Decimal_d input
    count_x DB ?
    D1 DB ?     ; save 1st Decimal_d digit
    D2 DB ?     ; save 2nd Decimal_d digit
    D3 DB ?     ; save 3rd Decimal_d digit
    D4 DB ?     ; save 4th Decimal_d digit
    D5 DB ?     ; save 5th Decimal_d digit
    REM DW ?
    
    MENU DB 0DH , 0AH , 'CONVERSOR BASICO', 0DH , 0AH
         DB '----------------', 0DH , 0AH
         DB '1. DECIMAL -> BINARIO', 0DH , 0AH
         DB '2. BINARIO -> DECIMAL', 0DH , 0AH 
         DB '3. DECIMAL -> HEXADECIMAL', 0DH , 0AH
         DB '4. HEXADECIMAL -> DECIMAL', 0DH , 0AH
         DB '5. SALIR', 0DH , 0AH, 0DH , 0AH
         DB 'ELIJA SU OPCION : $'
    
    ERROR_MESSAGE DB 0DH , 0AH , 'POR FAVOR, INGRESE UNA OPCION VALIDA... !!! $'
    INVALID DB 0DH , 0AH , 'NUMERO INVALIDO. INTENTELO NUEVAMENTE... $'
    TRY_AGAIN DB 0DH , 0AH , 'DESEA VOLVER A INTENTARLO? PULSE S O N: $'
    
    BINARY_NUMBER DB 0DH , 0AH , 'INGRESE EL NUMERO BINARIO ( MAX 16 DIGITOS ) : $'
    HEXA_NUMBER DB 0DH , 0AH ,   'INGRESE EL NUMERO HEXADECIMAL ( MAX 4 DIGITOS ) : $'
    
    
    SHOW_HEX DB 0DH , 0AH , 'RESULTADO ( HEXADECIMAL ) : $' ; to bin-hex
    SHOW_DEC DB 0DH , 0AH , 'RESULTADO ( DECIMAL ) : $' 
    SHOW_BIN DB 0DH , 0AH , 'RESULTADO ( BINARIO ) : $'     ; to hex-bin
                            
    
    NEW_LINE DB 0DH , 0AH , '$'    
    
    OP1 db '1. Decimal_d TO BINARY $' 
    OP2 db '2. Decimal_d TO HEXADecimal_d $'
    
    NEWL DB 10,13,'$'   ;newline    
    
    Decimal_dINP DB 'PRIMERO, INSERTAR + O - !!! $'                         
    INDecimal_d DB 'INGRESE EL NUMERO DECIMAL ( MAX 5 DIGITOS ) : $'
    
    INBINARY DB 'RESULTADO ( BINARIO ) : $'
    INHEXADecimal_d DB 'RESULTADO ( HEXADECIMAL ) : $'    
    
    error_rrMSG DB 'ERROR DE ENTRADA! SE HA INSERTADO UN VALOR INCORRECTO $'
         

.CODE
    
    MAIN PROC
        
        MOV AX , @DATA
        MOV DS , AX
        
        JMP MENU_BAR
  
        NEWL_MENU_BAR:
        
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
        
        MENU_BAR:                   ;MENU BAR LABEL 
            
            LEA DX , MENU          
            MOV AH , 9
            INT 21H
          
        
                
        INPUT_CHOICE:           ;INPUT_CHOICE LABEL 
        
            MOV AH , 1          ;TAKE INPUT
            INT 21H
            MOV SELECT,AL        
            
            CMP AL , 49         ;COMPARE WITH INPUTED VALUE 
            JE Decimal_d
            ;JE BIN_TO_HEX  
            
            CMP AL , 50
            JE BIN_TO_DEC
            ;JE HEX_TO_BIN
            
            CMP AL , 51
            JE Decimal_d
            ;JE BIN_TO_DEC
            
            CMP AL , 52
            JE HEX_TO_DEC
            
            CMP AL , 53
            JE EXIT
            
            CMP AL , 49         ;FOR WRONG INPUT
            JL ERROR
            
            CMP AL , 53                                            
            JG ERROR
                    
        
        
        ERROR:                          ;ERROR LABEL
            
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , ERROR_MESSAGE      ;ERROR MESSAGE SHOW
            MOV AH , 9
            INT 21H
            
            JMP MENU_BAR                ;JUMP TO THE MENU BAR TO GET THE INPUT AGAIN
        
        
        
        AGAIN:                  ;AGAIN LABEL 
        
            LEA DX,NEW_LINE     
            MOV AH,9     
            INT 21H 
             
            LEA DX,TRY_AGAIN       ;SHOW TRY AGAIN MESSAGE
            MOV AH,9     
            INT 21H
             
            MOV AH,1       
            INT 21H      
        
            CMP AL,83
            JE  NEWL_MENU_BAR      ;COMPARING WITH ASCII CHARS
    
            CMP AL,115
            JE  NEWL_MENU_BAR  
    
            CMP AL,83       
            JNE EXIT  
    
            CMP AL,115
            JNE EXIT
        
        
        
        ERROR_BIN:                ;ERROR_BIN_1 LABEL
        
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , INVALID    ;SHOW INVALID NUMBER
            MOV AH , 9
            INT 21H
            
        
        
        BIN_TO_HEX:                     ;BINARY TO HEXA-DECIMAL LABEL 
            
            LEA DX , NEW_LINE       
            MOV AH , 9
            INT 21H
            
            LEA DX , BINARY_NUMBER      ;BINARY NUMBER INPUT MESSAGE SHOW
            MOV AH , 9
            INT 21H
            
            MOV FLAG , 49
            JMP INPUT_BINARY    
        
 
        
        INPUT_BINARY:       ;INPUT_BINARY LABEL
         
            XOR AX , AX     ;CLEARING ALL REGISTERS
            XOR BX , BX
            XOR CX , CX
            XOR DX , DX
            MOV CX , 0      ;SETTING 1 TO CL
            
        
        
        INPUT_BINARY2:          ;INPUT_BINARY2 LABEL
            
            INC CX
            CMP CX , 17
            JE ENTER
            
            MOV AH , 1          ;INPUT BINARY NUMBER
            INT 21H
            
            CMP AL , 0DH        ;CHECK IF ENTER IS PRESSED OR NOT
            JE ENTER
            
            CMP AL , 48
            JNE BINARY_CHECK
            
        
        
        BINARY_CONTINUE:            ;BINARY_CONTINUE LABEL 
        
            SUB AL , 48
            SHL BX , 1
            OR BL , AL
            JMP INPUT_BINARY2       ;JUMP FOR INPUT ANOTHER DIGIT AGAIN    
        
        
        
        BINARY_CHECK:               ;BINARY_CHECK LABEL
        
            CMP AL , 49             ;TO CHECK IF THERE OTHER VALUE INPUTED RATHER THAN 1 AND 0
            JNE ERROR_BIN           ;IF OTHER VALUE INPUTED ERROR MESSAGE WILL DISPLAY
            JMP BINARY_CONTINUE    
        
        
        
        ENTER:                  ;ENTER LABEL 
        
            CMP FLAG , 49       ;TO DETECT WHICH OUTPUT VALUE IT SHOULD REFER
            JE OUTPUT_HEXA
            
            CMP FLAG , 50
            JE OUTPUT_DEC
            
            CMP FLAG , 51
            JE OUTPUT_DEC           

            
        
        OUTPUT_HEXA:                ;OUTPUT IN HEX LABEL
        
            XOR DX , DX
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , SHOW_HEX       ;PRINT HEX NUMBER MESSAGE
            MOV AH , 9
            INT 21H
            
            MOV CL , 1              ;MOV CL TO 1
            MOV CH , 0              ;MOV CH TO 0
            
            JMP OUTPUT_HEXA2
            
        
        
        OUTPUT_HEXA2:           ;OUTPUT_HEXA2 LABEL 
        
            CMP CH , 4          ;COMPARING INPUTS WHETHER INPUTS HAVE BEEN INSERTED FOR 4 TIMES
            JE AGAIN
            INC CH
            
            MOV DL , BH
            SHR DL , 4
            
            CMP DL , 0AH
            JL HEXA_DIGIT
            
            ADD DL,37H     
            MOV AH,2        
            INT 21H          
            ROL BX,4            ;ROTATING 4 BITS TO LEFT   
            
            JMP OUTPUT_HEXA2
            
        
        
        HEXA_DIGIT:             ;HEXA_DIGIT LABEL 
        
            ADD DL,30H         
            MOV AH,2       
            INT 21H            
            ROL BX,4
                        
            JMP OUTPUT_HEXA2                    


        
        ERROR_HEX:

            LEA DX,INVALID          ;DISPLAY ERROR MESSAGE
            MOV AH,9                
            INT 21H
            
            
        
        HEX_TO_BIN:                 ;HEXA-DECIMAL TO BINARY CONVERSION
                   
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
        
            LEA DX,HEXA_NUMBER
            MOV AH,9                ;DISPLAY MSG_IN
            INT 21H                                 

            JMP START      
                                

    
        START:
            
            XOR BX,BX                   ;CLEAR BX
            MOV COUNT,30H               ;COUNTER=0 
    

    
        INPUT:
    
            MOV AH,1                    ;INPUT
            INT 21H
    
            CMP AL,0DH                  ;COMPARE WITH CR
            JNE SKIP
    
            CMP COUNT,30H               ;COMPARE WITH 0
            JLE ERROR_HEX               ;IF LESS/EQ JUMP TO ERROR
            JMP END                



        SKIP:
    
            CMP AL,"A"      ;COMPARE WITH A
            JL DECIMAL      ;JUMP TO LABEL DECIMAL  IF LESS
    
            CMP AL,"F"      ;COMPARE WITH F
            JG ERROR_HEX    ;JUMP TO LABEL ERROR IF GREATER
    
            ADD AL,09H      ;ADD 9 TO AL
            JMP PROCESS     ;JUMP TO LABEL PROCESS
    


        DECIMAL:
            
            CMP AL,39H      ;COMPARE AL WITH 9
            JG ERROR_HEX    ;IF AL>9 JUMP TO ERROR
                            ;CHECKING IF INVALID
            CMP AL,30H      ;COMPARE WITH 0
            JL ERROR_HEX    ;IF AL<0 JUMP TO ERROR    
    
            JMP PROCESS     ;JUMP TO LABE PROCESS   
    


        PROCESS:
    
            INC COUNT
    
            AND AL,0FH      ;ASCII TO BIN  
            MOV CL,4        ;SET CL=4
            SHL AL,CL       ;SHIFT LEFT SIDE 4 TIMES
            MOV CX,4        ;SET CX=4


    
        LOOP_1:
    
            SHL AL,1        ;SHIFT 1 TIME
            RCL BX,1        ;MOVING THE CARRY TO BX    
    
            LOOP LOOP_1     

            CMP COUNT,34H   ;COMPARE WITH 4
            JE END          ;JUMP TO LABEL END
            JMP INPUT

        
        
        END:
            
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX,SHOW_BIN      ;DISPLAY MSG_OUT
            MOV AH,9
            INT 21H

            MOV CX,16
            MOV AH,2

        
        
        LOOP_2:

            SHL BX,1         ;LEFT SHIFT BX 1 TIME
                             ;JUMP IF CARRY=1
            JC ONE
                                              
            MOV DL,30H
            JMP DISPLAY                                          

        
        
        ONE:

            MOV DL,31H
    


        DISPLAY:

            INT 21H  
            LOOP LOOP_2

            JMP AGAIN
            
        
        
        BIN_TO_DEC:                     ;BINARY TO DECIMAL CONVERSION LABEL
        
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            
            LEA DX , BINARY_NUMBER      ;BINARY NUMBER INPUT MESSAGE SHOW
            MOV AH , 9
            INT 21H
            
            MOV FLAG , 50
            JMP INPUT_BINARY
            
        
        
        OUTPUT_DEC:                 ;OUTPUT DECIMAL NUMBER LABEL
        
            XOR DX , DX
            
            ;LEA DX , NEW_LINE
            ;MOV AH , 9
            ;INT 21H
            
            LEA DX , SHOW_DEC
            MOV AH , 9
            INT 21H
            
            XOR AX , AX
            
            MOV AX , BX
            
            CMP AX , 9              ;IF LESS THAN 10
            JLE LESS_THAN_9
            
            CMP AX , 99             ;IF GREATER THAN 9 AND LESS THAN 100
            JLE FROM_10_TO_99
            
            CMP AX , 99             ;IF GREATER THAN 99
            JG OVER_99
        
        
        
        LESS_THAN_9:        ;LESS_THAN_99 LABEL
                
            MOV AH , 2
            MOV DL , AL
            ADD DL , 48
            INT 21H
            
            JMP AGAIN  
        
        
        
        FROM_10_TO_99:              ;FROM_10_TO_99 LABEL
        
            MOV DX , 0H
            MOV BX , 10
            DIV BX                  ;DIVIDING BY 10
            
            MOV REMAINDER , DX      ;STORE REMAINDER
            
            MOV AH , 2
            ADD AX , 48
            MOV DX , AX
            INT 21H
            
            MOV AH , 2
            MOV DX , REMAINDER
            ADD DX , 48
            INT 21H
            
            JMP AGAIN
            
        
        
        OVER_99:                    ;OVER_99 LABEL
            
            MOV DX , 0H
            MOV BX , 100
            DIV BX                  ;DIVIDING BY 100
            
            MOV REMAINDER , DX      ;STORE REMAINDER
            
            MOV AH , 2
            ADD AX , 48
            MOV DX , AX
            INT 21H
            
            MOV AX , REMAINDER
            MOV DX , 0
            
            JMP FROM_10_TO_99
             
        
        
        ERROR_HEX_INPUT:        ;ERROR HEX INPUT LABEL
        
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , INVALID    ;SHOW INVALID NUMBER
            MOV AH , 9
            INT 21H
            
            
        
        HEX_TO_DEC:                 ;HEXA-DECIMAL TO DECIMAL CONVERSION LABEL
        
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , HEXA_NUMBER    ;SHOW INPUT HEXA-DECIMAL MESSAGE
            MOV AH , 9
            INT 21H
            
            MOV FLAG , 51
            JMP INPUT_HEX
            
       
       
        INPUT_HEX:          ;INPUT DECIMAL LABEL
       
            XOR AX , AX     ;CLEARING ALL REGISTERS
            XOR BX , BX
            XOR CX , CX
            XOR DX , DX
            
            MOV COUNT_HEX , 0
            
       
       
        INPUT_HEX2:             ;INPUT DECIMAL2 LABEL
        
            CMP COUNT_HEX , 4   ;IF INPUT 4 DIGITS THEN GO ENTER
            JE ENTER
            INC COUNT_HEX
           
            MOV AH , 1          ;INPUT HEXA-DECIMAL NUMBUR
            INT 21H
           
            CMP AL , 0DH
            JE ENTER
           
            CMP AL , 48
            JL ERROR_HEX_INPUT
            
            CMP AL , 65
            JL CONVERT_BIN_SHIFT
            
            CMP AL , 71
            JGE ERROR_HEX_INPUT
            
            SUB AL , 55
             
        
        
        
        CONVERT_BIN_SHIFT:      ;CONVERT BINARY SHIFT LABEL
            
            CMP AL , 57
            JG ERROR_HEX_INPUT
            
            AND AL , 0FH        ;CONVERTING TO BINARY AND SHIFT
            SHL AL , 4
            MOV CX , 4
            
        
        
        BIT_SHIFT:              ;BIT SHIFT LABEL
        
            SHL AL , 1
            RCL BX , 1
            LOOP BIT_SHIFT
            JMP INPUT_HEX2
        
        
        EXIT: 
        
            MOV AH , 4CH
            INT 21H  
            
    ;edittt
   
      
    
    Decimal_d:    ; part1
        
        MOV AH,9
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H        
        LEA DX,NEWL
        INT 21H
        
        LEA DX,Decimal_dINP
        INT 21H
        
        LEA DX,NEWL
        INT 21H
        
        LEA DX,INDecimal_d
        INT 21H
        
        CALL INPUT_Decimal_dFUN       ; calling Decimal_d_input function
        MOV INP1,BX                 ; input saved in INP1
        
        CMP SELECT,49              ; for binary output
        JE OUT_BINARY
                                
        CMP SELECT,51              ; for hexaDecimal_d output
        JE OUT_HEXA
        
        
        OUT_BINARY:
            
            MOV AH,9
            LEA DX,NEWL
            INT 21H
            ;LEA DX,NEWL
            ;INT 21H
            
            LEA DX,INBINARY
            INT 21H
            
            
            MOV BX,INP1          ; fix input in a register for output
            CALL OUT_BINARYFUN   ; calling binary_output function
            
            JMP AGAIN           ; jump to redo label
            
        
        OUT_HEXA:
            
            MOV AH,9
            LEA DX,NEWL
            INT 21H
            ;LEA DX,NEWL
            ;INT 21H
            
            LEA DX,INHEXADecimal_d
            INT 21H
            
            MOV BX,INP1             ; fix input in a register for output
            CALL OUT_HEXAFUN        ; calling hex_output function
                
            JMP AGAIN               ; jump to redo label
        
        
        
;Functions Area        
        
; input_dec and convert into binary(input in bx)        

        INPUT_Decimal_dFUN PROC
        
                MOV AH,1
                INT 21H
                MOV IND,AL
                
                CMP IND,'-'
                JNE NEXTPOS
                
                JMP BEGIN1
                
                NEXTPOS:
                    CMP IND,'+'
                    JNE error_rr
              
                
            BEGIN1:     
                XOR BX,BX      
                
                MOV AH,1      
                INT 21H
                
                MOV CX,0  
        
                REPEAT3:
                    
                    ;;error_rr TEST
                    CMP AL,'0'
                    JL error_rr
                    
                    CMP AL,'9'
                    JG error_rr
                    ;;;;;;;;;;;
                    
                    CMP CX,0
                    JE ADD1
                    CMP CX,1
                    JE ADD2
                    CMP CX,2
                    JE ADD3
                    CMP CX,3
                    JE ADD4
                    CMP CX,4
                    JE ADD5
                    
                    ADD1:
                        MOV D1,AL
                        JMP WORK
                    ADD2:
                        MOV D2,AL
                        JMP WORK
                    ADD3:
                        MOV D3,AL
                        JMP WORK
                    ADD4:
                        MOV D4,AL
                        JMP WORK
                    ADD5:
                        MOV D5,AL
                        JMP WORK
                        
                    
                    WORK:
                    AND AX,000FH      
                    PUSH AX
                    
                    MOV AX,10     
                    MUL BX        
                    POP BX         
                    ADD BX,AX      
                    
                    INC CX
                    CMP CX,5
                    JE EXIT_X2
                    
                    MOV AH,1    
                    INT 21H
                    
                    CMP AL,0DH   
                    JE EXIT_X1
                            
                    CMP AL,0DH   
                    JNE REPEATING
                    
                        
                    REPEATING:
                        
                        JMP REPEAT3
                    
                    
                    EXIT_X2:
                        
                        MOV AL,D1
                        CMP AL,'6'
                        JG error_rr
                        CMP AL,'6'
                        JLE NEXT2
                        
                            NEXT2:
                                MOV AL,D2
                                CMP AL,'5'
                                JG error_rr
                                CMP AL,'5'
                                JLE NEXT3
                        
                                NEXT3:
                                    MOV AL,D3
                                    CMP AL,'5'
                                    JG error_rr
                                    CMP AL,'5'
                                    JLE NEXT4
                        
                                    NEXT4:
                                        MOV AL,D4
                                        CMP AL,'3'
                                        JG error_rr
                                        CMP AL,'3'
                                        JLE NEXT5
                        
                                        NEXT5:
                                            MOV AL,D5
                                            CMP AL,'5'
                                            JG error_rr                                                                
                        
                    EXIT_X1:
                        
                        CMP IND,'-'
                        JE NGD
                        
                        JMP EXIT_XIND
                        NGD:
                         NEG BX
                    
                    EXIT_XIND:       
            
            RET                
        INPUT_Decimal_dFUN ENDP    


; output_hex to binary (work with bx)        
        
        out_hexafun proc
            
            mov al,0
            mov count_x,al
            
            xor dx,dx
            xor ax,ax
            
            
            mov cx,16
            
            while:
                shl dx,1
                inc count_x
                
                shl bx,1
                jc one_x
                
                
                mov ax,0
                jmp cont
                
                one_x:
                    mov ax,1
                
                cont:
                    or dx,ax
                    
                    cmp count_x,4
                    je pus
                    jmp lp
                    
                    pus:
                        cmp dx,9
                        jg letter1
                        
                        add dx,30h
                        jmp prnt
                              
                        letter1:
                        add dx,37h
                        
                        prnt:
                        mov ah,2 
                        int 21h
                        
                        xor dx,dx
                        mov count_x,0
                         
                    lp:    
                        loop while    
            
            
                
            
            
            ret
         out_hexafun endp   




;;;output_binary from binary(work with bx)
        
        OUT_BINARYFUN PROC
            
            MOV AH,2
            MOV CX,16      
     
            TOPBIN:
                SHL BX,1       
                JNC ZEROBIN   
                
                MOV DL,49      
                JMP PRINTBIN   
                
                ZEROBIN:          
                    MOV DL,48     
                    
                PRINTBIN:          
                    INT 21H     
                    LOOP TOPBIN            
        
        
            RET
        OUT_BINARYFUN ENDP


;;error_rr message
    
    error_rr:
        
        MOV AH,9
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H
        
        LEA DX,error_rrMSG
        INT 21H
        
        JMP again_x




;;REPEAT PROGRAMM
    
    again_x:
        
        MOV AH,9
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H
    

;;end programm
    EXIT_X:
    
        
        MOV AH,9
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H 
        LEA DX,NEWL
        INT 21H
        
    
        MOV AH,4CH      ; ignore emulator haulted 
        INT 21H