#INCLUDE "PROTHEUS.ch"

USER FUNCTION MODELO1()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs, {1, "PEDIDO", SPACE(TAMSX3("C5_NUM")[1]) ,,,,, 100, .F.})
    
        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            oReport := REPORTDEF(aResps)
            oReport:PRINTDIALOG()
        ENDIF     

RETURN NIL

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport := NIL
    LOCAL oSection := NIL
    LOCAL cAliasTop := ""
    LOCAL cNomeArq := "RELAT01"
    LOCAL cTitulo := "PEDIDOS"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasTop, aResps)}, "IMPRESSÃO DE RELATORIO")
    oReport:SETLANDSCAPE()

    oSection := TRSECTION():NEW(oReport, cTitulo, {"SC5","SC6"})

    TRCELL():NEW(oSection, "C5_NUM",       cAliasTop, "Cliente"      ,,,,   {|| (cAliasTop)->C5_NUM})
    TRCELL():NEW(oSection, "C6_DESCRI",    cAliasTop, "DESCRIÇÃO"      ,,,, {|| (cAliasTop)->C6_DESCRI})

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasTop, aResps)

    LOCAL oSection  := oReport:SECTION(1)
    LOCAL aPedido    := aResps[1]
    LOCAL cQuery    := ""
    
    cQuery := "SELECT A.[C5_NUM], " + CRLF
    cQuery += "B.[C6_NUM], " + CRLF
    cQuery += "B.[C6_DESCRI] " + CRLF
	cQuery += "FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SC6") + " B " + CRLF 
    cQuery += " ON A.[C5_NUM] = B.[C6_NUM] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] = '"+ aPedido +"'"
	                                                                
    cAliasTop := MPSYSOPENQUERY(cQuery)

    oSection:INIT()
        WHILE (cAliasTop)->(!EOF())
            oSection:PRINTLINE()
            (cAliasTop)->(DBSKIP())
        ENDDO
    (cAliasTop)->(DBCLOSEAREA())
    oSection:FINISH()        

RETURN  


