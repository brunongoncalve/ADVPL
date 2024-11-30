#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - PDF ESPELHO
PDF ESPELHO
@author    BRUNO NASCIMENTO GON�ALVES
@since     25/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------
 
USER FUNCTION xTESTE1()

    LOCAL lAdjustToLegacy := .F.
    LOCAL lDisableSetup   := .T.
    LOCAL cLocal          := "\spool"
    LOCAL cQuery          := ""
    LOCAL cQuery1         := ""
    LOCAL nVert           := 328
    LOCAL nVert1          := 330
    LOCAL nVert2          := 340
    LOCAL nVert3          := 338
    LOCAL nVert4          := 440
    LOCAL nVert5          := 460
    LOCAL nHori           := 320
    LOCAL nHori1          := 355
    LOCAL nI              := 0
    LOCAL aFont           := TFont():New("Courier New",,9,.T.)
    LOCAL oPrinter

    oPrinter := FWMSPRINTER():NEW("exemplo.rel",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,)
    
    cQuery := " SELECT DISTINCT " + CRLF
    cQuery += " C.[A1_CGC], " + CRLF
	cQuery += " C.[A1_NOME], " + CRLF
	cQuery += " C.[A1_END], " + CRLF
	cQuery += " C.[A1_EST], " + CRLF
	cQuery += " C.[A1_MUN], " + CRLF
	cQuery += " C.[A1_INSCR], " + CRLF
    cQuery += " A.[ZZW_NUM], " + CRLF
    cQuery += " B.[ZZY_NF] " + CRLF
    cQuery += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF 
    cQuery += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
    cQuery += " ON A.[ZZW_NUM] = B.[ZZY_NUM] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " C " + CRLF 
    cQuery += " ON A.[ZZW_CLI] = C.[A1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '60000010'"

    cAlias := MPSYSOPENQUERY(cQuery)

    WHILE (cAlias)->(!EOF())
        oPrinter:STARTPAGE()
        oPrinter:BOX(20,5,70,100,"-5")
        oPrinter:SAYBITMAP(27,10,"C:\Logo\logo_novo.png",90,28)
        oPrinter:BOX(20,100,70,500,"-5")
        oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLU��O")
        oPrinter:BOX(20,500,70,590,"-5")
        oPrinter:SAY(35,505,"N DA DEVOLU��O")
        oPrinter:SAY(50,505,"8")
        oPrinter:SAY(65,505,"28/03/2024")
        oPrinter:SAY(90,10,"1 - Remetente")
        oPrinter:BOX(150,5,100,590,"-5")
        oPrinter:SAY(170,10,"2 - Natureza de Opera��o")
        oPrinter:BOX(180,5,200,590,"-5")
        oPrinter:SAY(193,10,"Devolu��o")
        oPrinter:SAY(220,10,"3 - Destinat�rio")
        oPrinter:BOX(230,5,280,590,"-5")
        oPrinter:SAY(300,10,"4 - Dados do Produto")
        oPrinter:BOX(310,5,320,590,"-5")
        oPrinter:SAY(318,10,"ITEM",aFont)
        oPrinter:SAY(318,40,"DESCRI��O DO PRODUTO",aFont)
        oPrinter:SAY(318,190,"CL FISCAL",aFont)
        oPrinter:SAY(318,235,"CFOP",aFont)
        oPrinter:SAY(318,260,"UM",aFont)
        oPrinter:SAY(318,275,"QTDE",aFont)
        oPrinter:SAY(318,300,"VL UNIT",aFont)
        oPrinter:SAY(318,335,"VL TOTAL",aFont)
        oPrinter:SAY(318,420,"BASE ICMS",aFont)
        oPrinter:SAY(318,470,"VL ICMS",aFont)
        
        cQuery1 := " SELECT B.[ZZY_PROD], " + CRLF
        cQuery1 += " A.[ZZW_NUM], " + CRLF
        cQuery1 += " B.[ZZY_NUM], " + CRLF
        cQuery1 += " B.[ZZY_NF], " + CRLF
        cQuery1 += " SUBSTRING(D.[B1_DESC],1,31) AS [B1_DESC], " + CRLF
        cQuery1 += " D.[B1_POSIPI], " + CRLF
        cQuery1 += " E.[ZA2_CFOPIM], " + CRLF
        cQuery1 += " C.[D2_UM], " + CRLF
        cQuery1 += " B.[ZZY_QTD], " + CRLF
        cQuery1 += " C.[D2_PRCVEN], " + CRLF
        cQuery1 += " C.[D2_PRCVEN] * B.[ZZY_QTD] AS [D2_TOTAL], " + CRLF
        cQuery1 += " C.[D2_BASEICM] * B.[ZZY_QTD] AS [D2_BASEICM], " + CRLF
        cQuery1 += " C.[D2_BASEICM] * C.[D2_PICM] AS [D2_VALICM], " + CRLF
        cQuery1 += " C.[D2_PRCVEN] * C.[D2_IPI] AS [D2_VALIPI] , " + CRLF
        cQuery1 += " C.[D2_PICM], " + CRLF
	    cQuery1 += " C.[D2_IPI], " + CRLF
	    cQuery1 += " CASE " + CRLF
	    cQuery1 += " WHEN A.[ZZW_ST] = '2' THEN '0' " + CRLF
	    cQuery1 += " ELSE C.[D2_BRICMS] " + CRLF
	    cQuery1 += " END AS [D2_BRICMS], " + CRLF
	    cQuery1 += " C.[D2_ICMSRET], " + CRLF
	    cQuery1 += " C.[D2_MARGEM], " + CRLF
        cQuery1 += " C.[D2_PRCVEN] * B.[ZZY_QTD] + C.[D2_VALIPI] AS [TOTAL_DA_NOTA] " + CRLF
        cQuery1 += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF  
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
        cQuery1 += " ON A.[ZZW_NUM] = B.[ZZY_NUM]
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
        cQuery1 += " ON B.[ZZY_NF] = C.[D2_DOC] AND B.[ZZY_SERIE] = C.[D2_SERIE] AND B.[ZZY_PROD] = C.[D2_COD] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SB1") + " D " + CRLF 
        cQuery1 += " ON B.[ZZY_PROD] = D.[B1_COD] " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("ZA2") + " E " + CRLF
        cQuery1 += " ON C.[D2_TES] = E.[ZA2_TESSAI] " + CRLF
        cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '60000010'"

        cAlias1 := MPSYSOPENQUERY(cQuery1)

        WHILE (cAlias1)->(!Eof())
            IF (cAlias)->ZZY_NF == (cAlias1)->ZZY_NF
                FOR nI := 1 TO LEN(cAlias1)
                    oPrinter:BOX(nVert1,5,nHori,590,"-5")
                    oPrinter:SAY(nVert,10,(cAlias1)->ZZY_PROD,aFont)
                    oPrinter:SAY(nVert,40,(cAlias1)->B1_DESC,aFont)
                    oPrinter:SAY(nVert,190,(cAlias1)->B1_POSIPI,aFont)
                    oPrinter:SAY(nVert,235,(cAlias1)->ZA2_CFOPIM,aFont)
                    oPrinter:SAY(nVert,260,(cAlias1)->D2_UM,aFont)
                    oPrinter:SAY(nVert,264,STR((cAlias1)->ZZY_QTD,6),aFont)
                    oPrinter:SAY(nVert,280,STR((cAlias1)->D2_PRCVEN,10,2),aFont)
                    oPrinter:SAY(nVert,320,STR((cAlias1)->D2_TOTAL,10,2),aFont)
                    oPrinter:SAY(nVert,370,STR((cAlias1)->D2_BASEICM),aFont)
                    oPrinter:SAY(nVert,460,STR((cAlias1)->D2_VALICM,10,2),aFont)
                    oPrinter:BOX(nVert2,5,nHori1,590,"-5")
                    oPrinter:SAY(nVert3,10,"BASE CALCULO ICMS")
                    oPrinter:SAY(nVert4,40,"TESTE",aFont)
                    oPrinter:SAY(nVert3,110,"TOTAL ICMS")
                    oPrinter:SAY(nVert4,110,"TESTE",aFont)
                    oPrinter:SAY(nVert3,180,"BASE C�LCULO ICMS ST")
                    oPrinter:SAY(nVert4,180,"TESTE",aFont)
                    oPrinter:SAY(nVert3,290,"TOTAL ICMS ST")
                    oPrinter:SAY(nVert4,290,"TESTE",aFont)
                    oPrinter:SAY(nVert3,370,"TOTAL DOS PRODUTOS")
                    oPrinter:SAY(nVert4,370,"TESTE",aFont)
                    oPrinter:SAY(nVert3,470,"TOTAL IPI")
                    oPrinter:SAY(nVert4,470,"TESTE",aFont)
                    oPrinter:SAY(nVert3,530,"TOTAL DA NOTA")
                    oPrinter:SAY(nVert4,530,"TESTE",aFont)
                    oPrinter:SAY(nVert5,10,"5 - Informa��es Adicionais")
                    nVert  += 10
                    nVert1 += 10
                    nVert2 += 10
                    nVert3 += 10
                    nHori  += 10
                    nHori1 += 10
                NEXT
            ENDIF
        (cAlias1)->(DBSKIP())    
        ENDDO

        nVert  := 328
        nVert1 := 330
        nVert2 := 340
        nVert3 := 338
        nHori  := 320
        nHori1 := 355
        
        (cAlias1)->(DBCLOSEAREA())      

        oPrinter:ENDPAGE()
       (cAlias)->(DBSKIP()) 
    ENDDO

    (cAlias)->(DBCLOSEAREA()) 

    oPrinter:SETUP()
    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    ENDIF 

RETURN 
