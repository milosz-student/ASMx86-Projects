; Program gwiazdki.asm
; Wyświetlanie znaków * w takt przerwań zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakończenie programu po naciśnięciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16

ASSUME CS:rozkazy
kolor db 0
zapisz_znak db 0


;============================================================
; procedura obsługi przerwania zegarowego
obsluga_zegara PROC
	; przechowanie używanych rejestrów
	push ax
	push bx
	push es

	inc cs:licznik_czasu
	cmp cs:licznik_czasu,18
	jb nic_sie_nie_stalo
	mov cs:licznik_czasu,0
	; wpisanie adresu pamięci ekranu do rejestru ES - pamięć
	; ekranu dla trybu tekstowego zaczyna się od adresu B8000H,
	; jednak do rejestru ES wpisujemy wartość B800H,
	; bo w trakcie obliczenia adresu procesor każdorazowo mnoży
	; zawartość rejestru ES przez 16
	mov ax, 0B800h ;adres pamięci ekranu
	mov es, ax
	; zmienna 'licznik' zawiera adres bieżący w pamięci ekranu
	mov bx, cs:licznik
	; przesłanie do pamięci ekranu kodu ASCII wyświetlanego znaku
	; i kodu koloru: biały na czarnym tle (do następnego bajtu)
	mov al,zapisz_znak


	cmp bx,0
	je od_nowa

	mov byte PTR es:[bx-2], al
	mov byte PTR es:[bx-1], 7 ; kolor bialy


	jmp kontynuuj
od_nowa:
	mov byte PTR es:[3998], al
	mov byte PTR es:[3999], 7 ; kolor bialy


kontynuuj:
	mov al,byte PTR es:[bx]
	mov zapisz_znak,al ; zapisanie znaku
	mov byte PTR es:[bx], '*' ; kod ASCII

	mov al, kolor
	cmp al,15
	jne dalej
	mov al,1
dalej:
	mov byte PTR es:[bx+1], al ; kolor
	add al,1
	mov kolor,al
	; zwiększenie o 2 adresu bieżącego w pamięci ekranu
	add bx,2
	; sprawdzenie czy adres bieżący osiągnął koniec pamięci ekranu
	cmp bx,4000
	jb wysw_dalej ; skok gdy nie koniec ekranu
	; wyzerowanie adresu bieżącego, gdy cały ekran zapisany
	mov bx, 0
	;zapisanie adresu bieżącego do zmiennej 'licznik'
	wysw_dalej:
	mov cs:licznik,bx

nic_sie_nie_stalo:

	pop es
	pop bx
	pop ax
	; skok do oryginalnej procedury obsługi przerwania zegarowego
	jmp dword PTR cs:wektor8
	; dane programu ze względu na specyfikę obsługi przerwań
	; umieszczone są w segmencie kodu
	licznik dw 3600 ; wyświetlanie począwszy od 2. wiersza
	;licznik dw 320 ; wyświetlanie począwszy od 2. wiersza
	wektor8 dd ?
	licznik_czasu db 0
obsluga_zegara ENDP
;============================================================
; program główny - instalacja i deinstalacja procedury
; obsługi przerwań
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS
	; odczytanie zawartości wektora nr 8 i zapisanie go
	; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamięci 4 bajty
	; począwszy od adresu fizycznego 8 * 4 = 32)
	mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
	mov cs:wektor8, eax

	; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_zegara ; część segmentowa adresu
	mov bx, OFFSET obsluga_zegara ; offset adresu
	cli ; zablokowanie przerwań
	; zapisanie adresu procedury do wektora nr 8
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
	sti ;odblokowanie przerwań
	; oczekiwanie na naciśnięcie klawisza 'x'
	aktywne_oczekiwanie:
	mov ah,1
	int 16H
	; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeśli
	; naciśnięto jakiś klawisz
	jz aktywne_oczekiwanie
	; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0)
	; do rejestru AL
	mov ah, 0
	int 16H
	cmp al, 'x' ; porównanie z kodem litery 'x'
	jne aktywne_oczekiwanie ; skok, gdy inny znak
	; deinstalacja procedury obsługi przerwania zegarowego
	; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax ; przesłanie wartości oryginalnej
	; do wektora 8 w tablicy wektorów
	; przerwań
	sti
	; zakończenie programu
	mov al, 0
	mov ah, 4CH
	int 21H
	rozkazy ENDS
	nasz_stos SEGMENT stack
	db 128 dup (?)
	nasz_stos ENDS
END zacznij
