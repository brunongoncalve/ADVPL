#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELAT01
RELATORIO - PEDIDOS POR CLIENTES
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION RELAT01()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs, {1, "PEDIDO DE", SPACE(TAMSX3("C5_NUM")[1]) ,,,,, 100, .F.})
    AADD(aPergs, {1, "PEDIDO ATE", SPACE(TAMSX3("C5_NUM")[1]) ,,,,, 100, .F.})
    
        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            oReport := REPORTDEF(aResps)
            oReport:PRINTDIALOG()
        ENDIF

RETURN NIL

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport    := NIL
    LOCAL oSection1  := NIL
    LOCAL oBreak     := NIL
    LOCAL nColSpace  := 1
    LOCAL nSize      := 255
    LOCAL lLineBreak := .T.
    LOCAL lAutoSize  := .T.
    LOCAL lEndPage   := .F.
    LOCAL cAliasCL   := ""
    LOCAL cNomeArq   := "RELAT01"
    LOCAL cTitulo    := "PEDIDOS POR CLIENTES"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasCL, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1, "A1_COD",      cAliasCL,  "COD.CLI"             ,,nSize,,   {|| (cAliasCL)->A1_COD},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_NREDUZ",   cAliasCL,  "NOME CLI"            ,,nSize,,   {|| (cAliasCL)->A1_NREDUZ},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_NUM",      cAliasCL,  "N° DO PEDIDO"        ,,nSize,,   {|| (cAliasCL)->C5_NUM},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_EMISSAO",  cAliasCL,  "DATA DE EMISSAO"     ,,nSize,,   {|| (cAliasCL)->C5_EMISSAO},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_CONDPAG",  cAliasCL,  "COND.PAG"            ,,nSize,,   {|| (cAliasCL)->C5_CONDPAG},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C6_PRODUTO",  cAliasCL,  "ITEM"                ,,nSize,,   {|| (cAliasCL)->C6_PRODUTO},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C6_QTDVEN",   cAliasCL,  "QTDE"                ,,nSize,,   {|| (cAliasCL)->C6_QTDVEN},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C6_DESCRI",   cAliasCL,  "DESCRIÇÃO"           ,,nSize,,   {|| (cAliasCL)->C6_DESCRI},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C6_PRCVEN",   cAliasCL,  "PREÇO UNIT"          ,,nSize,,   {|| (cAliasCL)->C6_PRCVEN},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C6_VALOR",    cAliasCL,  "VALOR"               ,,nSize,,   {|| (cAliasCL)->C6_VALOR},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_XCOMEN",   cAliasCL, "OBSERVAÇÃO"           ,,nSize,,   {|| (cAliasCL)->C5_XCOMEN},,lLineBreak,,,nColSpace,lAutoSize)

    TReport():AddSection(oSection1) 

    oBreak := TRBREAK():NEW(oSection1,oSection1:CELL("C5_NUM"),"TOTAL",.F.)
    TRFUNCTION():NEW(oSection1:CELL("C6_PRCVEN") ,,  "SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.,lEndPage,oSection1)
    TRFUNCTION():NEW(oSection1:CELL("C6_VALOR")  ,,  "SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.,lEndPage,oSection1)

    TReport():AddBreak(oBreak)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasCL, aResps)

    LOCAL oSection1   := oReport:SECTION(1)
    LOCAL aPedidoDE   := aResps[1]
    LOCAL aPedidoATE  := aResps[2]
    LOCAL cQuery      := ""

    cQuery := " SELECT B.[A1_COD], " + CRLF
    cQuery += " B.[A1_NREDUZ], " + CRLF
    cQuery += " A.[C5_NUM], " + CRLF
    cQuery += " A.[C5_EMISSAO], " + CRLF
    cQuery += " A.[C5_CONDPAG], " + CRLF
    cQuery += " A.[C5_XCOMEN], " + CRLF
    cQuery += " C.[C6_QTDVEN], " + CRLF
    cQuery += " C.[C6_PRODUTO], " + CRLF
    cQuery += " C.[C6_DESCRI], " + CRLF
    cQuery += " C.[C6_PRCVEN], " + CRLF
    cQuery += " C.[C6_VALOR] " + CRLF
	cQuery += " FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " B " + CRLF 
    cQuery += " ON A.[C5_CLIENTE] = B.[A1_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SC6") + " C " + CRLF
    cQuery += " ON A.[C5_NUM] = C.[C6_NUM] " + CRLF 
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] BETWEEN '"+ aPedidoDE +"' AND '"+ aPedidoATE +"'"

    cAliasCL := MPSYSOPENQUERY(cQuery)

    oSection1:INIT()
        WHILE (cAliasCL)->(!EOF())
            oSection1:PRINTLINE()
            (cAliasCL)->(DBSKIP())
        ENDDO
    (cAliasCL)->(DBCLOSEAREA())
    oSection1:FINISH()

RETURN  
