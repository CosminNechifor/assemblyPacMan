.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Pacman",0
area_width EQU 640
area_height EQU 480
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 30
symbol_height EQU 30
include digits.inc
include pacman.inc
include wall.inc


          ;  0  1  2  3  4  5  6  7  8  9 10 11  12 13 14 15 16 17 
labyrinth DB 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,	;0
		  DB 3, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 3,	;1
		  DB 3, 1, 3, 3, 3, 1, 1, 1, 3, 3, 1, 1, 1, 3, 3, 3, 1, 3, 	;2
		  DB 3, 1, 1, 1, 1, 1, 3, 1, 3, 3, 1, 3, 1, 1, 1, 1, 1, 3,	;3
		  DB 3, 1, 3, 3, 3, 1, 3, 1, 3, 3, 1, 3, 1, 3, 3, 3, 1, 3,	;4
		  DB 3, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 3,	;5
		  DB 3, 1, 1, 3, 1, 3, 1, 3, 1, 1, 3, 1, 3, 1, 3, 1, 1, 3,	;6
		  DB 3, 1, 1, 1, 1, 3, 0, 3, 4, 4, 3, 0, 3, 1, 1, 1, 1, 3,	;7
		  DB 3, 3, 3, 1, 3, 3, 0, 0, 3, 3, 0, 0, 3, 3, 1, 3, 3, 3,	;8
		  DB 3, 1, 1, 1, 1, 1, 0, 3, 3, 3, 3, 0, 1, 1, 1, 1, 1, 3,	;9
		  DB 3, 1, 1, 3, 1, 3, 0, 0, 0, 0, 0, 0, 3, 1, 3, 1, 1, 3,	;9
		  DB 3, 1, 3, 3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 3, 3, 1, 3,	;10
		  DB 3, 1, 3, 3, 3, 1, 3, 3, 1, 1, 3, 3, 1, 3, 3, 3, 1, 3,	;11
		  DB 3, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 3,	;12
		  DB 3, 1, 1, 3, 1, 3, 1, 1, 3, 3, 1, 1, 3, 1, 3, 1, 1, 3,	;13
		  DB 3, 1, 3, 3, 3, 3, 1, 3, 3, 3, 3, 1, 3, 3, 3, 3, 1, 3,	;14
		  DB 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3,	;16
		  DB 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3	;17


.code

make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, pacman
	jmp draw_text
	
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, pacman
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0FAFF00h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului

make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y

draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	;jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	

bucla_linii:
	mov eax, [ebp+arg2]
	and eax, 0FFh
	; provide a new (random) color
	mul eax
	mul eax
	add eax, ecx
	push ecx
	mov ecx, area_width
	
bucla_coloane:
	mov [edi], eax
	add edi, 4
	add eax, ebx
	loop bucla_coloane
	pop ecx
	loop bucla_linii
	jmp afisare_litere
	
evt_timer:
	inc counter
	
	

afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	;make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	;make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	;make_text_macro edx, area, 10, 10
	
	;scriem un mesaj
	make_text_macro 'A', area, 10, 100
	;make_text_macro 'R', area, 20, 100
	;make_text_macro 'O', area, 30, 100
	;make_text_macro 'I', area, 40, 100
	;make_text_macro 'E', area, 50, 100
	;make_text_macro 'C', area, 60, 100
	;make_text_macro 'T', area, 70, 100
	
	;make_text_macro 'L', area, 130, 120
	;make_text_macro 'A', area, 140, 120
	
	;make_text_macro 'A', area, 100, 140
	;make_text_macro 'S', area, 110, 140
	;make_text_macro 'A', area, 120, 140
	;make_text_macro 'M', area, 130, 140
	;make_text_macro 'B', area, 140, 140
	;make_text_macro 'L', area, 150, 140
	;make_text_macro 'A', area, 160, 140
	;make_text_macro 'R', area, 170, 140
	;make_text_macro 'E', area, 180, 140

final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp


start:
	;aici se scrie codul
	
	mov eax, area_width         ;eax = area_width
	mov ebx, area_height     	;ebx = area_height
	mul ebx                   	;eax = eax * ebx
	shl eax, 2					;eax = eax * 4
	
	;void *malloc(size_t size)
	push eax					
	call malloc					;we use the malloc 
	add esp, 4					;function to allocate enough space in memory
	
	mov area, eax
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, 
	;							unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing		
	add esp, 20
	
	
	;terminarea programului
	push 0
	call exit
end start
