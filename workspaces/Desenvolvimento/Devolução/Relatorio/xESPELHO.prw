#INCLUDE "RPTDEF.CH"
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOTVS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ESPELHO DE DEVOLU��O
RELATORIO - ESPELHO DE DEVOLU��O
@author    BRUNO NASCIMENTO GON�ALVES
@since     15/02/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xESPELHO()

    LOCAL oReport := NIL
    LOCAL aPergs  := {}
    LOCAL aResps  := {}

    AADD(aPergs,{1,"Protocolo",SPACE(TAMSX3("ZZW_NUM")[1]),,,"",,100,.F.})

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
    LOCAL oSection5    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 10
    LOCAL nSize1       := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasRM     := ""
    LOCAL cAliasPRO    := ""
    LOCAL cAliasNFS    := ""
    LOCAL cNomeArq     := "ESPELHO DA NOTA"
    LOCAL cTitulo      := "MODELO DE NOTA FISCAL DE DEVOLU��O"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasRM,@cAliasPRO,@cAliasNFS,aResps)},"IMPRESS�O DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"",,"REMETENTE",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_CGC",cAliasRM,"CNPJ",,nSize,,{||(cAliasRM)->A1_CGC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_NOME",cAliasRM,"NOME",,nSize,,{||(cAliasRM)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_END",cAliasRM,"ENDERECO",,nSize,,{||(cAliasRM)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_MUN",cAliasRM,"MUNICIPIO",,nSize,,{||(cAliasRM)->A1_MUN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_EST",cAliasRM,"ESTADO",,nSize,,{||(cAliasRM)->A1_EST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_INSCR",cAliasRM,"INSCRICAO ESTADUAL",,nSize,,{||(cAliasRM)->A1_INSCR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2,"",,"NATUREZA DE OPERA��O",,nSize,,{|| "DEVOLU��O"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection3 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection3,"",,"DESTINATARIO",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"CNPJ",,nSize,,{||"59.114.777/0001-20"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"NOME",,nSize,,{||"ALUMBRA PRODUTOS ELETRICOS ELETRON LTDA"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"ENDERECO",,nSize,,{||"Rua Guimar�es Rosa, 450 Jd. Continental"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"MUNICIPIO",,nSize,,{||"S�o Bernardo do Campo"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"ESTADO",,nSize,,{||"SP"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"CEP",,nSize,,{||"09851-380"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"INSCRICAO ESTADUAL",,nSize,,{||"635.023.191.116"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection4 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection4,"",,"PRODUTO",,nSize,,{||(cAliasPRO)->ZZY_PROD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"DESC.PRODUTO",,nSize1,,{||(cAliasPRO)->B1_DESC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"CL FISCAL",,nSize,,{||(cAliasPRO)->D2_CLASFIS},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"CFOP",,nSize,,{||(cAliasPRO)->ZA2_CFOPIM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"UM",,nSize,,{||(cAliasPRO)->D2_UM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"QTDE",,nSize,,{||(cAliasPRO)->D2_QUANT},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL UNIT",,nSize,,{||(cAliasPRO)->D2_PRUNIT},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL TOTAL",,nSize,,{||(cAliasPRO)->D2_TOTAL},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"BASE ICMS",,nSize,,{||(cAliasPRO)->D2_BASEICM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL ICMS",,nSize,,{||(cAliasPRO)->D2_VALICM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL IPI",,nSize,,{||(cAliasPRO)->D2_VALIPI},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"BASE ST",,nSize,,{||(cAliasPRO)->D2_BASETST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection5 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection5,"",,"INFORMA��ES",,nSize1,,{|| "ATEN��O: ESTE PROTOCOLO TEM VALIDADE DE 90 DIAS. AP�S ESTE PER�ODO, O MESMO SER� CANCELADO. A NF DE DEVOLU��O DEVER� SER ENVIADA PARA CONFER�NCIA DA ALUMBRA NO PRAZO DE 12 HORAS AP�S A SUA EMISS�O, UMA VEZ QUE SE FOR NECESS�RIO O CANCELAMENTO DA MESMA, O CLIENTE TER� O PRAZO DE 24HORAS. Modelo de nota fiscal de devolu��o referente a(s) NF(s):"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    
    oSection6 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection6,"",,"SERIE",,nSize,,{|| (cAliasNFS)->F2_SERIE},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"NOTA",,nSize,,{|| (cAliasNFS)->F2_DOC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"SEQUENCIA",,nSize,,{|| (cAliasNFS)->D2_ITEM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"DT DE EMISSAO" ,,nSize,,{|| (cAliasNFS)->EMISSAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"CHAVE NF-E",,nSize1,,{|| (cAliasNFS)->F2_CHVNFE},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    
    TRFUNCTION():NEW(oSection4:CELL("QTDE"),,"SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    TRFUNCTION():NEW(oSection4:CELL("VL UNIT"),,"SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    
RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasRM,cAliasPRO,cAliasNFS,aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL oSection3 := oReport:SECTION(3)
    LOCAL oSection4 := oReport:SECTION(4)
    LOCAL oSection5 := oReport:SECTION(5)
    LOCAL oSection6 := oReport:SECTION(6)
    LOCAL cQuery    := ""
    LOCAL cQuery1   := ""
    LOCAL cQuery2   := ""
    LOCAL aPro      := aResps[1]

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
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '"+ aPro +"'" + CRLF

    cAliasRM := MPSYSOPENQUERY(cQuery)
    
        WHILE (cAliasRM)->(!EOF())
            oSection1:INIT()
            oSection1:PRINTLINE()
            oSection1:SETPAGEBREAK(.T.)
            oReport:SKIPLINE(3)
            oSection2:INIT()
            oSection2:PRINTLINE()
            oSection2:FINISH()
            oReport:SKIPLINE(3)
            oSection3:INIT()
            oSection3:PRINTLINE()
            oSection3:FINISH()
            oReport:SKIPLINE(3)

            cQuery1 := " SELECT B.[ZZY_PROD], " + CRLF
	        cQuery1 += " D.[B1_DESC], " + CRLF
            cQuery1 += " C.[D2_CLASFIS], " + CRLF
	        cQuery1 += " C.[D2_UM], " + CRLF
	        cQuery1 += " C.[D2_QUANT], " + CRLF
	        cQuery1 += " C.[D2_PRUNIT], " + CRLF
	        cQuery1 += " C.[D2_TOTAL], " + CRLF
	        cQuery1 += " C.[D2_BASEICM], " + CRLF
	        cQuery1 += " C.[D2_VALICM], " + CRLF
	        cQuery1 += " C.[D2_VALIPI], " + CRLF
            cQuery1 += " C.[D2_BASETST], " + CRLF
            cQuery1 += " E.[ZA2_CFOPIM] " + CRLF
            cQuery1 += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF  
            cQuery1 += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
            cQuery1 += " ON A.[ZZW_NUM] = B.[ZZY_NUM]
            cQuery1 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
            cQuery1 += " ON B.[ZZY_NF] = C.[D2_DOC] AND B.[ZZY_SERIE] = C.[D2_SERIE] AND B.[ZZY_PROD] = C.[D2_COD] " + CRLF
            cQuery1 += " LEFT JOIN " + RETSQLNAME("SB1") + " D " + CRLF 
            cQuery1 += " ON B.[ZZY_PROD] = D.[B1_COD] " + CRLF
            cQuery1 += " LEFT JOIN " + RETSQLNAME("ZA2") + " E " + CRLF
            cQuery1 += " ON C.[D2_TES] = E.[ZA2_TESSAI] " + CRLF
            cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '"+ aPro +"'" + CRLF

            cAliasPRO := MPSYSOPENQUERY(cQuery1)

                WHILE (cAliasPRO)->(!EOF())
                    oSection4:INIT()
                    oSection4:PRINTLINE()

                    (cAliasPRO)->(DBSKIP())
                ENDDO

                cQuery2 := " SELECT D.[F2_SERIE], " + CRLF
                cQuery2 += " D.[F2_DOC], " + CRLF
                cQuery2 += " C.[D2_ITEM], " + CRLF
                cQuery2 += " FORMAT(CONVERT(DATE, D.[F2_EMISSAO]), 'dd/MM/yy') AS [EMISSAO], " + CRLF
	            cQuery2 += " D.[F2_CHVNFE] " + CRLF
                cQuery2 += " FROM " + RETSQLNAME("ZZW") + " A " + CRLF  
                cQuery2 += " LEFT JOIN " + RETSQLNAME("ZZY") + " B " + CRLF 
                cQuery2 += " ON A.[ZZW_NUM] = B.[ZZY_NUM]
                cQuery2 += " LEFT JOIN " + RETSQLNAME("SD2") + " C " + CRLF 
                cQuery2 += " ON B.[ZZY_NF] = C.[D2_DOC] AND B.[ZZY_SERIE] = C.[D2_SERIE] AND B.[ZZY_PROD] = C.[D2_COD]" + CRLF
                cQuery2 += " LEFT JOIN " + RETSQLNAME("SF2") + " D " + CRLF 
                cQuery2 += " ON B.[ZZY_NF] = D.[F2_DOC] AND B.[ZZY_SERIE] = D.[F2_SERIE] " + CRLF
                cQuery2 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[ZZW_NUM] = '"+ aPro +"'" + CRLF

                cAliasNFS := MPSYSOPENQUERY(cQuery2)
                
                oReport:SKIPLINE(5)
                oSection5:INIT()
                oSection5:PRINTLINE()
                oSection5:FINISH()

                    WHILE (cAliasNFS)->(!EOF())
                        oSection6:INIT()
                        oSection6:PRINTLINE()

                        (cAliasNFS)->(DBSKIP())
                    ENDDO

                    oSection6:FINISH()
                    oReport:SKIPLINE(5)
                    (cAliasNFS)->(DBCLOSEAREA())
        
                oSection4:FINISH()
                oReport:SKIPLINE(5)
                (cAliasPRO)->(DBCLOSEAREA())

            (cAliasRM)->(DBSKIP())
            oSection1:FINISH()
        ENDDO

    (cAliasRM)->(DBCLOSEAREA())

RETURN
