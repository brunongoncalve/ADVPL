#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

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
    LOCAL oSection2  := NIL
    LOCAL oSection3  := NIL
    LOCAL oBreak     := NIL
    LOCAL nColSpace  := 1
    LOCAL nSize      := 255
    LOCAL lLineBreak := .T.
    LOCAL lAutoSize  := .T.
    LOCAL cAliasCL   := ""
    LOCAL cAliasPD   := ""
    LOCAL cAliasOB   := ""
    LOCAL cNomeArq   := "RELAT01"
    LOCAL cTitulo    := "PEDIDOS POR CLIENTES"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasCL, @cAliasPD, @cAliasOB, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1, "A1_COD",      cAliasCL,  "COD.CLIENTE"             ,,nSize,,   {|| (cAliasCL)->A1_COD},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_NREDUZ",   cAliasCL,  "CLIENTE"                 ,,nSize,,   {|| (cAliasCL)->A1_NREDUZ},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_END",      cAliasCL,  "ENDEREÇO"                ,,nSize,,   {|| (cAliasCL)->A1_END},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_VEND1",    cAliasCL,  "REPRESENTANTE"           ,,nSize,,   {|| (cAliasCL)->C5_VEND1},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_NUM",      cAliasCL,  "NUMERO DO PEDIDO"        ,,nSize,,   {|| (cAliasCL)->C5_NUM},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_EMISSAO",  cAliasCL,  "DATA DE EMISSAO"         ,,nSize,,   {|| (cAliasCL)->C5_EMISSAO},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_TIPO",     cAliasCL,  "TIPO DE PEDIDO"          ,,nSize,,   {|| (cAliasCL)->C5_TIPO},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_CONDPAG",  cAliasCL,  "CONDIÇÃO DE PAGAMENTO"   ,,nSize,,   {|| (cAliasCL)->C5_CONDPAG},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_TEL",      cAliasCL,  "TELEFONE"                ,,nSize,,   {|| (cAliasCL)->A1_TEL},,lLineBreak,,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2, "C6_PRODUTO",   cAliasPD, "ITEM"          ,,,,   {|| (cAliasPD)->C6_PRODUTO},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_DESCRI",    cAliasPD, "DESCRIÇÃO"     ,,,,   {|| (cAliasPD)->C6_DESCRI},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_PRCVEN",    cAliasPD, "PR. UNITARIO"  ,,,,   {|| (cAliasPD)->C6_PRCVEN},,lLineBreak,,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_VALOR",     cAliasPD, "VALOR"         ,,,,   {|| (cAliasPD)->C6_VALOR},,lLineBreak,,,nColSpace,lAutoSize)

    oSection3 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection3, "C5_XCOMEN",   cAliasOB, "OBSERVAÇÃO"     ,,,,   {|| (cAliasOB)->C5_XCOMEN},,lLineBreak,,,nColSpace,lAutoSize)

    oBreak := TRBREAK():NEW(oSection1,oSection1:CELL("A1_COD"),"TOTAL",.F.)

    TRFUNCTION():NEW(oSection2:CELL("C6_PRCVEN") ,,  "SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.T.)
    TRFUNCTION():NEW(oSection2:CELL("C6_VALOR")  ,,  "SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.T.)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasCL, cAliasPD, cAliasOB, aResps)

    LOCAL oSection1    := oReport:SECTION(1)
    LOCAL oSection2    := oReport:SECTION(2)
    LOCAL oSection3    := oReport:SECTION(3)
    LOCAL aPedidoDE    := aResps[1]
    LOCAL aPedidoATE   := aResps[2]
    LOCAL cQuery       := ""
    LOCAL cQuery1      := ""
    LOCAL cQuery2      := ""
    
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
    cQuery += " ON A.[C5_NUM] = B.[A1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] BETWEEN '"+ aPedidoDE +"' AND '"+ aPedidoATE +"'"

    cAliasCL := MPSYSOPENQUERY(cQuery)

    oSection1:INIT()
        WHILE (cAliasCL)->(!EOF())
            oSection1:PRINTLINE()
            (cAliasCL)->(DBSKIP())
        ENDDO
    (cAliasCL)->(DBCLOSEAREA())
    oSection1:FINISH()

    cQuery1 := "SELECT A.[C5_NUM], " + CRLF
    cQuery1 += "B.[C6_NUM], " + CRLF
    cQuery1 += "B.[C6_PRODUTO], " + CRLF
    cQuery1 += "B.[C6_DESCRI], " + CRLF
    cQuery1 += "B.[C6_PRCVEN], " + CRLF
    cQuery1 += "B.[C6_VALOR] " + CRLF
	cQuery1 += "FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery1 += " LEFT JOIN " + RETSQLNAME("SC6") + " B " + CRLF 
    cQuery1 += " ON A.[C5_NUM] = B.[C6_NUM] " + CRLF
    cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] BETWEEN '"+ aPedidoDE +"' AND '"+ aPedidoATE +"'"
	                                                                
    cAliasPD := MPSYSOPENQUERY(cQuery1)

    oSection2:INIT()
        WHILE (cAliasPD)->(!EOF())
            oSection2:PRINTLINE()
            (cAliasPD)->(DBSKIP())
        ENDDO
    (cAliasPD)->(DBCLOSEAREA())
    oSection2:FINISH()

    cQuery2 := "SELECT A.[C5_NUM], " + CRLF
    cQuery2 += "B.[C6_NUM], " + CRLF
    cQuery2 += "B.[C6_PRODUTO], " + CRLF
    cQuery2 += "B.[C6_DESCRI], " + CRLF
    cQuery2 += "B.[C6_PRCVEN], " + CRLF
    cQuery2 += "B.[C6_VALOR], " + CRLF
    cQuery2 += "A.[C5_XCOMEN] " + CRLF
	cQuery2 += "FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery2 += " LEFT JOIN " + RETSQLNAME("SC6") + " B " + CRLF 
    cQuery2 += " ON A.[C5_NUM] = B.[C6_NUM] " + CRLF
    cQuery2 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] BETWEEN '"+ aPedidoDE +"' AND '"+ aPedidoATE +"'"
	                                                                
    cAliasOB := MPSYSOPENQUERY(cQuery2)

    oSection3:INIT()
        WHILE (cAliasOB)->(!EOF())
            oSection3:PRINTLINE()
            (cAliasOB)->(DBSKIP())
        ENDDO
    (cAliasOB)->(DBCLOSEAREA())
    oSection3:FINISH()
    
RETURN  
