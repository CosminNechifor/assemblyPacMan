.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

format db "%d ", 10, 0
window_title DB "Pacman", 0
area_width EQU 640
area_height EQU 600
area DD 0

directie dd 0

zona_x dd 0
zona_y dd 0

score DD 0 ;scorul

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

;de aceste constante aveam nevoie la x

doua_sute_cinci_zeci equ 250
doua_sute_opt_zeci equ 280
doua_sute equ 200
doua_sute_trei_zeci equ 230
o_suta_cinci_zeci equ 150
o_suta_opt_zeci equ 180

;de aceste constante aveam nevoie la y
cinci_sute_doua_zeci equ 520
cinci_sute_cinci_zeci equ 550
cinci_sute_sase_zeci equ 560
cinci_sute_noua_zeci equ 590
cinci_sute_patru_zeci equ 540
cinci_sute_sapte_zeci equ 570


executii dd 0

gameover dd 0
afisareGO dd 0

symbol_width EQU 10
symbol_height EQU 20
symbol_width_new EQU 30
symbol_height_new EQU 30

rows_columns EQU 18
pacman_l DD 15   ; 0 - 16
pacman_c DD  1   ; 0 - 17

aux_l DD 0			;le-am folosit la determinarea pozitiei urmatoare
aux_c DD 0

string_score db "Score:", 0
string_format db "%s ", 0
string_empry db "Empty!", 0
string_wall db "There's a wall in front of me!", 0
string_game_over db "GAME OVER!", 0

ZERO EQU 0
UNU EQU 1 
DOI EQU 2
TREI EQU 3
PATRU EQU 4

columns EQU 18
rows EQU 17

labyrinth0  DB 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3	
			DB 3, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 3	
			DB 3, 1, 3, 3, 3, 1, 1, 1, 3, 3, 1, 1, 1, 3, 3, 3, 1, 3 
			DB 3, 1, 1, 1, 1, 1, 3, 1, 3, 3, 1, 3, 1, 1, 1, 1, 1, 3	
			DB 3, 1, 3, 3, 3, 1, 3, 1, 3, 3, 1, 3, 1, 3, 3, 3, 1, 3	
			DB 3, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 3	
			DB 3, 1, 1, 3, 1, 3, 1, 3, 1, 1, 3, 1, 3, 1, 3, 1, 1, 3	
			DB 3, 1, 1, 1, 1, 3, 1, 3, 4, 4, 3, 1, 3, 1, 1, 1, 1, 3	
			DB 3, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 3	
			DB 3, 1, 1, 3, 1, 3, 1, 1, 1, 1, 1, 1, 3, 1, 3, 1, 1, 3	
			DB 3, 1, 3, 3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 3, 3, 1, 3
			DB 3, 1, 3, 3, 3, 1, 3, 3, 1, 1, 3, 3, 1, 3, 3, 3, 1, 3	
			DB 3, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 3	
			DB 3, 1, 1, 3, 1, 3, 1, 1, 3, 3, 1, 1, 3, 1, 3, 1, 1, 3	
			DB 3, 1, 3, 3, 3, 3, 1, 3, 3, 3, 3, 1, 3, 3, 3, 3, 1, 3	
			DB 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3	
			DB 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3

include digits.inc
include pacman.inc
include wall.inc
include letters.inc
include coin.inc
include ghost.inc
include empty.inc
include up.inc
include down.inc
include left.inc
include right.inc



include labyrinth1.inc


.code

sout macro x
	pusha
	push x
	push offset format
	call printf
	add esp, 8
	popa
endm

sout_score macro 
	push offset string_score
	push offset string_format
	call printf
	add esp, 8
endm

sout_game_over macro
	push offset string_game_over
	push offset string_format
	call printf
	add esp, 8
endm

sout_empty macro
	push offset string_empry
	push offset string_format
	call printf
	add esp, 8
endm

sout_wall macro
	push offset string_wall
	push offset string_format
	call printf
	add esp, 8
endm

reactualizare macro 
	pusha
	mov eax, pacman_c
	mov aux_c, eax
	mov eax, pacman_l
	mov aux_l, eax
	popa
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_text proc
	
	push ebp
	mov ebp, esp
	pusha
	cmp zona_x, 540		;reinitializez ca nu are cum sa adauge lin noua
	jl normal
	
	lea eax, zona_x
	mov ebx, 0
	mov [eax], ebx
	
