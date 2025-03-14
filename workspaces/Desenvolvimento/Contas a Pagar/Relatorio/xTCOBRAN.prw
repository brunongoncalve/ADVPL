#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOTVS.ch"
#INCLUDE "prtopdef.ch"
#INCLUDE 'TOPCONN.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} TITULOS EM COBRANÇA
RELATORIO - TITULOS EM COBRANÇA
@author    BRUNO NASCIMENTO GONÇALVES
@since     11/03/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xTCOBRAN()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    IF CUSERNAME == "CLAUDIO"
        AADD(aPergs, {1, "COD. BANCO", SPACE(TAMSX3("A6_COD")[1]),,,"SA6",,100, .F.})
        AADD(aPergs, {1, "DATA DE",STOD(""),,,,, 100, .F.})
        AADD(aPergs, {1, "DATA ATE",STOD(""),,,,, 100, .F.})
    ELSE 
        AADD(aPergs, {1, "DATA DE",STOD(""),,,,, 100, .F.})
        AADD(aPergs, {1, "DATA ATE",STOD(""),,,,, 100, .F.})
    ENDIF 

    IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
        oReport := REPORTDEF(aResps)
        oReport:PRINTDIALOG()
    ENDIF

RETURN 

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize1       := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasBC     := ""
    LOCAL cNomeArq     := "TITULOS EM COBRANÇA"
    LOCAL cTitulo      := "TITULOS EM COBRANÇA"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasBC, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"E1_CONTA",cAliasBC,"CONTA CORRENTE",,nSize1,,{|| (cAliasBC)->E1_CONTA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A6_COD",cAliasBC,"CODIGO CONTA",,nSize1,,{|| (cAliasBC)->A6_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A6_NOME",cAliasBC,"NOME CONTA",,nSize1,,{|| (cAliasBC)->A6_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"QUANTIDADE_TITULOS",cAliasBC,"Qtd DE TITULOS",,nSize1,,{|| (cAliasBC)->QUANTIDADE_TITULOS},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"SALDO",cAliasBC,"SALDO","@E 9,999,999,999.99",nSize1,,{|| (cAliasBC)->SALDO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    TRFUNCTION():NEW(oSection1:CELL("SALDO"),,"SUM",,"SOMA TOTAL","@E 999,999,999,999.99",,.F.,.T.,,oSection1)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasBC, aResps)

    LOCAL oSection1  := oReport:SECTION(1)
    LOCAL cQuery     := ""

    IF LEN(aResps) == 3
        cBanco      := aResps[1]
        dDataDEAno  := YEAR2STR(aResps[2])
        dDataDEMes  := MONTH2STR(aResps[2])
        dDataDEDia  := DAY2STR(aResps[2])
        dDataDE     := dDataDEAno + dDataDEMes + dDataDEDia
        dDataATEAno := YEAR2STR(aResps[3])
        dDataATEMes := MONTH2STR(aResps[3])
        dDataATEDia := DAY2STR(aResps[3])
        dDataATE    := dDataATEAno + dDataATEMes + dDataATEDia
    ELSEIF LEN(aResps) == 2
        cBanco      := ""
        dDataDEAno  := YEAR2STR(aResps[1])
        dDataDEMes  := MONTH2STR(aResps[1])
        dDataDEDia  := DAY2STR(aResps[1])
        dDataDE     := dDataDEAno + dDataDEMes + dDataDEDia
        dDataATEAno := YEAR2STR(aResps[2])
        dDataATEMes := MONTH2STR(aResps[2])
        dDataATEDia := DAY2STR(aResps[2])
        dDataATE    := dDataATEAno + dDataATEMes + dDataATEDia
    ENDIF
    
    cQuery := " SELECT A.[E1_CONTA], SUM(A.[E1_SALDO]) AS SALDO, COUNT(A.[E1_CONTA]) AS QUANTIDADE_TITULOS, B.[A6_NOME], B.[A6_COD] " + CRLF
	cQuery += " FROM " + RETSQLNAME("SE1") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA6") + " B " + CRLF
    cQuery += " ON A.[E1_CONTA] = B.[A6_NUMCON] " + CRLF
    IF CUSERNAME == "CLAUDIO" .AND. EMPTY(cBanco)
        cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[E1_VENCREA] BETWEEN '"+ dDataDE +"' AND '"+ dDataATE +"'" + CRLF 
    ELSEIF !EMPTY(cBanco)
        cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[E1_VENCREA] BETWEEN '"+ dDataDE +"' AND '"+ dDataATE +"' AND B.[A6_COD] = '"+ cBanco +"'" + CRLF 
    ELSE
        cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[E1_VENCREA] BETWEEN '"+ dDataDE +"' AND '"+ dDataATE +"' AND B.[A6_COD] IN ('274', '341', '033', '637', '707', '300', '302', '305', '307', '310', '311', '314', '321', '326')" + CRLF
    ENDIF
    cQuery += " GROUP BY  A.[E1_CONTA], B.[A6_NOME], B.[A6_COD] " 
 
    cQuery   := CHANGEQUERY(cQuery)
    cAliasBC := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasBC,.F.,.T.)

    WHILE (cAliasBC)->(!EOF())
        oSection1:INIT()
        oSection1:PRINTLINE()

        oReport:SKIPLINE(1)
        (cAliasBC)->(DBSKIP())
        oSection1:FINISH()
    ENDDO

    (cAliasBC)->(DBCLOSEAREA())

RETURN 

