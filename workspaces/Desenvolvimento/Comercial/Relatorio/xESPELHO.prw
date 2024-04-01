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

    AADD(aPergs, {1, "CLIENTE DE", SPACE(TAMSX3("A1_COD")[1]) ,,,"SA1",, 100, .F.})
    AADD(aPergs, {1, "CLIENTE ATE", SPACE(TAMSX3("A1_COD")[1]) ,,,"SA1",, 100, .F.})
    
        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            oReport := REPORTDEF(aResps)
            oReport:PRINTDIALOG()
        ENDIF

RETURN

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL nColSpace    := 1
    LOCAL nSize        := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "CENTER"
    LOCAL cHeaderAlign := "CENTER"
    LOCAL cAliasCL     := ""
    LOCAL cNomeArq     := "ESPELHO DA NOTA"
    LOCAL cTitulo      := "ESPELHO DA NOTA"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasCL, aResps)}, "IMPRESSÃO DE RELATORIO",.T.)

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"",cAliasCL,"REMETENTE",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_CGC",cAliasCL,"CNPJ",,nSize,,{|| (cAliasCL)->A1_CGC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_NOME",cAliasCL,"NOME",,nSize,,{|| (cAliasCL)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_END",cAliasCL,"ENDERECO",,nSize,,{|| (cAliasCL)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_EST",cAliasCL,"ESTADO",,nSize,,{|| (cAliasCL)->A1_EST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_MUN",cAliasCL,"MUNICIPIO",,nSize,,{|| (cAliasCL)->A1_MUN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_INSCR",cAliasCL,"INSCRICAO ESTADUAL",,nSize,,{|| (cAliasCL)->A1_INSCR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
   
RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasCL, aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL cQuery    := ""
    LOCAL aCliDE    := aResps[1]
    LOCAL aCliATE   := aResps[2]

    cQuery := " SELECT A.[A1_CGC], A.[A1_NOME], A.[A1_END], A.[A1_EST], A.[A1_MUN], A.[A1_INSCR] " + CRLF
	cQuery += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[A1_COD] BETWEEN '"+ aCliDE +"' AND '"+ aCliATE +"'" + CRLF

    cAliasCL := MPSYSOPENQUERY(cQuery)
    
        WHILE (cAliasCL)->(!EOF())
            oSection1:INIT(.T.)
            oSection1:PRINTLINE()
            oSection1:SETPAGEBREAK(.T.)

            (cAliasCL)->(DBSKIP())
            oSection1:FINISH()

        ENDDO

    (cAliasCL)->(DBCLOSEAREA())

RETURN
