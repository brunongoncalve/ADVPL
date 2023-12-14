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

    AADD(aPergs, {1, "PEDIDO DE", SPACE(TAMSX3("C5_NUM")[1]) ,,,"SC5",, 100, .F.})
    AADD(aPergs, {1, "PEDIDO ATE", SPACE(TAMSX3("C5_NUM")[1]) ,,,"SC5",, 100, .F.})
    
        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
           oPrinter := IMPETIQ(aResps)
        ENDIF

RETURN

STATIC FUNCTION IMPETIQ(aResps)

	LOCAL cQuery	      := ""
	LOCAL aPedidoDE	      := aResps[1]
	LOCAL aPedidoATE      := aResps[2]
	LOCAL lAdjustToLegacy := .F.
	LOCAL lDisableSetup   := .F.
    LOCAL oPrinter        := FWMSPRINTER():NEW("produto",,lAdjustToLegacy,,lDisableSetup,,,)

	cQuery := " SELECT * FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += "  WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] BETWEEN '"+ aPedidoDE +"' AND '"+ aPedidoATE +"'" + CRLF
 
	TcQuery cQuery New Alias "CQUERY"
	CQUERY->(DBGOTOP())
 
	WHILE CQUERY->(!EOF())
		oPrinter:STARTPAGE()
        oPrinter:FWMSBAR("EAN13",5,1,"23793047089000000042384022562100266430000100000",oPrinter,,,,,,,,,.F.,,,)
        oPrinter:SETMARGIN(001,001,001,001)
		oPrinter:ENDPAGE()
		CQUERY->(DBSKIP())
	ENDDO
    
    oPrinter:PREVIEW()
	CQUERY->(DBCLOSEAREA())
 
RETURN


