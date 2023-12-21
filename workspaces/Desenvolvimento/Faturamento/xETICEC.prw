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

    AADD(aPergs, {1, "NUMERO DA NOTA FISCAL", SPACE(TAMSX3("C5_NUM")[1]) ,,,"SC5",, 100, .F.})

        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            IMPETIQ(aResps)
        ENDIF

RETURN

STATIC FUNCTION IMPETIQ(aResps)

	LOCAL cQuery	:= ""
    LOCAL cQuery1	:= ""
	LOCAL aPedidoDE := aResps[1]
	LOCAL cPorta    := "LPT1"
    LOCAL cModelo   := "ZEBRA"
	LOCAL cEtiqueta := ""

	cQuery := " SELECT * FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] = '"+ aPedidoDE +"'"
 
    cQuery := CHANGEQUERY(cQuery)
	cAlias := MPSYSOPENQUERY(cQuery)
	(cAlias)->(DBGOTOP())

    WHILE (cAlias)->(!EOF())
	    MSCBPRINTER(cModelo,cPorta,,10,.F.,,,,,,.F.,)
        MSCBCHKSTATUS(.F.)
        MSCBBEGIN(1,6)
	    cEtiqueta += "^XA " + CRLF
        cEtiqueta += "^FX NUMERO DA NOTA " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO50,40^FDNF: 1111111111^FS " + CRLF
        cEtiqueta += "^FX FORNECEDOR E PRODUTOS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,130^FD FORNECEDOR: TESTE^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,180^FD PRODUTOS: TESTE^FS " + CRLF
        cEtiqueta += "^FX QUANTIDADE DE PE�AS " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO30,300^FD QTDE: 100^FS " + CRLF
        cEtiqueta += "^FX VOLUME " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO450,240^FD VOLUME:^FS " + CRLF
        cEtiqueta += "^FO500,300^FD 1 / 35^FS " + CRLF
        cEtiqueta += "^FX CODIGO DE BARRA. " + CRLF
        cEtiqueta += "^BY3,1,80 " + CRLF
        cEtiqueta += "^FO400,360^BC^FD12345678^FS " + CRLF
        cEtiqueta += "^XZ "
	    MSCBWRITE(cEtiqueta)
        MSCBEND()
        MSCBCLOSEPRINTER()
        (cAlias)->(DBSKIP())

    ENDDO

    (cAlias)->(DBCLOSEAREA())

    cQuery1 := " SELECT * FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] = '"+ aPedidoDE +"'"
 
	cQuery1 := CHANGEQUERY(cQuery1)
    cAlias1 := MPSYSOPENQUERY(cQuery1)
    (cAlias1)->(DBGOTOP())

    WHILE (cAlias1)->(!EOF())
        MSCBPRINTER(cModelo,cPorta,,10,.F.,,,,,,.F.,)
        MSCBCHKSTATUS(.F.)
        MSCBBEGIN(1,6)
	    cEtiqueta += "^XA " + CRLF
        cEtiqueta += "^FX NUMERO DA NOTA " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO50,40^FDNF: 222222222^FS " + CRLF
        cEtiqueta += "^FX FORNECEDOR E PRODUTOS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,130^FD FORNECEDOR: TESTE^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,180^FD PRODUTOS: TESTE^FS " + CRLF
        cEtiqueta += "^FX QUANTIDADE DE PE�AS " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO30,300^FD QTDE: 100^FS " + CRLF
        cEtiqueta += "^FX VOLUME " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO450,240^FD VOLUME:^FS " + CRLF
        cEtiqueta += "^FO500,300^FD 1 / 35^FS " + CRLF
        cEtiqueta += "^FX CODIGO DE BARRA. " + CRLF
        cEtiqueta += "^BY3,1,80 " + CRLF
        cEtiqueta += "^FO400,360^BC^FD12345678^FS " + CRLF
        cEtiqueta += "^XZ "
	    MSCBWRITE(cEtiqueta)
        MSCBEND()
        MSCBCLOSEPRINTER()
        (cAlias1)->(DBSKIP())
                 
    ENDDO

    (cAlias1)->(DBCLOSEAREA())
	
RETURN


