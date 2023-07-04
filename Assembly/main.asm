; Alunos: Ricardo Henrique Pires dos Reis e Maria Gabriela Rodrigues Policarpo
; Professor: Marcelo Mikosz Gonçalves
; Disciplina: Arquitetura e Organização De Computadores

segment .data
    LF equ 0xA                      ; 10 = 0x0A, vai para a linha debaixo
    NULL equ 0xD                    ; 13 = 0x0D, volta para o início da linha
    SYS_CALL equ 0x80
    SYS_EXIT equ 0x1
    SYS_READ equ 0x3
    SYS_WRITE equ 0x4
    RET_EXIT equ 0x0
    STD_IN equ 0x0
    STD_OUT equ 0x1

section .data
    dia dd 0
    mes dd 0
    ano dd 0
    dia_semana dw 0
    var dw 0
    
    msg_dia db "Digite o dia: "                 ; string para imprimir
	msg_dia_length equ $-msg_dia				; tamanho da string
    msg_mes db "Digite o mês: "
	msg_mes_length equ $-msg_mes
    msg_ano db "Digite o ano: "
	msg_ano_length equ $-msg_ano

    sabado_msg db "O dia da semana é sábado.", LF, NULL
    tam_sab equ $- sabado_msg
    domingo_msg db "O dia da semana é domingo.", LF, NULL
    tam_dom equ $- domingo_msg
    segunda_msg db "O dia da semana é segunda-feira." , LF, NULL
    tam_seg equ $- segunda_msg
    terca_msg db "O dia da semana é terça-feira.", LF, NULL
    tam_ter equ $- terca_msg
    quarta_msg db "O dia da semana é quarta-feira.", LF, NULL
    tam_qua equ $- quarta_msg
    quinta_msg db "O dia da semana é quinta-feira.", LF, NULL
    tam_qui equ $- quinta_msg
    sexta_msg db "O dia da semana é sexta-feira.", LF, NULL
    tam_sex equ $- sexta_msg
    nada_msg db "Não existe.", LF, NULL
    tam_nada equ $- nada_msg
    
section .bss
    dia_var resb 1						; reserva 4 bytes de espaço
	mes_var resb 1
	ano_var resb 1
    
section .text
    global _start

_start:
    ; adquirir dados do dia
    mov eax, 4 							; sys_write
    mov ebx, 1 							; std_out
    mov ecx, msg_dia 					; mensagem para escrever
    mov edx, msg_dia_length 			; tamanho da mensagem
    int	SYS_CALL 						; chamar kernal

    mov eax, 3							; sys_read
    mov ebx, 0 							; std_in
    mov ecx, dia_var 					; variável para armazenamento
    mov edx, 3 					        ; tamanho da variável
    int	SYS_CALL 						; chamar kernal
    
    lea esi, [dia_var]                  ; indica a variável que quer mudar
    mov ecx, 0x2                        ; indica o tamanho do int
    call string_to_int                  ; chama a função para transformar string para int 
    mov [dia], eax                      ; move o int em eax para a variável
    
    ; adquirir dados do mês
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_mes
    mov edx, msg_mes_length
    int	SYS_CALL

    mov eax, 3
    mov ebx, 0
    mov ecx, mes_var
    mov edx, 3
    int	SYS_CALL
    
    lea esi, [mes_var]
    mov ecx, 0x2
    call string_to_int
    mov [mes], eax
    
    ; adquirir dados do ano
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_ano
    mov edx, msg_ano_length
    int	SYS_CALL

    mov eax, 3
    mov ebx, 0
    mov ecx, ano_var
    mov edx, 5
    int	SYS_CALL

    lea esi, [ano_var]
    mov ecx, 0x4
    call string_to_int
    mov [ano], eax

comparacoes:
    cmp dword [mes], 2
    jg calculo_zeller
    add dword [mes], 12
    dec dword [ano]
    
