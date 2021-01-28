stacksg SEGMENT PARA STACK 'yigin'
		DW 32 DUP (?)
stacksg ENDS
datasg SEGMENT PARA 'veri'
		CR EQU 13
		LF EQU 10
        MSG_ELEMAN_SAYISI DB 'Eleman sayisini giriniz :' ,0
		MSG DB ' sayiyi giriniz :' ,0
		HATA DB ' ' ,0
        NOTUCGEN DB 'Ucgen bulunamadİ' ,0
		ELEMAN_SAYISI DW ?
		ARR_KENAR  DW 100 DUP(?)
		MIN_KENAR1 DW 1001
		MIN_KENAR2 DW 1001
		MIN_KENAR3 DW 1001
		MIN DW 3003
		I DW 0
		J DW 0
		check DB 0
datasg ENDS
codesg SEGMENT PARA 'kod'
			ASSUME CS:codesg, SS:stacksg, DS:datasg
ANA PROC FAR
			PUSH DS
			XOR AX, AX
			PUSH AX
			MOV AX, datasg
			MOV DS,AX
														;********** DİZİNİN BOYUTUNU ALMA ****************
			MOV AX , OFFSET MSG_ELEMAN_SAYISI			; Eleman sayisini giriniz mesajını AX'e alıyor
		DIZI_AL:
			CALL PUT_STR								; Eleman sayisini giriniz mesajını yaxdırıyor
			CALL GETN									; Girilen sayiyi AX'e alıyor
			MOV ELEMAN_SAYISI, AX						; datasg'deki değişkene Ax'İ atiyor
			CMP AX,3									; Eğer dizinin boyutunu 3 ile karşılaştırıyor
			JL DIZI_AL									; Eğer 3'ten küçükse DIZI_AL Labelına atlıyor
														;***************** DİZİNİN ELEMANLARINI ALMA **********************
			MOV CX, AX									; Eğer 3'ten büyük eşitse Döngüde kullanmak için CX'e AX'i atıyor	
			MOV BX, 1									; Elemanı giriniz mesajını yazdırırken kacıncı elaman olduğunu tutuyor
			XOR SI, SI									; Dizide indis olarak kullanmak için SI'yı sıfırlıyor 
	FOR_GETN:
			MOV AX, BX									; AX,e BX'deki değeri alıp yazdırıyor
			CALL PUTN							
		SAYI_AL:	
			MOV AX, OFFSET MSG							; AX'e Elemanı giriniz mesajını alıyor
			CALL PUT_STR								; AX'deki mesajı yazdırıyor
			CALL GETN									; Elemanı alıyorum AX'te tutuyor
			CMP AX, 1									; Aldığımız elemanı 1 ile karşılaştırıyor
			JL SAYI_AL									; Eğer eleman 1'den küçükse tekrar eleman alıyor			
			CMP AX, 1000								; Aldığımız elemanı 1000 ile karşılaştırıyor	                
			JA SAYI_AL									; Eğer eleman 1000'den büyükse tekrar eleman alıyor
			MOV ARR_KENAR[SI], AX						; Alınan elemanı ARR_KENAR dizisinin SI indisine atıyor
			ADD SI, 2									; ARR_KENAR dizisi word olduğu için indisi yani SI'yı 2 arttırıyor
			INC BX										; BX'i bir sonraki elemanı alırken yazdırmak için 1 arttırıyor
			LOOP FOR_GETN								; Eleman sayisi kadar bu döngü dönüyor			

														;**************SELECTİON SORT**************** 
			XOR SI, SI									;Diziyi sortlamak için SI'yı sıfırlıyor
			MOV DI, SI								 	;DI'yı indis olarak kullanacağımız için DI'ya SI'yı atıyor
			ADD DI, 2									;DI'yı ARR_KENAR dizisi word olduğu için 2 arttırıyor 
			MOV CX, ELEMAN_SAYISI						;CX'e dizinin eleman sayısını atıyor
			DEC CX										;SORT için eleman sayısından 1 az dönmemiz gerektiği için CX'i 1 azaltıyor
	SORT_FOR1:
			PUSH CX										;İç içe döngüler olduğu için 1. Döngüye girdikten sonra 2. Döngüde kullanmak için ve değeri kaybetmemek için CX'i pushluyor 
			MOV CX, ELEMAN_SAYISI						;İçteki Döngünü için CX'e dizinin eleman sayisini atiyor
			SUB CX, I									;Dıştaki döngünün kaç defa döndüğünü tutmak için tanımladığım I değerini CX'ten çıkarıyor
			DEC CX										;Ve CX'i 1 azaltıyor (Yani dıştaki döngü for(i=0;i<n;i++) ise içteki döngü for(j=0;j<n-i;j++) oluyor)
				SORT_FOR2:
					MOV BX, ARR_KENAR[DI]				; DADDR-DADDR karşılaştırması yapamayacağımız için BX'e ARR_KENAR DI indisindeki elemanı atıyor
					CMP ARR_KENAR[SI], BX				; ARR_KENAR SI indisindeki eleman ile BX'i karşılaştırıyor
					JBE EXIT							; Eğer SI indisindeki DI indisindekinden küçük eşitse EXIT Labelına zıplıyor
					XCHG BX, ARR_KENAR[SI]				; Eğer SI indisindeki DI indisindekinden buyukse yer değistiriyor
					MOV ARR_KENAR[DI], BX				; DI indisindeki elemanı BX'te tuttuğumuz i
				EXIT:								
					ADD DI, 2							; Daha sonra diğer karşılaştırma için DI'yı word olduğu için 2 arttırıyor
					LOOP SORT_FOR2						; Ve bu döngüyü CX defa yapıyor (yani j<n-i defa) ve sonuc olarak dizideki en küçük olaman en başdaki indise geliyor;
			POP CX                                      ; İçteki döngü bittiğinde pushladığım yani dıştakı döngü için kullandığımız CX değerini popluyor
			ADD SI, 2									; Dizinin ilk elemanında artık dizideki en küçük eleman olduğu için SI'yı 2 arttırıyor 
			MOV DI, SI									; DI'ya SI'daki değeri atıyor 
			ADD DI, 2                                   ; DI'yı 2 arttırıyor ve yani bir sonraki döngüde SI'daki indise 2. küçük elemanı atıcak
			INC I										; Dıştaki döngünün kaç defa döndüğünü tutmak için tanımladığım I değerini dıştaki döngünün sonunda 1 arttırıyor
			LOOP SORT_FOR1								; Ve Döngüyü CX defa döndürüyor 
														; Bu döngüler bittikten sonra elimizde sıralı bir dizi oluyor
														; ****************EN KÜÇÜK ÜÇGENİ BULMA***************		
			MOV CX, ELEMAN_SAYISI 						; CX'i döngüde kullanacağımız için CX'e eleman sayisini atıyoruz
			SUB CX, 2									; CX'ten 2 çıkarıyoruz (yani döngü for(i=0;i<n-2;i++) şekline olacak
			XOR SI, SI									; SI'yı indis olarak kullanabilmek için sıfırlıyor
			MOV DI,SI									; DI'ya SI'yı atıyor çünkü kontrol ederken üçgenin kenarları ARR_KENAR[SI],ARR_KENAR[DI],ARR_KENAR[DI+2] olarak seçilecek
			ADD DI, 2									; DI indisine SI'nın bir fazlasını atıyoruz yani dizi word olduğu için 2 ile topluyor
			MOV BX, ELEMAN_SAYISI						; Kullanacağımız yöntemde for
			SUB BX, 2									; while döngüsünün eleman sayisi -2 -j(
														
	FOR3:															
			MOV check, 0                                ; While döngüsüne girmeden önce her defa check değişkenine 0 atıyor
			INC J										; Dıştaki döngünün kaç defa döndüğünü tutmak için tanımladığımız j 1 artıyor	
				WHİLE:                           
					DEC BX                              ; While dögüsünün içinde 2 tane şart kullandım bu şartlar (BX>0 ve check=0) ve while döngüsüne girdiğimizde BX'i 1 azaltıyor
					MOV AX, ARR_KENAR[DI+2]				; Dizi sıralı olduğu için büyük olan sayıyı AX'e alıyor
					MOV DX, ARR_KENAR[DI]				; Küçük olan sayıyı DX'e alıyor
					SUB AX, DX							; Üçgen oluşturma kuralı (|kenar
                    MOV DX, ARR_KENAR[SI]               ; DX'e SI indisindeki sayıyı atıyor
					CMP AX, DX							; Ve mutlak farkı (AX'te tutuyoruz) ile kenarı (DX'te tutuyoruz) karşılaştırıyor
					JAE EXİT							; Eğer mutlak fark bnüyük eşitse EXİT Labelına zıplıyor
					PUSH DX								; Daha sonra kenarı (DX'i) saklamak için pushluyoruz çünkü DX üzerinden üzerinden işlem yapacak					
					MOV AX, ARR_KENAR[DI]				; Kenarların toplamını bulmak için AX'e bir kenarı atıyor
					MOV DX,ARR_KENAR[DI+2]				; Diğer kenarı da DX'e atıyor
					ADD AX, DX							; Bu iki kenarı topluyor ve AX'te tutuyor
					POP DX								; Pushladığımız kenarı(sayıyı) popluyoruz
					CMP DX,AX							; Ve iki kenarın toplamı ile kenarı karşılaştırıyor
					JAE EXİT							; Eğer kenar ,iki kenarın toplamından büyük eşit ise EXİT Labelına zıplıyor
					ADD AX,DX							; Eğer program bu
					CMP AX,MIN							; Oluşan üçgenin çevresini (AX'te tutuyor), Mın ile karşılaştırıyor
					JAE EXİT							; Eğer üçgenin cevresi mın değerinden büyük eşitse EXIT Labelına zıplıyor
					MOV check, 1						; while içinde SI sab
					MOV MIN, AX                         ; Program buraya geldiyse bir üçgen oluştu ve çevresi mın değerinden küçük bu yüzden mın değerine üçgenin çevresini atıyoruz
					MOV AX, ARR_KENAR[SI]               ; Bu bölümdede üçgenin kenarlarını tutmak 
					MOV MIN_KENAR1, AX
					MOV AX, ARR_KENAR[DI]
					MOV MIN_KENAR2, AX
					MOV AX, ARR_KENAR[DI+2]
					MOV MIN_KENAR3 ,AX
				EXİT:
				MOV AL, check							; While döngüsü içinde kenarları üçgen için uygun sayılar bulunursa check'e 1 atıyorduk, check kontrol etmek için AL'ye checki atıyoruz 	
				CMP AL, 0								; AL(check) ile 0 karşılaştırıyoruz
				JNE FLOOP 								; AL(check) 0'a eşit de
				ADD DI, 2								; Eğer buraya geldiyse while içinde hala bir üçgen bulamamışız demektir bu yüzden DI indisini word olduğu için 2 arttırıyor
				CMP BX,0								; Burda BX'i ile 0 karşılaştırıyoruz
				JNE WHİLE                               ; Eğer BX =0 ise üçgen kontrolu ya
		FLOOP:
			ADD SI, 2									; Buraya geldiyse while döngüsü bitmiştir ve SI indisini arttırıyor
			MOV DI, SI                                  ; DI'yı SI'ya eşitliyor
			ADD DI, 2									; DI'yı 2 arttırıyor
			MOV BX, ELEMAN_SAYISI						; While döngüsüne BX<eleman sayisi -2-j kadar dönmesi beklenir bu yüzden BX'e ilk eleman sayisini atıyor
			SUB BX, 2									; BX'ten 2 çıkartıyor
			SUB BX, J									; Sonra BX'ten dıştaki for döngüsünün kaç defa döndüğünü tutan j sayisini çıkartıyor
			LOOP FOR3									; CX 0'a eşir olana kadar FOR3 döngüsünde dönüyor
			MOV AX, MIN									; Burada Mın data segmentte atadığımız 3003 değeri ile karşılaştırıyoruz eğer mın 3003'e eşit değil ise bir üçgen bulunmuş demektir
			CMP AX, 3003								; AX (min) ile 3003 sayisini karşılaştırıyor
			JE UCGEN_YOK								; Eğer eşitlerse UCGEN_YOK Labelına zıplıyor											
			MOV AX, MIN_KENAR1                          ; Burada PUTN fonk
			CALL PUTN									; AX'deki kenar uzunluğunu ekrana yazdırıyor
			MOV AX, MIN_KENAR2							
			CALL PUTN
			MOV AX, MIN_KENAR3
			CALL PUTN				
			JMP CIKIS									; UCGEN_YOK labelına girmemek için zıplıyor	
		UCGEN_YOK:										; Eğer min =3003 ise buraya zıplıyorduk 
			MOV AX ,OFFSET NOTUCGEN						; AX'e stringi atıyor
			CALL PUT_STR								; AX'deki stringi ekrana yazıyor
		CIKIS:
	RETF
ANA ENDP
GETC PROC NEAR
        MOV AH, 1h
		INT 21H
		RET
GETC ENDP
PUTC PROC NEAR
		PUSH AX
		PUSH DX
		MOV DL, AL
		MOV AH, 2
		INT 21H
		POP DX
		POP AX
		RET
PUTC ENDP		
GETN PROC NEAR
		PUSH BX
		PUSH CX
		PUSH DX 
	GETN_START:
		MOV DX,1	
		XOR BX, BX
		XOR CX, CX
	NEW:
		CALL GETC
		CMP AL, CR
		JE FIN_READ
		CMP AL, '-'
		JNE CTRL_NUM
	NEGATIVE:
		MOV DX, -1
		JMP NEW
	CTRL_NUM:
		CMP AL, '0'
		JB ERROR
		CMP AL, '9'
		JA ERROR
		SUB AL, '0'
		MOV BL, AL
		MOV AX, 10
		PUSH DX
		MUL CX
		POP DX
		MOV CX , AX
		ADD CX, BX
		JMP NEW
	ERROR:
		MOV AX, OFFSET HATA
		CALL PUT_STR 
		JMP GETN_START
	FIN_READ:
		MOV AX, CX
		CMP DX, 1
		JE FIN_GETN
		NEG AX
		FIN_GETN:
		POP DX
		POP CX
		POP BX
		RET
GETN ENDP		
PUTN PROC NEAR
		PUSH CX
		PUSH DX
		XOR DX, DX
		PUSH DX
		MOV CX, 10
		CMP AX, 0
		JGE CALC_DIGITS
		NEG AX
		PUSH AX
		MOV AL, '-'
		CALL PUTC
		POP AX
	CALC_DIGITS:
		DIV CX
		ADD DX, '0'
		PUSH DX
		XOR DX, DX
		CMP AX, 0
		JNE CALC_DIGITS
	DISP_LOOP:
		POP AX
		CMP AX, 0
		JE END_DISP_LOOP
		CALL PUTC
		JMP DISP_LOOP
	END_DISP_LOOP:
	POP DX
	POP CX
	RET
PUTN ENDP
PUT_STR PROC NEAR
		PUSH BX
		MOV BX, AX
		MOV AL, BYTE PTR [BX]
	PUT_LOOP:
		CMP AL, 0
		JE PUT_FIN
		CALL PUTC
		INC BX
		MOV AL, BYTE PTR [BX]
		JMP PUT_LOOP
	PUT_FIN:
		POP BX
		RET
PUT_STR ENDP
codesg ENDS
		END ANA		
