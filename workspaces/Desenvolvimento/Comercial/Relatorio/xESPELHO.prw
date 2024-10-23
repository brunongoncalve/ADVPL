#INCLUDE "RPTDEF.CH"
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ESPELHO DE DEVOLUÇÃO
RELATORIO - ESPELHO DE DEVOLUÇÃO
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     15/02/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xESPELHO()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs,{1,"Protocolo",SPACE(TAMSX3("ZZW_NUM")[1]),,,"ZZW",,100,.F.})
    AADD(aPergs,{1,"Protocolo",SPACE(TAMSX3("ZZW_NUM")[1]),,,"ZZW",,100,.F.})
    
    IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,,.T.,.T.)
        oReport := REPORTDEF(aResps)
        oReport:PRINTDIALOG()
    ENDIF

RETURN

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL oSection2    := NIL
    LOCAL oSection3    := NIL
    LOCAL oSection4    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasRM     := ""
    LOCAL cAliasDT     := ""
    LOCAL cNomeArq     := "ESPELHO DA NOTA"
    LOCAL cTitulo      := "ESPELHO DA NOTA"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasRM,@cAliasDT,aResps)},"IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"",,"REMETENTE",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_CGC",cAliasRM,"CNPJ",,nSize,,{|| (cAliasRM)->A1_CGC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_NOME",cAliasRM,"NOME",,nSize,,{|| (cAliasRM)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_END",cAliasRM,"ENDERECO",,nSize,,{|| (cAliasRM)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_EST",cAliasRM,"ESTADO",,nSize,,{|| (cAliasRM)->A1_EST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_MUN",cAliasRM,"MUNICIPIO",,nSize,,{|| (cAliasRM)->A1_MUN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_INSCR",cAliasRM,"INSCRICAO ESTADUAL",,nSize,,{|| (cAliasRM)->A1_INSCR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasRM,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL cQuery    := ""
    LOCAL cQuery1   := ""
    LOCAL aProDE    := aResps[1]
    LOCAL aProATE   := aResps[2]

    cQuery := " SELECT TOP 1 " + CRLF
    cQuery += " C.[A1_CGC], " + CRLF
	cQuery += " C.[A1_NOME], " + CRLF
	cQuery += " C.[A1_END], " + CRLF
	cQuery += " C.[A1_EST], " + CRLF
	cQuery += " C.[A1_MUN], " + CRLF
	cQuery += " C.[A1_INSCR] " + CRLF
    cQuery += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF 
    cQuery += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
    cQuery += " ON A.[ZZW_NUM] = B.[ZZY_NUM] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " C " + CRLF 
    cQuery += " ON A.[ZZW_CLI] = C.[A1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] BETWEEN '"+ aProDE +"' AND '"+ aProATE +"'" + CRLF

    cAliasRM := MPSYSOPENQUERY(cQuery)
    
        WHILE (cAliasRM)->(!EOF())
            oSection1:INIT()
            oSection1:PRINTLINE()
            oSection1:SETPAGEBREAK(.T.)
            oReport:SKIPLINE(10)

            (cAliasRM)->(DBSKIP())
            oSection1:FINISH()
        ENDDO

    (cAliasRM)->(DBCLOSEAREA())

RETURN
