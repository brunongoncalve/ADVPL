#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - TITULOS CLIENTES
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xTITUCLI()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs,{1,"COD. CLIENTE",SPACE(TAMSX3("A1_COD")[1]),,,"SA1",,100,.F.})
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
    LOCAL cAliasCL     := ""
    LOCAL cAliasTI     := ""
    LOCAL cNomeArq     := "POSIÇÃO DOS TITULOS DO CLIENTE"
    LOCAL cTitulo      := "POSIÇÃO DOS TITULOS DO CLIENTE"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasCL,@cAliasTI,aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"CODIGO_CLIENTE",cAliasCL,"COD.CLI",,nSize,,{|| (cAliasCL)->A1_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"NOME",cAliasCL,"NOME DO CLIENTE",,nSize,,{|| (cAliasCL)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2,"E1_NUM",cAliasTI,"NUMERO DO TITULO",,nSize,,{|| (cAliasTI)->E1_NUM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_PARCELA",cAliasTI,"PARCELA",,nSize,,{|| (cAliasTI)->E1_PARCELA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_TIPO",cAliasTI,"TIPO",,nSize,,{|| (cAliasTI)->E1_TIPO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_EMISSAO",cAliasTI,"EMISSÃO",,nSize,,{|| (cAliasTI)->E1_EMISSAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_VENCTO",cAliasTI,"VENCIMENTO",,nSize,,{|| (cAliasTI)->E1_VENCTO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_VENCREA",cAliasTI,"VENCIMENTO REAL",,nSize,,{|| (cAliasTI)->E1_VENCREA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_BAIXA",cAliasTI,"BAIXA",,nSize,,{|| (cAliasTI)->E1_BAIXA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_VALOR",cAliasTI,"TOTAAL DO CLIENTE",,nSize,,{|| (cAliasTI)->E1_VALOR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"E1_SALDO",cAliasTI,"SALDO EM ABERTO",,nSize,,{|| (cAliasTI)->E1_SALDO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2,"SITUACAO",cAliasTI,"SITUAÇÃO",,nSize,,{|| (cAliasTI)->SITUACAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    TRFUNCTION():NEW(oSection2:CELL("E1_VALOR"),,"SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection2)
    TRFUNCTION():NEW(oSection2:CELL("E1_SALDO"),,"SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection2)
    
RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasCL,cAliasTI,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL cQuery    := ""
    LOCAL cQuery1   := ""

    IF LEN(aResps) == 3
        cCliente    := aResps[1]
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
    cQuery += " A.[A1_COD], " + CRLF
    cQuery += " A.[A1_LOJA], " + CRLF
    cQuery += " A.[A1_NOME] " + CRLF
    cQuery += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[A1_COD] = '"+cCliente+"' AND A.[A1_LOJA] = '01'" + CRLF

    cQuery   := CHANGEQUERY(cQuery)
    cAliasCL := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCL,.F.,.T.)

    WHILE (cAliasCL)->(!Eof())
        oSection1:INIT()
        oSection1:PRINTLINE()

        cQuery1 := " SELECT " + CRLF
	    cQuery1 += " A.[E1_NUM], " + CRLF
        cQuery1 += " A.[E1_PARCELA], " + CRLF
        cQuery1 += " A.[E1_TIPO], " + CRLF
        cQuery1 += " FORMAT(CONVERT(DATE, A.[E1_EMISSAO]), 'dd/MM/yyyy') AS [E1_EMISSAO], " + CRLF
        cQuery1 += " FORMAT(CONVERT(DATE, A.[E1_VENCTO]), 'dd/MM/yyyy') AS [E1_VENCTO], " + CRLF
	    cQuery1 += " FORMAT(CONVERT(DATE, A.[E1_VENCREA]), 'dd/MM/yyyy') AS [E1_VENCREA], " + CRLF
        cQuery1 += " CASE " + CRLF
        cQuery1 += " WHEN A.[E1_BAIXA] = '' THEN ' ' " + CRLF
        cQuery1 += " ELSE FORMAT(CONVERT(DATE, A.[E1_BAIXA]), 'dd/MM/yyyy') " + CRLF
        cQuery1 += " END AS [E1_BAIXA], " + CRLF
	    cQuery1 += " A.[E1_VALOR], " + CRLF
        cQuery1 += " A.[E1_SALDO], " + CRLF
        cQuery1 += " CASE " + CRLF
        cQuery1 += " WHEN A.[E1_BAIXA] > A.[E1_VENCTO] AND A.[E1_SALDO] = '0' THEN 'PAGO COM ' + REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E1_BAIXA], A.[E1_VENCTO])) + ' ' + 'DIAS EM ATRASO', '-','') " + CRLF
	    cQuery1 += " WHEN A.[E1_BAIXA] < A.[E1_VENCTO] AND A.[E1_BAIXA] <> '' AND [E1_SALDO] = '0' THEN 'PAGO COM ' + REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E1_BAIXA], A.[E1_VENCTO])) + ' ' + 'DIAS ADIANTADO', '-','') " + CRLF
	    cQuery1 += " WHEN A.[E1_VENCTO] < A.[E1_VENCREA] AND A.[E1_BAIXA] = '' THEN REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E1_VENCTO], A.[E1_VENCREA])) + ' ' + 'DIAS PRORROGADO', '-','') " + CRLF
        cQuery1 += " WHEN A.[E1_BAIXA] = A.[E1_VENCTO] AND A.[E1_SALDO] = '0' THEN 'PAGAMENTO REALIZADO NA DATA' " + CRLF 
        cQuery1 += " WHEN A.[E1_VENCTO] < GETDATE() AND A.[E1_BAIXA] = '' THEN REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, A.[E1_VENCTO], GETDATE())) + ' ' + 'DIAS VENCIDOS', '-','') " + CRLF 
        cQuery1 += " ELSE 'PAGAMENTO A VENCER' " + CRLF
        cQuery1 += " END AS [SITUACAO] " + CRLF
        cQuery1 += " FROM " + RETSQLNAME("SE1") + " A " + CRLF
        cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[E1_CLIENTE] = '"+cCliente+"' AND A.[E1_EMISSAO] BETWEEN '"+dDataDE+"' AND '"+dDataATE+"' AND A.[E1_TIPO] <> 'NCC'" + CRLF

        cQuery1   := CHANGEQUERY(cQuery1)
        cAliasTI := GETNEXTALIAS()
        DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery1),cAliasTI,.F.,.T.)

            WHILE (cAliasTI)->(!Eof())
                oSection2:INIT()
                oSection2:PRINTLINE()
                
                oReport:SKIPLINE(1)
                (cAliasTI)->(DBSKIP())
            ENDDO
            
            oSection2:FINISH()
            (cAliasTI)->(DBCLOSEAREA())
        
        (cAliasCL)->(DBSKIP())
        oSection1:FINISH()
    ENDDO

    (cAliasCL)->(DBCLOSEAREA())

RETURN
