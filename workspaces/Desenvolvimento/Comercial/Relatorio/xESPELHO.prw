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
    LOCAL oSection2    := NIL
    LOCAL nColSpace    := 1
    LOCAL nSize        := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasRM     := ""
    LOCAL cAliasDT     := ""
    LOCAL cNomeArq     := "ESPELHO DA NOTA"
    LOCAL cTitulo      := "ESPELHO DA NOTA"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasRM, @cAliasDT, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"",cAliasRM,"REMETENTE",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_CGC",cAliasRM,"CNPJ",,nSize,,{|| (cAliasRM)->A1_CGC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_NOME",cAliasRM,"NOME",,nSize,,{|| (cAliasRM)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_END",cAliasRM,"ENDERECO",,nSize,,{|| (cAliasRM)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_EST",cAliasRM,"ESTADO",,nSize,,{|| (cAliasRM)->A1_EST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_MUN",cAliasRM,"MUNICIPIO",,nSize,,{|| (cAliasRM)->A1_MUN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_INSCR",cAliasRM,"INSCRICAO ESTADUAL",,nSize,,{|| (cAliasRM)->A1_INSCR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2,"",,"NATUREZA DA OPERAÇÃO",,nSize,,{|| "DEVOLUÇÃO"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
   
RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasRM, cAliasDT,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL cQuery    := ""
    LOCAL cQuery1   := ""
    LOCAL aCliDE    := aResps[1]
    LOCAL aCliATE   := aResps[2]

    cQuery := " SELECT A.[A1_CGC], A.[A1_NOME], A.[A1_END], A.[A1_EST], A.[A1_MUN], A.[A1_INSCR] " + CRLF
	cQuery += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[A1_COD] BETWEEN '"+ aCliDE +"' AND '"+ aCliATE +"'" + CRLF

    cAliasRM := MPSYSOPENQUERY(cQuery)
    
        WHILE (cAliasRM)->(!EOF())
            oSection1:INIT()
            oSection1:PRINTLINE()
            oSection1:SETPAGEBREAK(.T.)

                cQuery1 := " SELECT A.[A1_CGC], A.[A1_NOME], A.[A1_END], A.[A1_EST], A.[A1_MUN], A.[A1_INSCR] " + CRLF
	            cQuery1 += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
                cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[A1_COD] BETWEEN '"+ aCliDE +"' AND '"+ aCliATE +"'" + CRLF

                cAliasDT := MPSYSOPENQUERY(cQuery1)

                WHILE (cAliasDT)->(!EOF())
                    oSection2:INIT()
                    oSection2:PRINTLINE()
                    
                    (cAliasDT)->(DBSKIP())
                ENDDO

                oSection2:FINISH()
                (cAliasDT)->(DBCLOSEAREA())
                
            (cAliasRM)->(DBSKIP())
            oSection1:FINISH()

        ENDDO

    (cAliasRM)->(DBCLOSEAREA())

RETURN
