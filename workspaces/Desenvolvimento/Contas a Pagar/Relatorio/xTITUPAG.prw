#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - POSIÇÃO DOS TITULOS A PAGAR DO FORNECEDOR
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xTITUPAG()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs,{1,"COD. FORNECEDOR",SPACE(TAMSX3("A2_COD")[1]),,,"SA2",,100,.F.})
    AADD(aPergs,{1,"DATA DE",STOD(""),,,,,100,.F.})
    AADD(aPergs,{1,"DATA ATE",STOD(""),,,,,100,.F.})

    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.)
        oReport := REPORTDEF(aResps)
        oReport:PRINTDIALOG()
    ENDIF

RETURN

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL oSection2    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasFOR    := ""
    LOCAL cAliasTI     := ""
    LOCAL cNomeArq     := "POSIÇÃO DOS TITULOS A PAGAR DO FORNECEDOR"
    LOCAL cTitulo      := "POSIÇÃO DOS TITULOS A PAGAR DO FORNECEDOR"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasFOR,@cAliasTI,aResps)},"IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"CODIGO_FORNECEDOR",cAliasFOR,"COD.FORNECEDOR",,nSize,,{|| (cAliasFOR)->A2_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"NOME",cAliasFOR,"NOME DO FORNECEDOR",,nSize,,{|| (cAliasFOR)->A2_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2,"E2_NUM",cAliasTI,"NUMERO DO TITULO",,nSize,,{|| (cAliasTI)->E2_NUM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_PARCELA",cAliasTI,"PARCELA",,nSize,,{|| (cAliasTI)->E2_PARCELA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_TIPO",cAliasTI,"TIPO",,nSize,,{|| (cAliasTI)->E2_TIPO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_EMISSAO",cAliasTI,"EMISSÃO",,nSize,,{|| (cAliasTI)->E2_EMISSAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_VENCTO",cAliasTI,"VENCIMENTO",,nSize,,{|| (cAliasTI)->E2_VENCTO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_VENCREA",cAliasTI,"VENCIMENTO REAL",,nSize,,{|| (cAliasTI)->E2_VENCREA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_BAIXA",cAliasTI,"BAIXA",,nSize,,{|| (cAliasTI)->E2_BAIXA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_VALOR",cAliasTI,"TOTAL DO FORNECEDOR",,nSize,,{|| (cAliasTI)->E2_VALOR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E2_SALDO",cAliasTI,"SALDO EM ABERTO",,nSize,,{|| (cAliasTI)->E2_SALDO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"SITUACAO",cAliasTI,"SITUAÇÃO",,nSize,,{|| (cAliasTI)->SITUACAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    TRFUNCTION():NEW(oSection2:CELL("E2_VALOR"),,"SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection2)
    TRFUNCTION():NEW(oSection2:CELL("E2_SALDO"),,"SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection2)
    
RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasFOR,cAliasTI,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL cQuery    := ""
    LOCAL cQuery1   := ""

    IF LEN(aResps) == 3
        cFornecedor := aResps[1]
        dDataDEAno  := YEAR2STR(aResps[2])
        dDataDEMes  := MONTH2STR(aResps[2])
        dDataDEDia  := DAY2STR(aResps[2])
        dDataDE     := dDataDEAno + dDataDEMes + dDataDEDia
        dDataATEAno := YEAR2STR(aResps[3])
        dDataATEMes := MONTH2STR(aResps[3])
        dDataATEDia := DAY2STR(aResps[3])
        dDataATE    := dDataATEAno + dDataATEMes + dDataATEDia
    ENDIF

    cQuery := " SELECT " + CRLF
    cQuery += " A.[A2_COD], " + CRLF
    cQuery += " A.[A2_LOJA], " + CRLF
    cQuery += " A.[A2_NOME] " + CRLF
    cQuery += " FROM " + RETSQLNAME("SA2") + " A " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[A2_COD] = '"+cFornecedor+"' AND A.[A2_LOJA] = '01'" + CRLF

    cQuery    := CHANGEQUERY(cQuery)
    cAliasFOR := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasFOR,.F.,.T.)

    WHILE (cAliasFOR)->(!Eof())
        oSection1:INIT()
        oSection1:PRINTLINE()

        cQuery1 := " SELECT " + CRLF
	    cQuery1 += " A.[E2_NUM], " + CRLF
        cQuery1 += " A.[E2_PARCELA], " + CRLF
        cQuery1 += " A.[E2_TIPO], " + CRLF
        cQuery1 += " FORMAT(CONVERT(DATE, A.[E2_EMISSAO]), 'dd/MM/yyyy') AS [E2_EMISSAO], " + CRLF
        cQuery1 += " FORMAT(CONVERT(DATE, A.[E2_VENCTO]), 'dd/MM/yyyy') AS [E2_VENCTO], " + CRLF
	    cQuery1 += " FORMAT(CONVERT(DATE, A.[E2_VENCREA]), 'dd/MM/yyyy') AS [E2_VENCREA], " + CRLF
        cQuery1 += " CASE " + CRLF
        cQuery1 += " WHEN A.[E2_BAIXA] = '' THEN ' ' " + CRLF
        cQuery1 += " ELSE FORMAT(CONVERT(DATE, A.[E2_BAIXA]), 'dd/MM/yyyy') " + CRLF
        cQuery1 += " END AS [E2_BAIXA], " + CRLF
	    cQuery1 += " A.[E2_VALOR], " + CRLF
        cQuery1 += " A.[E2_SALDO], " + CRLF
        cQuery1 += " CASE " + CRLF
        cQuery1 += " WHEN A.[E2_BAIXA] > A.[E2_VENCTO] AND A.[E2_SALDO] = '0' THEN 'PAGO COM ' + REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_BAIXA], A.[E2_VENCTO])) + ' ' + 'DIAS EM ATRASO', '-','') " + CRLF
	    cQuery1 += " WHEN A.[E2_BAIXA] < A.[E2_VENCTO] AND A.[E2_BAIXA] <> '' AND [E2_SALDO] = '0' THEN 'PAGO COM ' + REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_BAIXA], A.[E2_VENCTO])) + ' ' + 'DIAS ADIANTADO', '-','') " + CRLF
	    cQuery1 += " WHEN A.[E2_VENCTO] < A.[E2_VENCREA] AND A.[E2_BAIXA] = '' THEN REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_VENCTO], A.[E2_VENCREA])) + ' ' + 'DIAS PRORROGADO', '-','') " + CRLF
        cQuery1 += " WHEN A.[E2_BAIXA] = A.[E2_VENCTO] AND A.[E2_SALDO] = '0' THEN 'PAGAMENTO REALIZADO NA DATA' " + CRLF 
        cQuery1 += " WHEN A.[E2_VENCTO] < GETDATE() AND A.[E2_BAIXA] = '' THEN REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_VENCTO], GETDATE())) + ' ' + 'DIAS VENCIDOS', '-','') " + CRLF 
        cQuery1 += " ELSE 'PAGAMENTO A VENCER' " + CRLF
        cQuery1 += " END AS [SITUACAO] " + CRLF
        cQuery1 += " FROM " + RETSQLNAME("SE2") + " A " + CRLF
        cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[E2_FORNECE] = '"+cFornecedor+"' AND A.[E2_EMISSAO] BETWEEN '"+dDataDE+"' AND '"+dDataATE+"' AND A.[E2_TIPO] <> 'NCC'" + CRLF

        cQuery1   := CHANGEQUERY(cQuery1)
        cAliasTI := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery1),cAliasTI,.F.,.T.)

            WHILE (cAliasTI)->(!Eof())
                oSection2:INIT()
                oSection2:PRINTLINE()
                
                oReport:SKIPLINE(2)
                (cAliasTI)->(DBSKIP())
            ENDDO
            
            oSection2:FINISH()
            (cAliasTI)->(DBCLOSEAREA())
        
        (cAliasFOR)->(DBSKIP())
        oSection1:FINISH()
    ENDDO

    (cAliasFOR)->(DBCLOSEAREA())

RETURN
