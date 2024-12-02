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
    LOCAL nHori           := 320
    LOCAL oPrinter

    oPrinter := FWMSPRINTER():NEW("exemplo.rel",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,)
    oFont    := TFont():New("Courier New",,9,.T.)

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
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '60000015'"

    cQuery := CHANGEQUERY(cQuery)
    cAlias := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)

    WHILE (cAlias)->(!EOF())
        oPrinter:STARTPAGE()
        oPrinter:BOX(20,5,70,100,"-5")
        oPrinter:SAYBITMAP(27,10,"tmp\logo_novo.png",90,28)
        oPrinter:BOX(20,100,70,500,"-5")
        oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLU��O",oFont)
        oPrinter:BOX(20,500,70,590,"-5")
        oPrinter:SAY(35,505,"N DA DEVOLU��O",oFont)
        oPrinter:SAY(50,505,"8",oFont)
        oPrinter:SAY(65,505,"28/03/2024",oFont)
        oPrinter:SAY(90,10,"1 - Remetente",oFont)
        oPrinter:BOX(150,5,100,590,"-5")
        oPrinter:SAY(170,10,"2 - Natureza de Opera��o",oFont)
        oPrinter:BOX(180,5,200,590,"-5")
        oPrinter:SAY(193,10,"Devolu��o",oFont)
        oPrinter:SAY(220,10,"3 - Destinat�rio",oFont)
        oPrinter:BOX(230,5,280,590,"-5")
        oPrinter:SAY(300,10,"4 - Dados do Produto",oFont)
        oPrinter:BOX(310,5,320,590,"-5")
        oPrinter:SAY(318,10,"ITEM",oFont)
        oPrinter:SAY(318,40,"DESCRI��O DO PRODUTO",oFont)
        oPrinter:SAY(318,190,"CL FISCAL",oFont)
        oPrinter:SAY(318,235,"CFOP",oFont)
        oPrinter:SAY(318,260,"UM",oFont)
        oPrinter:SAY(318,275,"QTDE",oFont)
        oPrinter:SAY(318,300,"VL UNIT",oFont)
        oPrinter:SAY(318,335,"VL TOTAL",oFont)
        oPrinter:SAY(318,420,"BASE ICMS",oFont)
        oPrinter:SAY(318,470,"VL ICMS",oFont)
        
        cQuery1 := " SELECT B.[ZZY_PROD], " + CRLF
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
        cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '60000015'"

        cQuery1 := CHANGEQUERY(cQuery1)
        cAlias1 := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery1),cAlias1,.F.,.T.)

        WHILE (cAlias1)->(!Eof())
            IF (cAlias)->ZZY_NF == (cAlias1)->ZZY_NF
                oPrinter:BOX(nVert1,5,nHori,590,"-5")
                oPrinter:SAY(nVert,10,(cAlias1)->ZZY_PROD,oFont)
                oPrinter:SAY(nVert,40,(cAlias1)->B1_DESC,oFont)
                oPrinter:SAY(nVert,190,(cAlias1)->B1_POSIPI,oFont)
                oPrinter:SAY(nVert,235,(cAlias1)->ZA2_CFOPIM,oFont)
                oPrinter:SAY(nVert,260,(cAlias1)->D2_UM,oFont)
                oPrinter:SAY(nVert,264,STR((cAlias1)->ZZY_QTD,6),oFont)
                oPrinter:SAY(nVert,280,STR((cAlias1)->D2_PRCVEN,10,2),oFont)
                oPrinter:SAY(nVert,320,STR((cAlias1)->D2_TOTAL,10,2),oFont)
                oPrinter:SAY(nVert,370,STR((cAlias1)->D2_BASEICM),oFont)
                oPrinter:SAY(nVert,460,STR((cAlias1)->D2_VALICM,10,2),oFont)
                nVert  += 10
                nVert1 += 10
                nHori  += 10
            ENDIF
        (cAlias1)->(DBSKIP())    
        ENDDO

        nVert2 := nVert1 += 15
        nVert3 := nVert  += 1
        nVert4 := nVert  += 10
        nVert5 := nVert1 += 20
        oPrinter:BOX(nVert2,5,nHori,590,"-5")
        oPrinter:SAY(nVert3,10,"BASE CALCULO ICMS")
        oPrinter:SAY(nVert4,10,"TESTE",oFont)
        oPrinter:SAY(nVert3,110,"TOTAL ICMS")
        oPrinter:SAY(nVert4,110,"TESTE",oFont)
        oPrinter:SAY(nVert3,180,"BASE C�LCULO ICMS ST")
        oPrinter:SAY(nVert4,180,"TESTE",oFont)
        oPrinter:SAY(nVert3,290,"TOTAL ICMS ST")
        oPrinter:SAY(nVert4,290,"TESTE",oFont)
        oPrinter:SAY(nVert3,370,"TOTAL DOS PRODUTOS")
        oPrinter:SAY(nVert4,370,"TESTE",oFont)
        oPrinter:SAY(nVert3,470,"TOTAL IPI")
        oPrinter:SAY(nVert4,470,"TESTE",oFont)
        oPrinter:SAY(nVert3,530,"TOTAL DA NOTA")
        oPrinter:SAY(nVert4,530,"TESTE",oFont)
        oPrinter:SAY(nVert5,10,"5 - Informa��es Adicionais",oFont)

        (cAlias1)->(DBCLOSEAREA())      

        oPrinter:ENDPAGE()

        nVert  := 328
        nVert1 := 330
        nHori  := 320
        nVert2 := NIL
        nVert3 := NIL
        nVert4 := NIL
        nVert5 := NIL

       (cAlias)->(DBSKIP()) 
    ENDDO

    (cAlias)->(DBCLOSEAREA()) 

    oPrinter:SETUP()
    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    ENDIF 
RETURN 

//oPrinter:SAY(nVert5,10,"5 - Informa��es Adicionais",oFont)
