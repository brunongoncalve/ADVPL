#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} CLIENTES INATIVOS
RELATORIO - CLIENTES INATIVOS
@author    BRUNO NASCIMENTO GONÇALVES
@since     20/04/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xCLIINA()

    LOCAL oReport := NIL
    LOCAL aPergs := {}
    LOCAL aResps := {}

    AADD(aPergs, {1, "PERIODO DE",STOD(""),,,,, 100, .F.})

    IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
        oReport := REPORTDEF(aResps)
        oReport:PRINTDIALOG()
    ENDIF
        
RETURN

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 25
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasCL     := ""
    LOCAL cNomeArq     := "CLIENTES INATIVOS"
    LOCAL cTitulo      := "CLIENTES INATIVOS"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasCL, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"A1_COD",cAliasCL,"COD.CLI",,nSize,,{|| (cAliasCL)->A1_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"F2_EMISSAO",cAliasCL,"ULTIMA COMPRA",,nSize,,{|| (cAliasCL)->ULTIMA_COMPRA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasCL, aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL cQuery    := ""
    dPeriodoAno     := YEAR2STR(aResps[1])
    dPeriodoMes     := MONTH2STR(aResps[1])
    dPeriodoDia     := DAY2STR(aResps[1])
    dPeriodo        := dPeriodoAno + dPeriodoMes + dPeriodoDia

    cQuery := " SELECT A.[A1_COD], MAX(B.[F2_EMISSAO]) AS ULTIMA_COMPRA " + CRLF
    cQuery += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery += " LEFT JOIN (SELECT A.[A1_COD], B.[F2_EMISSAO] FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SF2") + " B " + CRLF
    cQuery += " ON A.[A1_COD] = B.[F2_CLIENTE]) " + " B " + CRLF
    cQuery += " ON A.[A1_COD] = B.[A1_COD] " + CRLF  
    cQuery += " WHERE B.[F2_EMISSAO] BETWEEN '"+ dPeriodo +"' AND GETDATE() " + CRLF
    cQuery += " GROUP BY A.[A1_COD] " + CRLF
    cQuery += " ORDER BY A.[A1_COD] ASC " + CRLF

    cAliasCL := MPSYSOPENQUERY(cQuery)

    WHILE (cAliasCL)->(!EOF())
        oSection1:INIT()
        oSection1:PRINTLINE()

        oReport:SKIPLINE(1)
        (cAliasCL)->(DBSKIP())
        oSection1:FINISH()
    ENDDO

    (cAliasCL)->(DBCLOSEAREA())

RETURN 