normal:
	cmp zona_y, 480
	jg et_final
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	
	cmp eax, '+'
	je make_pacman	; jump to pacman
	
	cmp eax, '#'
	je make_wall	; jump to wall
	
	
	cmp eax, '!'
	je make_coin	; jump to coin
	
	cmp eax, '='
	je make_ghost	; jump to ghost
	
	cmp eax, '_'
	je make_empty
	
	cmp eax, '^'
	je make_uparrow
	
	cmp eax, '<'
	je make_leftarrow
	
	cmp eax, '>'
	je make_rightarrow
	
	cmp eax, '&'
	je make_downarrow
	
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;pacman
make_pacman:
	mov eax, 0
	lea esi, pacman
	raw_text_new:
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_pacman:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_pacman:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_pacman
	mov dword ptr [edi], 0FAFF00h 					;culoarea galbena
	jmp simbol_pixel_next_pacman
simbol_pixel_alb_pacman:
	mov dword ptr [edi], 3CACE3h					;culoarea albaastru deschis
simbol_pixel_next_pacman:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_pacman
	pop ecx
	loop bucla_simbol_pacman
	
	jmp et_final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end_pacman, 
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;wall

make_wall:
	mov eax, 0
	lea esi, wall
	
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_wall:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_wall:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_wall
	mov dword ptr [edi], 00094Bh 					;culoarea albastru
	jmp simbol_pixel_next_wall
simbol_pixel_alb_wall:
	mov dword ptr [edi], 0FFFFFFh					;culoarea alba
simbol_pixel_next_wall:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_wall
	pop ecx
	loop bucla_simbol_wall
	
	
	jmp et_final

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_wall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;coin

make_coin:
	mov eax, 0
	lea esi, coin
	
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_coin:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_coin:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_coin
	mov dword ptr [edi], 0FAFF00h 					;culoarea galbena
	jmp simbol_pixel_next_coin
simbol_pixel_alb_coin:
	mov dword ptr [edi], 3CACE3h					;culoarea alba
simbol_pixel_next_coin:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_coin
	pop ecx
	loop bucla_simbol_coin

	
	jmp et_final

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_coin


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ghost

make_ghost:
	mov eax, 0
	lea esi, ghost
	
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_ghost:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_ghost:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_ghost
	mov dword ptr [edi], 0C143Ch 					;culoarea albastru inchis
	jmp simbol_pixel_next_ghost
simbol_pixel_alb_ghost:
	mov dword ptr [edi], 3CACE3h					;culoarea alba
simbol_pixel_next_ghost:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_ghost
	pop ecx
	loop bucla_simbol_ghost
	
	jmp et_final

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_ghost

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;uparrow
make_uparrow:
	mov eax, 0
	lea esi, up
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_uparrow:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_uparrow:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_uparrow
	mov dword ptr [edi], 000302h 					;culoarea negru
	jmp simbol_pixel_next_uparrow
simbol_pixel_alb_uparrow:
	mov dword ptr [edi], 3CACE3h					;culoarea albaastru deschis
simbol_pixel_next_uparrow:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_uparrow
	pop ecx
	loop bucla_simbol_uparrow
	
	jmp et_final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_uparrow

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;downarrow
make_downarrow:
	mov eax, 0
	lea esi, down
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_downarrow:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_downarrow:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_downarrow
	mov dword ptr [edi], 000302h 					;culoarea negru
	jmp simbol_pixel_next_downarrow
simbol_pixel_alb_downarrow:
	mov dword ptr [edi], 3CACE3h					;culoarea albaastru deschis
simbol_pixel_next_downarrow:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_downarrow
	pop ecx
	loop bucla_simbol_downarrow
	
	jmp et_final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_downarrow

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;rightarrow
make_rightarrow:
	mov eax, 0
	lea esi, right
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_rightarrow:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_rightarrow:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_rightarrow
	mov dword ptr [edi], 000302h 					;culoarea negru
	jmp simbol_pixel_next_rightarrow
simbol_pixel_alb_rightarrow:
	mov dword ptr [edi], 3CACE3h					;culoarea albaastru deschis
simbol_pixel_next_rightarrow:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_rightarrow
	pop ecx
	loop bucla_simbol_rightarrow
	
	jmp et_final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_rightarrow

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;leftarrow
make_leftarrow:
	mov eax, 0
	lea esi, left
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_leftarrow:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_leftarrow:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_leftarrow
	mov dword ptr [edi], 000302h 					;culoarea negru
	jmp simbol_pixel_next_leftarrow
