#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
#INCLUDE "TBICONN.CH"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PEDIDOS POR CLIENTES
RELATORIO - PEDIDOS POR CLIENTES
@author    BRUNO NASCIMENTO GONï¿½ALVES
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
	LOCAL nPedido   := aResps[1]
	LOCAL cPorta    := "LPT1"
    LOCAL cModelo   := "ZEBRA"
	LOCAL cEtiqueta := ""
    LOCAL nI        := ""
    LOCAL nV        := 0

	cQuery := " SELECT B.[C9_NFISCAL], A.[DCV_CODVOL], C.[B1_DESC], C.[B1_CODBAR], A.[DCV_QUANT] " + CRLF
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

    cQuery    := CHANGEQUERY(cQuery)
    cAliasQry := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasQry,.F.,.T.)
    nTotal := DBRECCOUNT()

    ALERT(LEN(cAliasQry))
    
    WHILE (cAliasQry)->(!Eof())
        IF(nI <> ALLTRIM((cAliasQry)->DCV_CODVOL))
            nV += 1
            nI := ALLTRIM((cAliasQry)->DCV_CODVOL)
        ENDIF
        
        MSCBPRINTER(cModelo,cPorta,,10,.F.,,,,,,.F.,)
        MSCBCHKSTATUS(.F.)
        MSCBBEGIN(1,6)
        cEtiqueta := "^XA " + CRLF
        cEtiqueta += "^FX NUMERO DA NOTA " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO50,40^FDNF: "+ ALLTRIM((cAliasQry)->C9_NFISCAL) +"^FS " + CRLF
        cEtiqueta += "^FX FORNECEDOR E PRODUTOS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,130^FD FORNECEDOR: ALUMBRA^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,180^FD PRODUTOS: "+ (cAliasQry)->B1_DESC +"^FS " + CRLF
        cEtiqueta += "^FX QUANTIDADE DE PEÇAS " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO30,300^FD QTDE: "+ ALLTRIM((cAliasQry)->DCV_QUANT) +"^FS " + CRLF
        cEtiqueta += "^FX VOLUME " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO450,240^FD VOLUME:^FS " + CRLF
        cEtiqueta += "^FO500,300^FD 1 / 1^FS " + CRLF
        cEtiqueta += "^FX CODIGO DE BARRA. " + CRLF
        cEtiqueta += "^BY3,1,80 " + CRLF
        cEtiqueta += "^FO400,360^BC^FD"+ ALLTRIM((cAliasQry)->B1_CODBAR) +"^FS " + CRLF
        cEtiqueta += "^XZ "
        MSCBWRITE(cEtiqueta)
        MSCBEND()

        (cAliasQry)->(DBSKIP())
    ENDDO

    (cAliasQry)->(DBCLOSEAREA())

RETURN
    

