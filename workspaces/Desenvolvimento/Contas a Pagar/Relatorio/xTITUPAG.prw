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

    AADD(aPergs,{1,"Fornecedor De",SPACE(TAMSX3("A2_COD")[1]),,,"SA2",,100,.F.})
    AADD(aPergs,{1,"Fornecedor Ate",SPACE(TAMSX3("A2_COD")[1]),,,"SA2",,100,.F.})
    AADD(aPergs,{1,"Natureza De",SPACE(TAMSX3("ED_CODIGO")[1]),,,"SED",,100,.F.})
    AADD(aPergs,{1,"Natureza Ate",SPACE(TAMSX3("ED_CODIGO")[1]),,,"SED",,100,.F.})
    AADD(aPergs,{1,"Data da Contabilidade De",STOD(""),,,,,100,.F.})
    AADD(aPergs,{1,"Data da Contabilidade Ate",STOD(""),,,,,100,.F.})
    AADD(aPergs,{1,"Data da Baixa De",STOD(""),,,,,100,.F.})
    AADD(aPergs,{1,"Data da Baixa Ate",STOD(""),,,,,100,.F.})
    AADD(aPergs,{1,"Data de Emissão De",STOD(""),,,,,100,.F.})
    AADD(aPergs,{1,"Data de Emissão Ate",STOD(""),,,,,100,.F.})

    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.)
        oReport := REPORTDEF(aResps)
        oReport:PRINTDIALOG()
    ENDIF

