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

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasRM, @cAliasDT, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"",,"REMETENTE",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_CGC",cAliasRM,"CNPJ",,nSize,,{|| (cAliasRM)->A1_CGC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_NOME",cAliasRM,"NOME",,nSize,,{|| (cAliasRM)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_END",cAliasRM,"ENDERECO",,nSize,,{|| (cAliasRM)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_EST",cAliasRM,"ESTADO",,nSize,,{|| (cAliasRM)->A1_EST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_MUN",cAliasRM,"MUNICIPIO",,nSize,,{|| (cAliasRM)->A1_MUN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_INSCR",cAliasRM,"INSCRICAO ESTADUAL",,nSize,,{|| (cAliasRM)->A1_INSCR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2,"",,"NATUREZA DA OPERAÇÃO",,nSize,,{|| "DEVOLUÇÃO"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection3 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection3,"",,"DESTINATARIO",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"CNPJ",,nSize,,{|| "59.114.777/0001-20"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"NOME",,nSize,,{|| "ALUMBRA PRODUTOS ELETRICOS ELETRON LTDA"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"ENDERECO",,nSize,,{|| "Rua Guimarães Rosa, 450 Jd. Continental"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"ESTADO",,nSize,,{|| "SP"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"MUNICIPIO",,nSize,,{|| "São Bernardo do Campo"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"CEP",,nSize,,{|| "09851-380"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"INSCRICAO ESTADUAL",,nSize,,{|| "635.023.191.116"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection4 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection4,"",,"DADOS DO PRODUDO",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"A1_CGC",cAliasDT,"CNPJ",,nSize,,{|| (cAliasDT)->A1_CGC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"A1_NOME",cAliasDT,"NOME",,nSize,,{|| (cAliasDT)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"A1_END",cAliasDT,"ENDERECO",,nSize,,{|| (cAliasDT)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"A1_EST",cAliasDT,"ESTADO",,nSize,,{|| (cAliasDT)->A1_EST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"A1_MUN",cAliasDT,"MUNICIPIO",,nSize,,{|| (cAliasDT)->A1_MUN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"A1_INSCR",cAliasDT,"INSCRICAO ESTADUAL",,nSize,,{|| (cAliasDT)->A1_INSCR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
   
RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasRM, cAliasDT,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL oSection3 := oReport:SECTION(3)
    LOCAL oSection4 := oReport:SECTION(4)
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
            oReport:SKIPLINE(10)
            oSection2:INIT()
            oSection2:PRINTLINE()
            oSection2:FINISH()
            oReport:SKIPLINE(3)
            oSection3:INIT()
            oSection3:PRINTLINE()
            oSection3:FINISH()
            oReport:SKIPLINE(3)

                cQuery1 := " SELECT A.[A1_CGC], A.[A1_NOME], A.[A1_END], A.[A1_EST], A.[A1_MUN], A.[A1_INSCR] " + CRLF
	            cQuery1 += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
                cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[A1_COD] BETWEEN '"+ aCliDE +"' AND '"+ aCliATE +"'" + CRLF

                cAliasDT := MPSYSOPENQUERY(cQuery1)

                WHILE (cAliasDT)->(!EOF())
                    oSection4:INIT()
                    oSection4:PRINTLINE()
                  
                    (cAliasDT)->(DBSKIP())
                ENDDO

                oSection4:FINISH() 
                (cAliasDT)->(DBCLOSEAREA())

            (cAliasRM)->(DBSKIP())
            oSection1:FINISH()
        ENDDO

    (cAliasRM)->(DBCLOSEAREA())

RETURN
