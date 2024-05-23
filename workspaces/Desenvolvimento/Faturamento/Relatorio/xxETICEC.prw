#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PEDIDOS POR CLIENTES
RELATORIO - PEDIDOS POR CLIENTES
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xETICEC()

    LOCAL oPrinter := NIL
    LOCAL aPergs   := {}
    LOCAL aResps   := {}

    AADD(aPergs, {1, "NUMERO DA NOTA FISCAL", SPACE(TAMSX3("C5_NUM")[1]) ,,,"SC5",, 100, .F.})

        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
           oPrinter := IMPETIQ(aResps)
        ENDIF

RETURN

STATIC FUNCTION IMPETIQ(aResps)

	LOCAL cQuery	      := ""
	LOCAL aPedidoDE	      := aResps[1]
	LOCAL lAdjustToLegacy := .F.
	LOCAL lDisableSetup   := .F.
	LOCAL nRowEAN         := 50
	LOCAL nColEAN         := 90
	LOCAL nWidthEAN       := 15
	LOCAL nHeightEAN      := 10   
	LOCAL nCodEAN         := "23793047089000000042384022562100266430000100000"

    LOCAL oPrinter        := FWMSPRINTER():NEW("etiqueta",,lAdjustToLegacy,,lDisableSetup,,,)
	oPrinter:SETMARGIN(001,001,001,001)

	cQuery := " SELECT * FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += "  WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] = '"+ aPedidoDE +"'"
 
	TcQuery cQuery New Alias "CQUERY"
	CQUERY->(DBGOTOP())

	WHILE CQUERY->(!EOF())
		oPrinter:STARTPAGE()
		oPrinter:BOX(02,02,98,148)
		oPrinter:SAY(10,10, "NF: " + ALLTRIM(CQUERY->C5_NUM))
		oPrinter:SAY(20,10, "FORNECEDOR: " + ALLTRIM(CQUERY->C5_CLIENTE))
		oPrinter:SAY(30,10, "PRODUTO: " + ALLTRIM(CQUERY->C5_CLIENTE))
		oPrinter:SAY(50,10, "QTDE: " + ALLTRIM(CQUERY->C5_CLIENTE))
		oPrinter:SAY(40,90, "VOLUME: " + ALLTRIM(CQUERY->C5_CLIENTE))
		oPrinter:EAN13(nRowEAN,nColEAN,nCodEAN,nWidthEAN,nHeightEAN)
		oPrinter:ENDPAGE()
		CQUERY->(DBSKIP())
	ENDDO
    
	oPrinter:PRINT()
	CQUERY->(DBCLOSEAREA())
 
RETURN
