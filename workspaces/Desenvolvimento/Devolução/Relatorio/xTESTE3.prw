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
    LOCAL nVert           := 329
    LOCAL nLinfim         := 850
    LOCAL nI              := 0
    LOCAL oPrinter

    oPrinter := FWMSPRINTER():NEW("exemplo.rel",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,)
    oFont1   := TFont():New("Courier New",,9,.T.)
    
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
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '"+ aPro +"'" + CRLF

    cAlias := MPSYSOPENQUERY(cQuery)

    nNF := (cAlias)->ZZY_NF

    WHILE (cAlias)->(!EOF())
        IF (cAlias)->ZZY_NF <> nNF
            oPrinter:STARTPAGE()
            oPrinter:BOX(20,5,70,100,"-5")
            oPrinter:SAYBITMAP(27,10,"C:\Logo\logo_novo.png",90,28)
            oPrinter:ENDPAGE()
        ENDIF
    ENDDO

    oPrinter:SETUP()
    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    ENDIF 

RETURN 
