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
	LOCAL nPedido   := aResps[1]
	LOCAL cPorta    := "LPT1"
    LOCAL cModelo   := "ZEBRA"
	LOCAL cEtiqueta := ""
    LOCAL nTotal    := ""
    LOCAL nI        := 0

	cQuery := " SELECT B.[C9_NFISCAL], A.[DCV_CODVOL], C.[B1_DESC], A.[DCV_QUANT] "
    cQuery += " FROM " + RETSQLNAME("DCV") + " A " + CRLF
    cQuery := " LEFT JOIN " + RETSQLNAME("SC9") + " B " + CRLF
    cQuery += " ON A.[DCV_FILIAL] = B.[C9_FILIAL] " + CRLF
    cQuery += " AND A.[DCV_PEDIDO] = B.[C9_PEDIDO] " + CRLF
    cQuery += " AND A.[DCV_ITEM] = B.[C9_ITEM] " + CRLF
    cQuery += " AND A.[DCV_SEQUEN] = B.[C9_SEQUEN] " + CRLF
    cQuery += " AND  B.[D_E_L_E_T_] = ' ' " + CRLF
    cQuery := " LEFT JOIN " + RETSQLNAME("SB1") + " C " + CRLF
    cQuery += " ON A.[DCV_CODPRO] = C.[B1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C9_PEDIDO] = '"+ nPedido +"'"
    cQuery += " ORDER BY A.[DCV_CODVOL] "

	cAlias       := MPSYSOPENQUERY(cQuery)

	(cAlias)->(DBGOTOP())

    FOR nI := 1 TO LEN(cAlias) -- SELECT COM A QUANTIDADE DE VOLUMES.
        -- MONTAR SELECT ONDE IRA ATRIBUIR OS ITENS DOS VOLUMES.
        -- MONTAR O WHILE COM OS ITENS DOS VOLUMES.
        -- FAZER A IMPRESSÃO DA cEtiqueta -- REALIZAR TODAS AS CONDIÇÕES POSIVEIS DA cEtiqueta.
        O FOR IRÁ PARA O PROXIMO VOLUME , E ENTÃO IMPRIMIR OS ITENS DAQUELE VOLUME NA CONDIÇÃO WHILE NOVAMENTE E ASSIM POR DIANTE.
    NEXT nI




    WHILE (cAlias)->(!EOF())
        MSCBPRINTER(cModelo,cPorta,,10,.F.,,,,,,.F.,)
        MSCBCHKSTATUS(.F.)
        MSCBBEGIN(1,6)
        cEtiqueta := "^XA " + CRLF
        cEtiqueta += "^FX NUMERO DA NOTA " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO50,40^FDNF: "+ (cAlias)->C9_NFISCAL +"^FS " + CRLF
        cEtiqueta += "^FX FORNECEDOR E PRODUTOS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,130^FD FORNECEDOR: ALUMBRA^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO30,180^FD PRODUTOS: "+ (cAlias)->B1_DESC +"^FS " + CRLF
        cEtiqueta += "^FX QUANTIDADE DE PE�AS " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO30,300^FD QTDE: "+ (cAlias)->DCV_QUANT +"^FS " + CRLF
        cEtiqueta += "^FX VOLUME " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO450,240^FD VOLUME:^FS " + CRLF
        cEtiqueta += "^FO500,300^FD 1 / "+ nTotal +"^FS " + CRL
        cEtiqueta += "^FX CODIGO DE BARRA. " + CRLF
        cEtiqueta += "^BY3,1,80 " + CRLF
        cEtiqueta += "^FO400,360^BC^FD"+ (cAlias)->B1_COD +"^FS " + CRLF
        cEtiqueta += "^XZ "
        MSCBWRITE(cEtiqueta)
        MSCBEND()
        MSCBCLOSEPRINTER()
        (cAlias)->(DBSKIP())
    ENDDO

    (cAlias)->(DBCLOSEAREA())

RETURN
    

