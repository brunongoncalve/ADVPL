#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - PDF ESPELHO
PDF ESPELHO
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     25/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------
 
USER FUNCTION xTESTE1()

    LOCAL lAdjustToLegacy := .F.
    LOCAL lDisableSetup   := .T.
    LOCAL cLocal          := "\spool"
    LOCAL cQuery          := ""
    LOCAL nVert           := 329
    LOCAL nI              := 0
    LOCAL oPrinter

    cQuery := " SELECT B.[ZZY_PROD], " + CRLF
    cQuery += " A.[ZZW_NUM], " + CRLF
    cQuery += " B.[ZZY_NUM], " + CRLF
    cQuery += " B.[ZZY_NF], " + CRLF
    cQuery += " SUBSTRING(D.[B1_DESC],1,31) AS [B1_DESC], " + CRLF
    cQuery += " D.[B1_POSIPI], " + CRLF
    cQuery += " E.[ZA2_CFOPIM], " + CRLF
    cQuery += " C.[D2_UM], " + CRLF
    cQuery += " B.[ZZY_QTD], " + CRLF
    cQuery += " C.[D2_PRCVEN], " + CRLF
    cQuery += " C.[D2_PRCVEN] * B.[ZZY_QTD] AS [D2_TOTAL], " + CRLF
    cQuery += " C.[D2_BASEICM] * B.[ZZY_QTD] AS [D2_BASEICM], " + CRLF
    cQuery += " C.[D2_BASEICM] * C.[D2_PICM] AS [D2_VALICM], " + CRLF
    cQuery += " C.[D2_PRCVEN] * C.[D2_IPI] AS [D2_VALIPI] , " + CRLF
    cQuery += " C.[D2_PICM], " + CRLF
	cQuery += " C.[D2_IPI], " + CRLF
	cQuery += " CASE " + CRLF
	cQuery += " WHEN A.[ZZW_ST] = '2' THEN '0' " + CRLF
	cQuery += " ELSE C.[D2_BRICMS] " + CRLF
	cQuery += " END AS [D2_BRICMS], " + CRLF
	cQuery += " C.[D2_ICMSRET], " + CRLF
	cQuery += " C.[D2_MARGEM], " + CRLF
    cQuery += " C.[D2_PRCVEN] * B.[ZZY_QTD] + C.[D2_VALIPI] AS [TOTAL_DA_NOTA] " + CRLF
    cQuery += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF  
    cQuery += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
    cQuery += " ON A.[ZZW_NUM] = B.[ZZY_NUM]
    cQuery += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
    cQuery += " ON B.[ZZY_NF] = C.[D2_DOC] AND B.[ZZY_SERIE] = C.[D2_SERIE] AND B.[ZZY_PROD] = C.[D2_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SB1") + " D " + CRLF 
    cQuery += " ON B.[ZZY_PROD] = D.[B1_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("ZA2") + " E " + CRLF
    cQuery += " ON C.[D2_TES] = E.[ZA2_TESSAI] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '60000010'" + CRLF

    cQuery := CHANGEQUERY(cQuery)
    cAlias := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)

    ALERT(LEN(cAlias))
 
    oPrinter := FWMSPRINTER():NEW("exemplo.rel",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,)
    oFont1   := TFont():New("Courier New",,9,.T.)
 
    oPrinter:BOX(20,5,70,100,"-5")
    oPrinter:SAYBITMAP(25,10,"C:\Logo\logo_novo.png",90,28)
    oPrinter:BOX(20,100,70,500,"-5")
    oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLUÇÃO")
    oPrinter:BOX(20,500,70,590,"-5")
    oPrinter:SAY(35,505,"N DA DEVOLUÇÃO")
    oPrinter:SAY(50,505,"8")
    oPrinter:SAY(65,505,"28/03/2024")
    oPrinter:SAY(90,10,"1 - Remetente")
    oPrinter:BOX(150,5,100,590,"-5")
    oPrinter:SAY(170,10,"2 - Natureza de Operação")
    oPrinter:BOX(180,5,200,590,"-5")
    oPrinter:SAY(193,10,"Devolução")
    oPrinter:SAY(220,10,"3 - Destinatário")
    oPrinter:BOX(230,5,280,590,"-5")
    oPrinter:SAY(300,10,"4 - Dados do Produto")
    oPrinter:BOX(310,5,320,590,"-5")
    oPrinter:SAY(318,10,"ITEM",oFont1)
    oPrinter:SAY(318,40,"DESCRIÇÃO DO PRODUTO",oFont1)
    oPrinter:SAY(318,190,"CL FISCAL",oFont1)
    oPrinter:SAY(318,235,"CFOP",oFont1)
    oPrinter:SAY(318,260,"UM",oFont1)
    oPrinter:SAY(318,280,"QTDE",oFont1)
    oPrinter:SAY(318,300,"VL UNIT",oFont1)
    oPrinter:SAY(318,335,"VL TOTAL",oFont1)
    oPrinter:SAY(318,420,"BASE ICMS",oFont1)
    oPrinter:SAY(318,470,"VL ICMS",oFont1)
    WHILE (cAlias)->(!Eof())
        FOR nI := 1 TO LEN(cAlias)
            oPrinter:SAY(nVert,10,(cAlias)->ZZY_PROD,oFont1)
            oPrinter:SAY(nVert,40,(cAlias)->B1_DESC,oFont1)
            oPrinter:SAY(nVert,190,(cAlias)->B1_POSIPI,oFont1)
            oPrinter:SAY(nVert,235,(cAlias)->ZA2_CFOPIM,oFont1)
            oPrinter:SAY(nVert,260,(cAlias)->D2_UM,oFont1)
            oPrinter:SAY(nVert,264,STR((cAlias)->ZZY_QTD,6),oFont1)
            oPrinter:SAY(nVert,275,STR((cAlias)->D2_PRCVEN,10,2),oFont1)
            oPrinter:SAY(nVert,320,STR((cAlias)->D2_TOTAL,10,2),oFont1)
            oPrinter:SAY(nVert,370,STR((cAlias)->D2_BASEICM),oFont1)
            oPrinter:SAY(nVert,460,STR((cAlias)->D2_VALICM,10,2),oFont1)
            nVert += 10
        NEXT
    (cAlias)->(DBSKIP())    
    ENDDO
    (cAlias)->(DBCLOSEAREA()) 
    
    oPrinter:SETUP()
    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    ENDIF

RETURN

    //oPrinter:SAY(319,480,"VL ICMS",oFont1)
    //oPrinter:SAY(319,410,"VL IPI",oFont1)
    //oPrinter:SAY(319,430,"% ICMS",oFont1)
    //oPrinter:SAY(319,450,"% IPI",oFont1)
    //oPrinter:SAY(319,470,"BASE ST",oFont1)
    //oPrinter:SAY(319,490,"VL ST",oFont1)
    //oPrinter:SAY(319,510,"MVA",oFont1)
