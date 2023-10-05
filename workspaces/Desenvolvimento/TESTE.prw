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

USER FUNCTION TESE()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs, {1, "INFORME O PEDIDO", SPACE(TAMSX3("C5_NUM")[1]) ,,,,, 100, .F.})
    AADD(aPergs, {1, "INFORME O PEDIDO", SPACE(TAMSX3("C5_NUM")[1]) ,,,,, 100, .F.})
    
        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            oReport := REPORTDEF(aResps)
            oReport:PRINTDIALOG()
        ENDIF

RETURN NIL

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport    := NIL
    LOCAL oSection1  := NIL
    LOCAL nColSpace  := 1
    LOCAL nSize      := 255
    LOCAL lLineBreak := .T.
    LOCAL lAutoSize  := .T.
    LOCAL cAliasCL   := ""
    LOCAL cNomeArq   := "RELAT01"
    LOCAL cTitulo    := "PEDIDOS POR CLIENTES"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasCL, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
        WHILE (cAliasCL)->(!EOF())
    TRCELL():NEW(oSection1, "A1_COD",      cAliasCL,  "COD.CLI"            ,,nSize,,   {|| (cAliasCL)->A1_COD},,lLineBreak,,,nColSpace,lAutoSize)
 TRCELL():NEW(oSection1, "A1_NREDUZ",   cAliasCL,  "NOME CLI"           ,,nSize,,   {|| (cAliasCL)->A1_NREDUZ},,lLineBreak,,,nColSpace,lAutoSize)
 TRCELL():NEW(oSection1, "A1_END",      cAliasCL,  "ENDEREÇO"           ,,nSize,,   {|| (cAliasCL)->A1_END},,lLineBreak,,,nColSpace,lAutoSize)
TRCELL():NEW(oSection1, "C5_VEND1",    cAliasCL,  "REPRESENTANTE"      ,,nSize,,   {|| (cAliasCL)->C5_VEND1},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_NUM",      cAliasCL,  "N° DO PEDIDO"       ,,nSize,,   {|| (cAliasCL)->C5_NUM},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_EMISSAO",  cAliasCL,  "DATA DE EMISSAO"    ,,nSize,,   {|| (cAliasCL)->C5_EMISSAO},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_TIPO",     cAliasCL,  "TIPO DE PEDIDO"     ,,nSize,,   {|| (cAliasCL)->C5_TIPO},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_CONDPAG",  cAliasCL,  "COND.PAG"           ,,nSize,,   {|| (cAliasCL)->C5_CONDPAG},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_TEL",      cAliasCL,  "TEL"                ,,nSize,,   {|| (cAliasCL)->A1_TEL},,lLineBreak,,,nColSpace,lAutoSize)
            oSection1:PRINTLINE()
            (cAliasCL)->(DBSKIP())
        ENDDO
        (cAliasCL)->(DBCLOSEAREA())
        oSection2:SetPageBreak(.T.)
    oSection1:FINISH()

    //oSection2 := TRSECTION():NEW(oReport)
    //TRCELL():NEW(oSection2, "C6_PRODUTO",  cAliasPD, "ITEM"          ,,nSize,,   {|| (cAliasPD)->C6_PRODUTO},,lLineBreak,,,nColSpace,lAutoSize)
    //TRCELL():NEW(oSection2, "C6_QTDVEN",   cAliasPD, "QTDE"          ,,nSize,,   {|| (cAliasPD)->C6_QTDVEN},,lLineBreak,,,nColSpace,lAutoSize)
    //TRCELL():NEW(oSection2, "C6_DESCRI",   cAliasPD, "DESCRIÇÃO"     ,,nSize,,   {|| (cAliasPD)->C6_DESCRI},,lLineBreak,,,nColSpace,lAutoSize)
    //TRCELL():NEW(oSection2, "C6_PRCVEN",   cAliasPD, "PREÇO UNIT"    ,,nSize,,   {|| (cAliasPD)->C6_PRCVEN},,lLineBreak,,,nColSpace,lAutoSize)
    //TRCELL():NEW(oSection2, "C6_VALOR",    cAliasPD, "VALOR"         ,,nSize,,   {|| (cAliasPD)->C6_VALOR},,lLineBreak,,,nColSpace,lAutoSize)
    //oSection2:SetPageBreak(.T.)

    //oSection3 := TRSECTION():NEW(oReport)
    //TRCELL():NEW(oSection3, "C5_XCOMEN",   cAliasOB, "OBSERVAÇÃO"    ,,,,   {|| (cAliasOB)->C5_XCOMEN},,lLineBreak,,,nColSpace,lAutoSize)

    //TRFUNCTION():NEW(oSection2:CELL("C6_PRCVEN") ,,  "SUM",,,"@E 9,999,999,999.99",,.F.,.T.,lEndPage,oSection2)
    //TRFUNCTION():NEW(oSection2:CELL("C6_VALOR")  ,,  "SUM",,,"@E 9,999,999,999.99",,.F.,.T.,lEndPage,oSection2)

    //oSection3:SetPageBreak(.T.)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasCL, aResps)

    LOCAL aPedidoDE   := aResps[1]
    LOCAL aPedidoATE  := aResps[2]
    LOCAL cQuery      := ""
    
    cQuery := " SELECT B.[A1_COD], " + CRLF
    cQuery += " B.[A1_NREDUZ], " + CRLF
    cQuery += " B.[A1_END], " + CRLF
    cQuery += " A.[C5_VEND1], " + CRLF
    cQuery += " A.[C5_NUM], " + CRLF
    cQuery += " A.[C5_EMISSAO], " + CRLF
    cQuery += " A.[C5_TIPO], " + CRLF
    cQuery += " A.[C5_CONDPAG], " + CRLF
    cQuery += " B.[A1_TEL] " + CRLF
	cQuery += " FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " B " + CRLF 
    cQuery += " ON A.[C5_CLIENTE] = B.[A1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] BETWEEN '"+ aPedidoDE +"' AND '"+ aPedidoATE +"'"

    cAliasCL := MPSYSOPENQUERY(cQuery)

RETURN  
