#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOTVS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} TITULOS EM COBRANÇA
RELATORIO - TITULOS EM COBRANÇA
@author    BRUNO NASCIMENTO GONÇALVES
@since     11/03/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xTCOBRAN()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs, {1, "DATA DE",STOD(""),,,,, 100, .F.})
    AADD(aPergs, {1, "DATA ATE",STOD(""),,,,, 100, .F.})
    
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
    TRCELL():NEW(oSection1,"A1_COD",cAliasBC,"COD.CLI",,nSize,,{|| (cAliasBC)->A1_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    
    oBreak := TRBREAK():NEW(oSection1,oSection1:CELL("A1_COD"),"TOTAL",.F.)

RETURN oReport

STATIC FUNCTION REPORTPRINT(cAliasBC)

    LOCAL oSection1   := oReport:SECTION(1)
    LOCAL cQuery      := ""
    
    cQuery := " SELECT B.[A1_COD], " + CRLF
    cQuery += " B.[A1_LOJA], " + CRLF
    cQuery += " B.[A1_NREDUZ], " + CRLF
    cQuery += " TRIM(B.[A1_END]) + (' ' + '-' + ' ' + B.[A1_EST]) AS [A1_END], "  + CRLF
    cQuery += " A.[C5_NUM], " + CRLF
    cQuery += " A.[C5_TIPO], " + CRLF
    cQuery += " FORMAT(CONVERT(DATE, A.[C5_EMISSAO]), 'dd/MM/yy') AS [C5_EMISSAO], " + CRLF
    cQuery += " C.[A4_NOME], " + CRLF
    cQuery += " D.[E4_DESCRI], " + CRLF
    cQuery += " E.[A3_NOME] " + CRLF
	cQuery += " FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " B " + CRLF
    cQuery += " ON A.[C5_CLIENTE] = B.[A1_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA4") + " C " + CRLF
    cQuery += " ON A.[C5_TRANSP] = C.[A4_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SE4") + " D " + CRLF
    cQuery += " ON A.[C5_CONDPAG] = D.[E4_CODIGO] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA3") + " E " + CRLF
    cQuery += " ON A.[C5_VEND1] = E.[A3_COD] " + CRLF
    IF !EMPTY(cResult)
        cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_XSTEX] = '" + cResult +"'" + CRLF
    ELSE
        cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[C5_NUM] BETWEEN '"+ aPedidoDE +"' AND '"+ aPedidoATE +"'" + CRLF
    ENDIF        
    cQuery += " ORDER BY A.[C5_NUM]"

    cAliasBC := MPSYSOPENQUERY(cQuery)

RETURN 
