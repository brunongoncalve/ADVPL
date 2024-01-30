#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
#INCLUDE "TBICONN.CH"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PEDIDOS POR CLIENTES
RELATORIO - PEDIDOS POR CLIENTES
@author    BRUNO NASCIMENTO GON�ALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xETICEC()

    LOCAL aPergs := {}
    LOCAL aResps := {}

    AADD(aPergs, {1, "NUMERO DA NOTA FISCAL", SPACE(TAMSX3("C5_NUM")[1]),,,"SC5",, 100, .F.})

        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            IMPETIQ(aResps)
        ENDIF

RETURN

STATIC FUNCTION IMPETIQ(aResps)

	LOCAL cQuery	:= ""
    LOCAL cQuery1	:= ""
    LOCAL cQuery2	:= ""
	LOCAL nPedido   := aResps[1]
	LOCAL cPorta    := "LPT1"
    LOCAL cModelo   := "ZEBRA"
	LOCAL cEtiqueta := ""
    LOCAL nI        := 0
    LOCAL aResult   := {}

	cQuery := " SELECT B.[C9_NFISCAL], A.[DCV_CODVOL], C.[B1_DESC], A.[DCV_QUANT] " + CRLF
    cQuery += " FROM " + RETSQLNAME("DCV") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SC9") + " B " + CRLF
    cQuery += " ON A.[DCV_FILIAL] = B.[C9_FILIAL] " + CRLF
    cQuery += " AND A.[DCV_PEDIDO] = B.[C9_PEDIDO] " + CRLF
    cQuery += " AND A.[DCV_ITEM] = B.[C9_ITEM] " + CRLF
    cQuery += " AND A.[DCV_SEQUEN] = B.[C9_SEQUEN] " + CRLF
    cQuery += " AND  B.[D_E_L_E_T_] = ' ' " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SB1") + " C " + CRLF
    cQuery += " ON A.[DCV_CODPRO] = C.[B1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND B.[C9_PEDIDO] = '"+ nPedido +"'" + CRLF
    cQuery += " ORDER BY A.[DCV_CODVOL] "
	cAlias := MPSYSOPENQUERY(cQuery)
    
    cQuery1 := " SELECT [DCV_CODVOL] " + CRLF
    cQuery1 += " FROM " + RETSQLNAME("DCV") + " " + CRLF
    cQuery1 += " WHERE [D_E_L_E_T_] = ' ' AND [DCV_PEDIDO] = '"+ nPedido +"'" + CRLF
    cQuery1 += " GROUP BY [DCV_CODVOL] "
    cAlias1 := MPSYSOPENQUERY(cQuery1)

    aResult := {|cAlias1->DCV_CODVOL|}
    ALERT(aResult)
   
RETURN
    

