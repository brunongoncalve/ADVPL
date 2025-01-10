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

    IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T.,.T.)
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
    LOCAL cAliasCL     := ""
    LOCAL cNomeArq     := "TITULOS CLIENTES"
    LOCAL cTitulo      := "TITULOS CLIENTES"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasCL,aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"CODIGO_CLIENTE",cAliasCL,"COD.CLI",,nSize,,{|| (cAliasCL)->A1_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasCL,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL cQuery    := ""
    LOCAL nCli      := aResps[1]
   
    cQuery := " SELECT " + CRLF
    cQuery += " B.[A1_COD], " + CRLF
    cQuery += " B.[A1_NOME], " + CRLF
	cQuery += " A.[E1_NUM], " + CRLF
    cQuery += " A.[E1_TIPO], " + CRLF
    cQuery += " A.[E1_VENCTO], " + CRLF
	cQuery += " A.[E1_VENCREA], " + CRLF
	cQuery += " A.[E1_VALOR], " + CRLF
    cQuery += " CASE " + CRLF
    cQuery += " WHEN [E1_BAIXA] > [E1_VENCTO] THEN REPLACE(CONVERT(VARCHAR, DATEDIFF(DAY, [E1_BAIXA], [E1_VENCTO])) + ' ' + 'DIAS EM ATRASO', '-','') " + CRLF
	cQuery += " WHEN [E1_VENCTO] < [E1_VENCREA] THEN CONVERT(VARCHAR, DATEDIFF(DAY, [E1_VENCTO], [E1_VENCREA])) + ' ' + 'DIAS PRORROGADO' " + CRLF
	cQuery += " WHEN [E1_BAIXA] = [E1_VENCTO] AND [E1_SALDO] = '0' THEN 'PAGO NA DATA' " + CRLF
    cQuery += " ELSE 'A VENCER' " + CRLF 
    cQuery += " END AS [STATUS] " + CRLF
    cQuery += " FROM " + RETSQLNAME("SE1") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " B " + CRLF
    cQuery += " ON A.[E1_CLIENTE] = B.[A1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND [E1_CLIENTE] = '"+nCli+"' " + CRLF

    cQuery   := CHANGEQUERY(cQuery)
    cAliasCL := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCL,.F.,.T.)

    WHILE (cAliasCL)->(!Eof())
        oSection1:INIT()
        oSection1:PRINTLINE()

        (cAliasCL)->(DBSKIP())
    ENDDO

    (cAliasCL)->(DBCLOSEAREA())

RETURN