calculo_zeller:
    ; Aplicando a fórmula de Zeller
    ; dia_semana = (dia + ((a + 1) * 26) / 10 + b + b/4 + c/4 - c*5) % 7
    mov eax, dword [mes]            ; Carrega o valor de 'mes' em eax
    add eax, 1                      ; Adiciona o valor de '1' a eax
    mov dword [dia_semana], eax     ; Armazena o resultado em 'dia_semana'
    
    imul eax, 26                    ; multiplica por 26
    
    xor edx, edx
    mov cx, 10                      ; divide por 10 
    div cx

    add eax, dword[dia]             ; soma com o dia
    mov dword[dia_semana], eax
    
    ; b
    xor edx, edx 
    mov eax, dword [ano]   
    cdq                  
    mov cx, 100
    div cx             
    add dword[dia_semana], edx 
    add dword [var], edx  
    
    ; b/4
    mov eax, dword[var]
    xor edx, edx 
    mov cx, 4
    div cx
    add dword[dia_semana], eax 
  
    ; c/4 
    mov eax, dword [ano]
    xor edx, edx
    mov cx, 400
    div cx 
    add dword [dia_semana], eax
    
    ; c*5 
    mov eax, dword [ano]
    xor edx, edx
    mov cx, 100
    div cx 
    imul eax, 5
    add dword [dia_semana], eax 
    
    ; % 7 
    xor edx, edx 
    mov eax, dword [dia_semana]  
    cdq                 
    mov cx, 7
    div cx         
    int SYS_CALL
    
    ; Compara dia_semana com 0
    cmp edx, 0
    jne not_sabado

    ; Se for igual a 0, imprime a mensagem de sábado
    mov eax, SYS_WRITE
    mov ebx, STD_OUT      
    mov ecx, sabado_msg
    mov edx, tam_sab  
    int SYS_CALL    
    jmp fim
   
not_sabado:
    ; Compara dia_semana com 1
    cmp edx, 1
    jne not_domingo

    ; Se for igual a 1, imprime a mensagem de domingo
    mov eax, SYS_WRITE        
    mov ebx, STD_OUT        
    mov ecx, domingo_msg
    mov edx, tam_dom  
    int SYS_CALL  
    jmp fim

not_domingo:
    ; Compara dia_semana com 2
    cmp edx, 2
    jne not_segunda

    ; Se for igual a 2, imprime a mensagem de segunda
    mov eax, SYS_WRITE        
    mov ebx, STD_OUT      
    mov ecx, segunda_msg
    mov edx, tam_seg      
    int SYS_CALL  
    jmp fim


not_segunda:
    ; Compara dia_semana com 3
    cmp edx, 3
    jne not_terca

    ; Se for igual a 3, imprime a mensagem de terça
    mov eax, SYS_WRITE        
    mov ebx, STD_OUT        
    mov ecx, terca_msg
    mov edx, tam_ter      

    int SYS_CALL      
    jmp fim

not_terca:
    ; Compara dia_semana com 4
    cmp edx, 4
    jne not_quarta
    
    ; Se for igual a 4, imprime a mensagem de quarta
    mov eax, SYS_WRITE        
    mov ebx, STD_OUT        
    mov ecx, quarta_msg
    mov edx, tam_qua      
    int SYS_CALL        
    jmp fim

not_quarta:
    ; Compara dia_semana com 5
    cmp edx, 5
    jne not_quinta
    
    ; Se for igual a 5, imprime a mensagem de quinta
    mov eax, SYS_WRITE        
    mov ebx, STD_OUT      
    mov ecx, quinta_msg
    mov edx, tam_qui      
    int SYS_CALL  
    jmp fim

not_quinta:
    ; Compara dia_semana com 6
    cmp edx, 6
    jne nada

    ; Se for igual a 6, imprime a mensagem de sexta
    mov eax, SYS_WRITE        
    mov ebx, STD_OUT        
    mov ecx, sexta_msg
    mov edx, tam_sex      
    int SYS_CALL      
    jmp fim

nada:
    ; Caso não seja nenhum dos valores anteriores
    mov eax, SYS_WRITE        
    mov ebx, STD_OUT        
    mov ecx, nada_msg
    mov edx, tam_nada    
    int SYS_CALL
   
fim:
    ; Finalizar programa
    mov eax, SYS_EXIT                       ; sys_exit
    mov ebx, RET_EXIT                       ; error code 0 (success)
    int SYS_CALL                            ; chamar kernal
    
string_to_int:
   xor ebx, ebx
   
prox_digito_string:
   movzx eax, byte[esi]
   inc esi
   sub al, '0'
   imul ebx, 0xA
   add ebx, eax                             ; ebx = ebx*10 + eax
   loop prox_digito_string                  ; while (--ecx)
   mov eax, ebx
   ret