simbol_pixel_alb_leftarrow:
	mov dword ptr [edi], 3CACE3h					;culoarea albaastru deschis
simbol_pixel_next_leftarrow:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_leftarrow
	pop ecx
	loop bucla_simbol_leftarrow
	
	jmp et_final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_leftarrow



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;wall

make_empty:
	mov eax, 0
	lea esi, empty
	
	mov ebx, symbol_width_new
	mul ebx
	mov ebx, symbol_height_new
	mul ebx
	add esi, eax
	mov ecx, symbol_height_new
bucla_simbol_empty:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_new
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_new
bucla_simbol_coloane_empty:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_empty
	mov dword ptr [edi], 3CACE3h 					;culoarea albastru deschis
	jmp simbol_pixel_next_empty
simbol_pixel_alb_empty:
	mov dword ptr [edi], 3CACE3h					;culoarea albaastru deschis
simbol_pixel_next_empty:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_empty
	pop ecx
	loop bucla_simbol_empty
	
	jmp et_final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end_wall
	
	
	

	
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
	lea esi, letters
	
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
	mov dword ptr [edi], 000302h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	
et_final:

	
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; un macro ca sa apelam mai usor desenarea simbolului

	;;;;;
	;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;
	;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_pacman proc
	push ebp
	mov ebp, esp
	pusha
	
	make_text_macro '+', area, [ebp+arg1], [ebp+arg2]
	
	popa
	mov esp, ebp
	pop ebp
	ret
put_pacman endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;;;;;
		;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y

draw proc
	push ebp
	mov ebp, esp
	pusha
	
	
	mov eax, gameover 
	cmp eax, ZERO
	je continuare
	jmp afisareGame_over
	
	continuare:
		mov eax, [ebp+arg1]
		
		cmp eax, 0
		jz initializare
		
		cmp eax, 1
		jz modifica_pozitie
		;sout 2
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		     ;;;;; daca nu e diferit ( daca nu se da click )
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		cmp directie, UNU
		je apasat_stanga
		
		
		cmp directie, DOI
		je apasat_dreapta
		
		cmp directie, TREI
		je apasat_sus
		
		cmp directie, PATRU
		je apasat_jos
		
		
	jmp final_draw
	
	
	
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	initializare:
		mov eax, area_width
		mov ebx, area_height
		mul ebx
		shl eax, 2
		
		push eax
		push 255
		push area
		call memset				;void *memset(void *str, int c, size_t n)
		add esp, 12
		;sout 3
		;The C library function void *memset(void *str, int c, size_t n) copies the 
		;character c (an unsigned char) to the first n characters of the string pointed to, 
		;by the argument str.
		
		jmp afisare_matrice_score
	
	
	