RETURN

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasTI     := ""
    LOCAL cNomeArq     := "POSIÇÃO DOS TITULOS A PAGAR DO FORNECEDOR"
    LOCAL cTitulo      := "POSIÇÃO DOS TITULOS A PAGAR DO FORNECEDOR"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasTI,aResps)},"IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"A2_COD",cAliasTI,"CODIGO.FORNECEDOR",,nSize,,{|| (cAliasTI)->A2_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A2_NOME",cAliasTI,"NOME FORNECEDOR",,nSize,,{|| (cAliasTI)->A2_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_NUM",cAliasTI,"NUMERO DO TITULO",,nSize,,{|| (cAliasTI)->E2_NUM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_PARCELA",cAliasTI,"PARCELA",,nSize,,{|| (cAliasTI)->E2_PARCELA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_TIPO",cAliasTI,"TIPO",,nSize,,{|| (cAliasTI)->E2_TIPO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_NATUREZ",cAliasTI,"NATUREZA",,nSize,,{|| (cAliasTI)->E2_NATUREZ},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_EMISSAO",cAliasTI,"EMISSÃO",,nSize,,{|| (cAliasTI)->E2_EMISSAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_VENCTO",cAliasTI,"VENCIMENTO",,nSize,,{|| (cAliasTI)->E2_VENCTO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_VENCREA",cAliasTI,"VENCIMENTO REAL",,nSize,,{|| (cAliasTI)->E2_VENCREA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_BAIXA",cAliasTI,"BAIXA",,nSize,,{|| (cAliasTI)->E2_BAIXA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_EMIS1",cAliasTI,"DATA CONTABILIDADE",,nSize,,{|| (cAliasTI)->E2_EMIS1},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_VALOR",cAliasTI,"TOTAL DO FORNECEDOR",,nSize,,{|| (cAliasTI)->E2_VALOR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E2_SALDO",cAliasTI,"SALDO EM ABERTO",,nSize,,{|| (cAliasTI)->E2_SALDO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"E5_VALOR",cAliasTI,"TOTAL DA BAIXA",,nSize,,{|| (cAliasTI)->E5_VALOR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"SITUACAO",cAliasTI,"SITUAÇÃO",,nSize,,{|| (cAliasTI)->SITUACAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasTI,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL cQuery1   := ""

    IF LEN(aResps) == 10
        cForDe     := aResps[1]
        cForAte    := aResps[2]
        cNatDe     := aResps[3]
        cNatAte    := aResps[4]

        dDtDEAnoC  := YEAR2STR(aResps[5])
        dDtDEMesC  := MONTH2STR(aResps[5])
        dDtDEDiaC  := DAY2STR(aResps[5])
        dDtDEC     := dDtDEAnoC + dDtDEMesC + dDtDEDiaC
        dDtATEAnoC := YEAR2STR(aResps[6])
        dDtATEMesC := MONTH2STR(aResps[6])
        dDtATEDiaC := DAY2STR(aResps[6])
        dDtATEC    := dDtATEAnoC + dDtATEMesC + dDtATEDiaC

        dDtDEAnoB  := YEAR2STR(aResps[7])
        dDtDEMesB  := MONTH2STR(aResps[7])
        dDtDEDiaB  := DAY2STR(aResps[7])
        dDtDEB     := dDtDEAnoB + dDtDEMesB + dDtDEDiaB
        dDtATEAnoB := YEAR2STR(aResps[8])
        dDtATEMesB := MONTH2STR(aResps[8])
        dDtATEDiaB := DAY2STR(aResps[8])
        dDtATEB    := dDtATEAnoB + dDtATEMesB + dDtATEDiaB

        dDtDEAnoE  := YEAR2STR(aResps[9])
        dDtDEMesE  := MONTH2STR(aResps[9])
        dDtDEDiaE  := DAY2STR(aResps[9])
        dDtDEE     := dDtDEAnoE + dDtDEMesE +dDtDEDiaE
        dDtATEAnoE := YEAR2STR(aResps[10])
        dDtATEMesE := MONTH2STR(aResps[10])
        dDtATEDiaE := DAY2STR(aResps[10])
        dDtATEE    := dDtATEAnoE + dDtATEMesE + dDtATEDiaE
    ENDIF

    cQuery1 := " SELECT " + CRLF
    cQuery1 += " B.[A2_COD], " + CRLF
    cQuery1 += " B.[A2_NOME], " + CRLF
	cQuery1 += " A.[E2_NUM], " + CRLF
    cQuery1 += " A.[E2_PARCELA], " + CRLF
    cQuery1 += " A.[E2_TIPO], " + CRLF
    cQuery1 += " A.[E2_NATUREZ], " + CRLF
    cQuery1 += " FORMAT(CONVERT(DATE, A.[E2_EMISSAO]), 'dd/MM/yyyy') AS [E2_EMISSAO], " + CRLF
    cQuery1 += " FORMAT(CONVERT(DATE, A.[E2_VENCTO]), 'dd/MM/yyyy') AS [E2_VENCTO], " + CRLF
	cQuery1 += " FORMAT(CONVERT(DATE, A.[E2_VENCREA]), 'dd/MM/yyyy') AS [E2_VENCREA], " + CRLF
    cQuery1 += " CASE " + CRLF
    cQuery1 += " WHEN A.[E2_BAIXA] = '' THEN ' ' " + CRLF
    cQuery1 += " ELSE FORMAT(CONVERT(DATE, A.[E2_BAIXA]), 'dd/MM/yyyy') " + CRLF
    cQuery1 += " END AS [E2_BAIXA], " + CRLF
    cQuery1 += " FORMAT(CONVERT(DATE, A.[E2_EMIS1]), 'dd/MM/yyyy') AS [E2_EMIS1], " + CRLF
	cQuery1 += " A.[E2_VALOR], " + CRLF
    cQuery1 += " A.[E2_SALDO], " + CRLF
    cQuery1 += " C.[E5_VALOR], " + CRLF
    cQuery1 += " CASE " + CRLF
    cQuery1 += " WHEN A.[E2_BAIXA] > A.[E2_VENCTO] AND A.[E2_SALDO] = '0' THEN 'PAGO COM ' + REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_BAIXA], A.[E2_VENCTO])) + ' ' + 'DIAS EM ATRASO', '-','') " + CRLF
	cQuery1 += " WHEN A.[E2_BAIXA] < A.[E2_VENCTO] AND A.[E2_BAIXA] <> '' AND [E2_SALDO] = '0' THEN 'PAGO COM ' + REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_BAIXA], A.[E2_VENCTO])) + ' ' + 'DIAS ADIANTADO', '-','') " + CRLF
	cQuery1 += " WHEN A.[E2_VENCTO] < A.[E2_VENCREA] AND A.[E2_BAIXA] = '' THEN REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_VENCTO], A.[E2_VENCREA])) + ' ' + 'DIAS PRORROGADO', '-','') " + CRLF
    cQuery1 += " WHEN A.[E2_BAIXA] = A.[E2_VENCTO] AND A.[E2_SALDO] = '0' THEN 'PAGAMENTO REALIZADO NA DATA' " + CRLF 
    cQuery1 += " WHEN A.[E2_VENCTO] < GETDATE() AND A.[E2_BAIXA] = '' THEN REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E2_VENCTO], GETDATE())) + ' ' + 'DIAS VENCIDOS', '-','') " + CRLF 
    cQuery1 += " ELSE 'PAGAMENTO A VENCER' " + CRLF
    cQuery1 += " END AS [SITUACAO] " + CRLF
    cQuery1 += " FROM " + RETSQLNAME("SE2") + " A " + CRLF
    cQuery1 += " LEFT JOIN " + RETSQLNAME("SA2") + " B " + CRLF
    cQuery1 += " ON A.[E2_FORNECE] = B.[A2_COD] " + CRLF
    cQuery1 += " LEFT JOIN " + RETSQLNAME("SE5") + " C " + CRLF
    cQuery1 += " ON A.[E2_NUM] = C.[E5_NUMERO] AND A.[E2_FORNECE] = C.[E5_FORNECE] " + CRLF
    cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[E2_FORNECE] BETWEEN '"+cForDe+"' AND '"+cForAte+"'" + CRLF
    cQuery1 += " AND A.[E2_NATUREZ] BETWEEN '"+cNatDe+"' AND '"+cNatAte+"'" + CRLF
    cQuery1 += " AND A.[E2_EMIS1] BETWEEN '"+dDtDEC+"' AND '"+dDtATEC+"'" + CRLF
    cQuery1 += " AND A.[E2_BAIXA] BETWEEN '"+dDtDEB+"' AND '"+dDtATEB+"'" + CRLF
    cQuery1 += " AND A.[E2_EMISSAO] BETWEEN '"+dDtDEE+"' AND '"+dDtATEE+"'" + CRLF
    cQuery1 += " ORDER BY B.[A2_COD] "

    cQuery1   := CHANGEQUERY(cQuery1)
    cAliasTI := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery1),cAliasTI,.F.,.T.)

    WHILE (cAliasTI)->(!Eof())
        oSection1:INIT()
        oSection1:PRINTLINE()
                 
        (cAliasTI)->(DBSKIP())
    ENDDO
            
    oSection1:FINISH()
    (cAliasTI)->(DBCLOSEAREA())

RETURN
