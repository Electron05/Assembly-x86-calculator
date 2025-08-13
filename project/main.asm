.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
text_welcome db 'Welcome to my calculator!', 10
welcome_length equ $ - text_welcome	

text_choose   db 'Choose operation:', 10
			  db '1. Addition', 10
			  db '2. Subtraction', 10
			  db '3. Multiplication', 10
			  db '4. Division', 10
			  db '5. Exit', 10
choose_length equ $ - text_choose

text_wrong_input db 'Invalid input. Please try again.', 10
wrong_input_length equ $ - text_wrong_input

addition_text db 'You chose addition.', 10
addition_length equ $ - addition_text

subtraction_text db 'You chose subtraction.', 10
subtraction_length equ $ - subtraction_text

multiplication_text db 'You chose multiplication.', 10
multiplication_length equ $ - multiplication_text

division_text db 'You chose division.', 10
division_length equ $ - division_text

exit_text db 'Exiting the program.', 10
exit_length equ $ - exit_text

buffer db 64 dup (0)
buffer_size dd 64

numbers_buffer dd 0, 0

enter_number_text db 'Enter two numbers (NumSpaceNumEnter): ', 0
enter_number_length equ $ - enter_number_text

.code

_print_choice PROC
	push ecx
	push eax
	push 1
	call __write
	add esp, 12
	ret
_print_choice ENDP

_get_numbers PROC ;1st number eax 2nd mnumber edx

	push ebx

	mov ecx, enter_number_length
	push ecx
	push OFFSET enter_number_text
	push 1
	call __write
	add esp, 12

	mov ecx, buffer_size
	push ecx
	push OFFSET buffer
	push 0
	call __read
	add esp, 12

	mov ebx, 10 ; base system
	mov edx, 0 
	mov eax, 0
	mov ecx, 0 ; iterator + 32nd bit bool "first number entered"

_lp:
	mov dl, BYTE PTR [buffer + cx]
	cmp dl, 32 ; edx = digit ascii
	je _number_entered 
	cmp dl, 10
	je _end
	sub dl, '0' ; ascii to int
	push edx
	mul ebx ; eax *= 10, resets edx
	pop edx
	add eax, edx 
_continue:
	inc ecx
	jmp _lp


_number_entered:
	push eax ; remember first number
	mov eax, 0
	jmp _continue
	
_end:
	mov edx, eax

	pop eax
	pop ebx
	ret

_get_numbers ENDP

_print_result PROC ;print eax

	push ebp
	mov ebp, esp
	sub esp, 8
	push ebx

	
	mov edi, ebp
	sub edi, 8
	mov ecx, 8

_clear:
	mov [edi], byte ptr '0'
	inc edi
	loop _clear

	dec edi ; edi = ebp-1
	mov [edi], byte ptr 10 ; insert line feed for future printing
	dec edi ; edi = ebp -2

	mov ebx, 10

_write:
	mov edx, 0
	div ebx  	   ; edx = remainder
	add edx, '0'   ; edx to int
	mov byte ptr [edi], dl ; edi goes from [ebp - 2] down
	dec edi
	cmp eax, 0
	je _end
	jmp _write

_end:

	lea ecx, [ebp-1]

	mov eax, ebp
	sub eax, edi
	sub eax, 2 ; eax = leagth of result

	sub ecx, eax

	add eax, 1 ; make room for line feed

	push eax
	push ecx
	push 1
	call __write
	add esp, 12

	pop ebx
	add esp, 8
	pop ebp
	ret
_print_result ENDP

_main PROC
	mov ecx, welcome_length

	push ecx
	push OFFSET text_welcome
	push 1
	call __write
	add esp, 12

	mov ecx, choose_length
	push ecx
	push OFFSET text_choose
	push 1
	call __write
	add esp, 12

_input_again:
	mov ecx, buffer_size

	push ecx
	push  OFFSET buffer
	push 0
	call __read
	add esp, 12

	cmp byte PTR [buffer], '1'
	je _addition
	cmp byte PTR [buffer], '2'
	je _subtraction
	cmp byte PTR [buffer], '3'
	je _multiplication
	cmp byte PTR [buffer], '4'
	je _division
	cmp byte PTR [buffer], '5'
	je _exit

	push OFFSET wrong_input_length
	push OFFSET text_wrong_input
	push 1
	call __write
	add esp, 12

	jmp _input_again


_addition:
	mov eax, OFFSET addition_text
	mov ecx, addition_length
	call _print_choice
	call _get_numbers
	add eax, edx
	call _print_result


	jmp _input_again


_subtraction:
	mov eax, OFFSET subtraction_text
	mov ecx, subtraction_length
	call _print_choice
	call _get_numbers
	sub eax, edx
	call _print_result

	jmp _input_again

_multiplication:
	mov eax, OFFSET multiplication_text
	mov ecx, multiplication_length
	call _print_choice
	call _get_numbers
	mul edx
	call _print_result

	jmp _input_again

_division:
	mov eax, OFFSET division_text
	mov ecx, division_length
	call _print_choice
	call _get_numbers

	jmp _input_again

_exit:
	push dword PTR 0
	call _ExitProcess@4
_main ENDP
END