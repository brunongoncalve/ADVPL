#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO CONFERENCIA DE OP
RELATORIO - CONFERENCIA OP
@author    BRUNO NASCIMENTO GONÇALVES
@since     27/08/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xCONFEOP()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}


    AADD(aPergs, {1, "Produto De", SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100,.F.})
    AADD(aPergs, {1, "Produto Ate", SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100,.F.})
    AADD(aPergs, {1, "OP De", SPACE(TAMSX3("C2_OP")[1]),,,"SC2",,100,.F.})
    AADD(aPergs, {1, "OP Ate", SPACE(TAMSX3("C2_OP")[1]),,,"SC2",,100,.F.})
    AADD(aPergs, {1, "DATA ATE",STOD(""),,,,,100,.F.})
    
    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,, .T., .T.)
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
    LOCAL cAliasOP     := ""
    LOCAL cNomeArq     := "CONFERENCIA DE OP"
    LOCAL cTitulo      := "CONFERENCIA DE OP"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasOP,aResps)},"IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"C2_OP",cAliasOP,"ORDEM DE PRODUÇÃO",,nSize,,{|| (cAliasOP)->C2_OP},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"PROD_PAI",cAliasOP,"PRODUTO PAI",,nSize,,{|| (cAliasOP)->PROD_PAI},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"PROD_FILHO",cAliasOP,"PRODUTO FILHO",,nSize,,{|| (cAliasOP)->PROD_FILHO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"QTD_BAIXA",cAliasOP,"QUANTIDADE BAIXA",,nSize,,{|| (cAliasOP)->QTD_BAIXA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"PERIODO",cAliasOP,"PERIODO",,nSize,,{|| (cAliasOP)->PERIODO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"QT_PRODUZIDA",cAliasOP,"QUANTIDADE PRODUZIDA",,nSize,,{|| (cAliasOP)->QT_PRODUZIDA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"QTD_ENG",cAliasOP,"QUANTIDADE ENGENHARIA",,nSize,,{|| (cAliasOP)->QTD_ENG},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"DIFERENCA",cAliasOP,"DIFERENCA",,nSize,,{|| (cAliasOP)->DIFERENCA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasOP,aResps)

    LOCAL oSection1   := oReport:SECTION(1)
    LOCAL cProdutoDe  := aResps[1]
    LOCAL cProdutoAte := aResps[2]
    LOCAL cOPDe       := aResps[3]
    LOCAL cOPAte      := aResps[4]
    LOCAL cQuery      := ""

    dPeriodoAno := YEAR2STR(aResps[5])
    dPeriodoMes := MONTH2STR(aResps[5])
    dPeriodo    := dPeriodoMes + "/" + dPeriodoAno

    cQuery := " SELECT T.*, ISNULL(SUM(C.D3_QUANT),0) AS QT_PRODUZIDA, " + CRLF
    cQuery += " MIN(ROUND(SG1.G1_QUANT,8)) AS QTD_ENG, " + CRLF
    cQuery += " CASE (MIN(ROUND(SG1.G1_QUANT,8)) * ISNULL(SUM(C.D3_QUANT),0)) WHEN 0 THEN 100 " + CRLF
    cQuery += " ELSE  ROUND(100 - ( (MIN(ROUND(SG1.G1_QUANT,8)) * ISNULL(SUM(C.D3_QUANT),0)) / T.QTD_BAIXA) * 100,8) END AS DIFERENCA " + CRLF
    cQuery += " FROM " + CRLF
    cQuery += " (SELECT A.C2_OP,A.C2_PRODUTO AS PROD_PAI, " + CRLF
    cQuery += " B.D3_COD AS PROD_FILHO,SUM(B.D3_QUANT) AS QTD_BAIXA,B.D3_TM,D3_TRT, " + CRLF
    cQuery += " FORMAT(CAST(D3_EMISSAO AS DATE), 'MM/yyyy') AS PERIODO " + CRLF
    cQuery += " FROM " + RETSQLNAME("SC2") + " A " + CRLF
    cQuery += " JOIN " + RETSQLNAME("SD3") + " B " + CRLF
    cQuery += " ON A.C2_OP = B.D3_OP AND B.D_E_L_E_T_='' AND B.D3_CF <> 'PR0' AND B.D3_ESTORNO=''AND D3_TRT <> '' " + CRLF
    cQuery += " WHERE A.D_E_L_E_T_='' " + CRLF
    cQuery += " GROUP BY A.C2_OP,A.C2_PRODUTO,FORMAT(CAST(D3_EMISSAO AS DATE), 'MM/yyyy'), B.D3_COD,B.D3_TM,D3_TRT) AS T" + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SD3") + " C " + CRLF
    cQuery += " ON T.C2_OP = C.D3_OP AND T.PERIODO = FORMAT(CAST(C.D3_EMISSAO AS DATE), 'MM/yyyy')  AND C.D_E_L_E_T_='' AND C.D3_CF = 'PR0' AND C.D3_ESTORNO='' " + CRLF
    cQuery += " LEFT JOIN " + CRLF
    cQuery += " (SELECT G1_COD,G1_COMP,G1_TRT,MAX(G1_QUANT) G1_QUANT,MAX(G1_REVFIM) G1_REVFIM, D_E_L_E_T_ " + CRLF
    cQuery += " FROM " + RETSQLNAME("SG1") + "" + CRLF
    cQuery += " GROUP BY G1_COD,G1_COMP,G1_TRT,D_E_L_E_T_) AS SG1 " + CRLF
    cQuery += " ON SG1.G1_COD = T.PROD_PAI AND SG1.G1_COMP = T.PROD_FILHO AND  SG1.G1_TRT = T.D3_TRT  AND SG1.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " WHERE T.PROD_PAI BETWEEN '"+cProdutoDe+"' AND '"+cProdutoAte+"' AND T.C2_OP BETWEEN '"+cOPDe+"' AND '"+cOPAte+"' AND T.PERIODO >= '"+dPeriodo+"' " + CRLF
    cQuery += " GROUP BY T.C2_OP,T.PROD_PAI,T.PROD_FILHO,T.QTD_BAIXA,T.D3_TM,T.PERIODO,T.D3_TRT " + CRLF
    cQuery += " ORDER BY PERIODO,C2_OP "

    cAliasOP := MPSYSOPENQUERY(cQuery)

    WHILE (cAliasOP)->(!EOF())
        oSection1:INIT()
        oSection1:PRINTLINE()

        (cAliasOP)->(DBSKIP())
    ENDDO
    
    oSection1:FINISH()
    (cAliasOP)->(DBCLOSEAREA())

RETURN  