modifica_pozitie:
	mov esi, 0 
	mov edi, 0
	
	mov esi, [ebp + arg2]      ;esi <- x
	mov edi, [ebp + arg3]	   ;edi <- y
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAI JOS SE VERIFICA CE BUTON A FOST APASAT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	; if( x >= 250 && x <= 280)
		; if(y >= 540 && y <= 570)
			; apasat_dreapta

	; else if( x >= 200 && x <= 230 ){
		; if(y >= 520 && y <=550)
			; apasat_sus
		; else if( y >= 560 && y <= 590)
			; apasat_jos
	; }
	; else if( x >= 150 && x <= 180){
		; if( y >= 540 && y <= 570 )
			; apasat_stanga
	; }
	
	
	
	verificare_dreapta:
	
		cmp esi, doua_sute_cinci_zeci
		jg dreapta_verificare_x
		jmp verificare_sus_jos
		
		dreapta_verificare_x:
			cmp esi, doua_sute_opt_zeci
			jle dreapta_verificare_y1
			jmp verificare_sus_jos
				
				dreapta_verificare_y1:
					cmp edi, cinci_sute_patru_zeci
					jge dreapta_verificare_y2
					jmp verificare_sus_jos
					
					dreapta_verificare_y2:
						cmp edi, cinci_sute_sapte_zeci
						jle apasat_dreapta_jmp
						jmp verificare_sus_jos
						
						apasat_dreapta_jmp:
							jmp apasat_dreapta
						
						
					
	verificare_sus_jos:
		cmp esi, doua_sute
		jge verificare_sus_jos2
		jmp verificare_stanga
		
		verificare_sus_jos2:
			cmp esi, doua_sute_trei_zeci
			jle verificare_sus
			jmp verificare_stanga
			
			verificare_sus:
				cmp edi, cinci_sute_doua_zeci
				jge verificare_sus2				;daca nu este mai mare ca 520 atunci 
				jmp verificare_stanga			;nu este mai mare nici decat 560 deci sarmim la urmatoarea verificare
				
				verificare_sus2:
					cmp edi, cinci_sute_cinci_zeci
					jle apasat_sus_jmp
					jmp verificare_jos
					
					apasat_sus_jmp:
						jmp apasat_sus
					
			verificare_jos:
				cmp edi, cinci_sute_sase_zeci
				jge verificare_jos2
				jmp verificare_stanga
					
				verificare_jos2:
					cmp edi, cinci_sute_noua_zeci
					jle apasat_jos_jmp
					jmp verificare_stanga
					
					apasat_jos_jmp:
						jmp apasat_jos
						
	
	verificare_stanga:
		cmp esi, o_suta_cinci_zeci
		jge verificare_stanga2
		jmp afisare_matrice_score				;sare fara sa se intample nimic
		verificare_stanga2:
			cmp esi, o_suta_opt_zeci
			jle verificare_stanga_y
			jmp afisare_matrice_score
				
			verificare_stanga_y:
				cmp edi, cinci_sute_patru_zeci
				jge verificare_stanga_y2
				jmp afisare_matrice_score
				
				verificare_stanga_y2:
					cmp edi, cinci_sute_sapte_zeci
					jle apasat_stanga_jmp
					jmp afisare_matrice_score
					
					apasat_stanga_jmp:
						jmp apasat_stanga
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;;;;;
		;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;IN FUNCTIE DE CE A FOST APASAT SE PRODUCE O MODIFICARE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	apasat_stanga:

		mov directie, UNU
		
		reactualizare
		mov eax, aux_c
		dec eax
		mov aux_c, eax
		
		jmp logica_matrice
		
		
	apasat_jos:
	
		
		mov directie, PATRU
		
		reactualizare
		mov eax, aux_l
		inc eax
		mov aux_l, eax
		
		jmp logica_matrice
		
		
	apasat_sus:
		
		mov directie, TREI
		
		reactualizare
		mov eax, aux_l
		dec eax
		mov aux_l, eax
		
		jmp logica_matrice
		
		
		
	; pacman_l DD 15   ; 0 - 16
	; pacman_c DD  1   ; 0 - 17
	; aux_l DD 15
	; aux_c DD 1
		
		
	apasat_dreapta:

		mov directie, DOI
		
		;macro_dreapta				;macro care seteaza directia dreapta urmand sa fie folosita la modificarea pozitiei precedente
		reactualizare				;macro care acualizeaza pozitiile 
		mov eax, aux_c
		inc eax						;cand se apasa dreapta este normal sa mergem la elemntul din dreapta pacmanului
		mov aux_c, eax
	
		jmp logica_matrice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		;;;;;
		;;;;;
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAI JOS SE DETERMINA POZITIA SPRE CARE SE DORESTE MUTAREA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	logica_matrice:
	
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; FORMULA care da pozitia in "matrice": [i][j]  =  [(i*c  + j)] ;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		XOR edx, edx
		mov ebx, aux_l			; ebx = aux_l;
		mov eax, columns		; EDX:EAX <- EAX * EBX    columns = 18 (numarul de elemente pe linie      
		mul ebx 				; eax *= ebx;
		mov ebx, eax			; ebx = eax;
		mov eax, aux_c			; eax = aux_c;
		
		add ebx, eax			; ebx += eax;
		
		lea esi, labyrinth0		; esi -> inceputul labyrinth0
		
		add esi, ebx			; esi -> pozitia viitoare a pacmanului
			
		;XOR EAX, EAX
		;MOV AL, byte ptr [esi] 		; AM VERIFICAT DACA POINTEAZA UNDE TREBUIE 
		;SOUT EAX						; RASPUNSUL ESTE DA intrucat ARATA VALOAREA URMATOARE 
										; IAR DACA de exemplu cand fac dreapta, imi arata pacmanul
	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;;;;;
		;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;AICI SE VERIFICA CE E PE POZITIA PE CARE SE DORESTE MUTAREA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		cmp byte ptr [esi], TREI
		je logica_matrice_zid2
		
		cmp byte ptr [esi], PATRU
		je logica_matrice_ghost2
												;;;;;VALOAREA CARE SE VERIFICA ESTE CEA CORECTA INTRUCAT AM VERIFICAT
		cmp byte ptr [esi], UNU
		je logica_matrice_coin2
		
		cmp byte ptr [esi], ZERO
		je logica_matrice_empty2

		
		logica_matrice_zid2:
			;sout 3
			jmp logica_matrice_zid
			
		logica_matrice_ghost2:
			;sout 4
			jmp logica_matrice_ghost
		
		logica_matrice_coin2:
			;sout 1
			jmp logica_matrice_coin
		
		logica_matrice_empty2:
			;sout 0
			jmp logica_matrice_empty
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		
		;;;;;
		;;;;;
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DACA ESTE ZID IN FATA LUI;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		logica_matrice_zid:
			reactualizare					; nu se intampla nimic iar valorile lui aux_l, aux_c revin la valoarea initiala
			sout_wall						; prin valoarea initiala se intelege pozitia pacmanului in labirint
		jmp afisare_matrice_score
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
			
		;;;;;	
		;;;;;	
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CAZUL IN CARE INTALNESTE O FANTOMA IN FATA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		logica_matrice_ghost:
			reactualizare					; aux_l, aux_c revin la valoarea initiala
			mov gameover, UNU
		jmp initializare_gameover
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		;;;;;
		;;;;;
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  LOGICA PENTRU CAZUL IN CARE SE AFLA UN COIN IN FATA PACMANULUI   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		logica_matrice_coin:
		
			xor eax, eax
			mov al, byte ptr [esi]
			;sout eax
			inc eax	
			;sout eax						;valoarea 1 este inc si devine 2-pacman 
			mov byte ptr [esi], al			;cu alte cuvine am modificat pozitia pacman in momentul de fata ar trebui sa apara 2 pacman
										
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;			Acum determin pozitia precedenta pentru a face locul ala gol		   ;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			
			
				
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; FORMULA care da pozitia in "matrice": [i][j]  =  [(i*c  + j)] ;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			XOR edx, edx
			mov ebx, pacman_l			; ebx = aux_l;
			mov eax, columns			; EDX:EAX <- EAX * EBX    columns = 18 (numarul de elemente pe linie      
			mul ebx 					; eax *= ebx;
			mov ebx, eax				; ebx = eax;
			mov eax, pacman_c			; eax = aux_c;
			
			add ebx, eax				; ebx += eax;
			
			lea esi, labyrinth0			; esi -> inceputul labyrinth0
			
			add esi, ebx				; esi -> pozitia pacmanului VECHI	
			
			xor eax, eax				
			; acum la pozitia aia se pune un patratel gol
			mov byte ptr [esi], al
			
			sout_score
			mov eax, score					;se mareste scorul
			inc eax
			
			sout eax
			mov score, eax
			
			
			;dupa se modifica pozitia pacmanului in variabile, intrucat cel nou se afla in alt loc
			mov eax, aux_l
			mov pacman_l, eax			
			mov eax, aux_c
			mov pacman_c, eax
		
		jmp afisare_matrice_score
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SFARSIT LOGICA PENTRU CAZUL IN CARE SE AFLA UN COIN IN FATA PACMANULUI   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	
		;;;;;
		;;;;;
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AICI E LA FEL DOAR CA NU O SA SE INCREMENTEZE SCORUL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		logica_matrice_empty:
			
			mov byte ptr [esi], DOI			;cu alte cuvine am modificat pozitia pacman in momentul de fata ar trebui sa apara 2 pacman
									
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;			Acum determin pozitia precedenta pentru a face locul ala gol		   ;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; FORMULA care da pozitia in "matrice": [i][j]  =  [(i*c  + j)] ;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			XOR edx, edx
			mov ebx, pacman_l			; ebx = aux_l;
			mov eax, columns			; EDX:EAX <- EAX * EBX    columns = 18 (numarul de elemente pe linie      
			mul ebx 					; eax *= ebx;
			mov ebx, eax				; ebx = eax;
			mov eax, pacman_c			; eax = aux_c;
			
			add ebx, eax				; ebx += eax;
			
			lea esi, labyrinth0			; esi -> inceputul labyrinth0
			
			add esi, ebx				; esi -> pozitia pacmanului VECHI	
			
			xor eax, eax
			; acum la pozitia aia se pune un patratel gol
			mov byte ptr [esi], al
					
			;dupa se modifica pozitia pacmanului in variabile, intrucat cel nou se afla in alt loc
			mov eax, aux_l
			mov pacman_l, eax			
			mov eax, aux_c
			mov pacman_c, eax
			
			sout_empty
			
		jmp afisare_matrice_score
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		
		;;;;;
		;;;;;
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
							;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							;;;;																				 ;;;;;;
							;;;;				IN CONTINUARE SE AFLA PARTEA CARE AFISEAZA MATRICEA MEREU,       ;;;;;;
							;;;;									MODIFICA SCORUL, 							 ;;;;;;
							;;;;								   AFISEAZA BUTOANELE							 ;;;;;;
							;;;;																				 ;;;;;;
							;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
afisare_matrice_score:		
	
	
	
	mov ecx, rows_columns

	; lea esi, labyrinth0
	; mov eax, 3					;asa am afisat doar sa verific daca apare gol la al4lea loc de pe ecran
	; mov byte ptr[esi+eax], 0
	
;mai jos avem parcurgerea unei matrici element cu element si adaugarea, verificarea elementelor din matrice dupa cum au fost codificate
;0 - liber
;1 - punct
;2 - pacman
;3 - zid
;4 - ghost
	mov eax, ZERO
	mov zona_x, eax
	mov eax, ZERO
	mov zona_y, eax
bucla_linii:
	lea esi, labyrinth0						;pozitia [0,0] a matricei labyrinth0
	mov ebx, 0									
	add ebx, rows_columns					;se aduna in ebx 18
	sub ebx, ecx							;ebx = ebx - ecx; ecx initial este 18 l-am folosit ca un i
	mov eax, rows_columns					;dimensiune
	mul ebx									;eax = eax * ebx   primul caz e primul element
	add esi, eax							;esi - pointer la linii
	
	
	
	push ecx								;am salvat ecx pe stiva ca sa tin minte I-ul de la for
	mov ecx, rows_columns					;si acum avem nev de ecx pt J ul de la for
	
	bucla_coloane:
		
	
		;mai jos este comparatia care determina
		;ce element o sa fie afisat pe ecran
		;zona_x, zona_y pointeri la ecran
		;zona_x se incrementeaza la fiecare parcurgere bucla_coloane
		;zona_y se incrementeaza la fiecare parcurgere bucla_linii
		cmp byte ptr [esi], ZERO				
		je nimic				;se creaza spatiu liber
		cmp byte ptr [esi], UNU
		je coin2				;se creaza un rombulet
		cmp byte ptr [esi], TREI
		je zid					;se creaza zidul
		cmp byte ptr [esi], DOI
		je pacman2				;se creaza pacman
		make_text_macro '=', area, zona_x, zona_y
		jmp mai_departe			;se continua interarea
	
	nimic:
		make_text_macro '_', area, zona_x, zona_y		; "_"  reprezinta un spatiu gol
		jmp mai_departe
	coin2:
		make_text_macro '!', area, zona_x, zona_y		; "!" reprezinta coinul
		jmp mai_departe
	pacman2:
		make_text_macro '+', area, zona_x, zona_y		; "+" reprezinta pacmanul
		jmp mai_departe
	zid:
	make_text_macro '#', area, zona_x, zona_y			; "#" reprezinta zidul
	
	mai_departe:	
		
		inc esi

		lea eax, zona_x				;aici se incrementezaza zona_x cu 30, deoarece in fisierul cu extensia .inc sunt 30 valori si avem nev din 30 in 30
		mov ebx, 30
		add [eax], ebx
	
		dec ecx
		cmp ecx, 0
		jz sare1
		
		mov eax, executii
		inc eax
		mov executii, eax
		
		jmp bucla_coloane
	sare1:
		pop ecx
		dec ecx
	
		lea eax, zona_y				;aici se incrementezaza zona_y cu 30, deoarece in fisierul cu extensia .inc sunt 30 valori si avem nev din 30 in 30
		mov ebx, 30
		add [eax], ebx
	
		lea eax, zona_x				;se aduce zona_x dla valoarea 0 pentru a fi refolosit
		mov ebx, 0
		mov [eax], ebx

		cmp ecx, 0					;cand ecx ajuge la val 0, adica cand se termina loop-urile se termina afisarea
		jz final_draw
	
		
		make_text_macro 'S', area, 10, 530
		make_text_macro 'C', area, 20, 530
		make_text_macro 'O', area, 30, 530
		make_text_macro 'R', area, 40, 530
		make_text_macro 'E', area, 50, 530
		
		make_text_macro '^', area, 200, 520
		make_text_macro '<', area, 150, 540
		make_text_macro '>', area, 250, 540
		make_text_macro '&', area, 200, 560
		
		
		
			;afisam valoarea scorului curent (sute, zeci si unitati)
		mov ebx, 10
		mov eax, score
		;cifra unitatilor
		mov edx, 0
		div ebx
		add edx, '0'
		make_text_macro edx, area, 90, 530
		;cifra zecilor
		mov edx, 0
		div ebx
		add edx, '0'
		make_text_macro edx, area, 80, 530
		;cifra sutelor
		mov edx, 0
		div ebx
		add edx, '0'
		make_text_macro edx, area, 70, 530
		;jmp final_draw
		
		
		jmp bucla_linii

	initializare_gameover:

		mov eax, area_width
		mov ebx, area_height
		mul ebx
		shl eax, 2
		
		push eax
		push 255
		push area
		call memset				;void *memset(void *str, int c, size_t n)
		add esp, 12
		sout_game_over
	jmp final_draw
	
		afisareGame_over:
			make_text_macro 'G', area, 300, 250
			make_text_macro 'A', area, 300, 250
			make_text_macro 'M', area, 320, 250
			make_text_macro 'E', area, 330, 250
		
			make_text_macro 'O', area, 350, 250
			make_text_macro 'V', area, 360, 250
			make_text_macro 'E', area, 370, 250
			make_text_macro 'R', area, 380, 250
			sout 3
			make_text_macro 'Y', area, 220, 270
			make_text_macro 'O', area, 230, 270
			make_text_macro 'U', area, 240, 270
			make_text_macro 'R', area, 250, 270
			
			make_text_macro 'S', area, 270, 270
			make_text_macro 'C', area, 280, 270
			make_text_macro 'O', area, 290, 270
			make_text_macro 'R', area, 300, 270
			make_text_macro 'E', area, 310, 270
			
			make_text_macro 'I', area, 330, 270
			make_text_macro 'S', area, 340, 270
			
			;afisarm scroul 
			;afisam valoarea scorului curent (sute, zeci si unitati)
			mov ebx, 10
			mov eax, score
			;cifra unitatilor
			mov edx, 0
			div ebx
			add edx, '0'
			make_text_macro edx, area, 370, 270
			;cifra zecilor
			mov edx, 0
			div ebx
			add edx, '0'
			make_text_macro edx, area, 360, 270
			;cifra sutelor
			mov edx, 0
			div ebx
			add edx, '0'
			make_text_macro edx, area, 350, 270
			
			;click
			make_text_macro 'C', area, 220, 290
			make_text_macro 'L', area, 230, 290
			make_text_macro 'I', area, 240, 290
			make_text_macro 'C', area, 250, 290
			make_text_macro 'K', area, 260, 290
			
			;to
			make_text_macro 'T', area, 280, 290
			make_text_macro 'O', area, 290, 290
			
			;play
			make_text_macro 'P', area, 310, 290
			make_text_macro 'L', area, 320, 290
			make_text_macro 'A', area, 330, 290
			make_text_macro 'Y', area, 340, 290
			
			;again
			make_text_macro 'A', area, 360, 290
			make_text_macro 'G', area, 370, 290
			make_text_macro 'A', area, 380, 290
			make_text_macro 'I', area, 390, 290
			make_text_macro 'N', area, 400, 290
			
			mov eax, [ebp+arg1]
				
			cmp eax, UNU
			je resetare
			jmp final_draw
			
			resetare:
				mov gameover, ZERO 
				mov afisareGO, ZERO 
				mov pacman_l, 15
				mov pacman_c, 1
				mov score, 0
				
				lea esi, labyrinth0
				lea edi, labyrinth1
				
				xor edx, edx
				mov eax, rows
				mov ebx, columns
				mul ebx
				dec eax
				
				mov ecx, eax 
				
				restart:
					mov al, byte ptr [edi + ecx] 
					mov byte ptr[esi + ecx], al
				loop restart

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
