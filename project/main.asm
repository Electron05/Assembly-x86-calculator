.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
public _main

.data
tekst db 'Nazywam sie Jakub' , 10
db 'Moj pierwszy 32-bitowy program '
db 'asemblerowy dziala juz poprawnie!', 10

.code
_main PROC
	mov ecx, 85 ; liczba znak�w wy�wietlanego tekstu

	push ecx ; liczba znak�w wy�wietlanego tekstu
	push dword PTR OFFSET tekst ; po�o�enie obszaru ze znakami
	push dword PTR 1 ; uchwyt urz�dzenia wyj�ciowego
	call __write ; wy�wietlenie znak�w

	add esp, 12 ; usuni�cie parametr�w ze stosu

	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END