#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOTVS.ch"
#Include "REPORT.ch"

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
    LOCAL nProtoc := ZZW->ZZW_NUM
    LOCAL cStatus := ZZW->ZZW_STSMER

    AADD(aPergs,{1,"Protocolo",nProtoc,,,"",,100,.T.})

    IF cStatus == 'APR'
        oReport := REPORTDEF(aPergs)
        oReport:PRINTDIALOG()
    ELSE 
        FWALERTWARNING("Realize a aprovação do protocolo para a emissão do espelho da nota fiscal.", "Atenção !")
    ENDIF
    
RETURN

STATIC FUNCTION REPORTDEF(aPergs)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL oSection2    := NIL
    LOCAL oSection3    := NIL
    LOCAL oSection4    := NIL
    LOCAL oSection5    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 25
    LOCAL nSize1       := 90
    LOCAL nSize2       := 60
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasRM     := ""
    LOCAL cAliasPRO    := ""
    LOCAL cAliasNFS    := ""
    LOCAL cNomeArq     := "ESPELHO DA NOTA"
    LOCAL cTitulo      := "MODELO DE NOTA FISCAL DE DEVOLUÇÃO"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasRM,@cAliasPRO,@cAliasNFS,aPergs)},"IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"",,"REMETENTE",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_CGC",cAliasRM,"CNPJ",,nSize,,{||(cAliasRM)->A1_CGC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_NOME",cAliasRM,"NOME",,nSize,,{||(cAliasRM)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_END",cAliasRM,"ENDERECO",,nSize,,{||(cAliasRM)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_MUN",cAliasRM,"MUNICIPIO",,nSize,,{||(cAliasRM)->A1_MUN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_EST",cAliasRM,"ESTADO",,nSize,,{||(cAliasRM)->A1_EST},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_INSCR",cAliasRM,"INSCRICAO ESTADUAL",,nSize,,{||(cAliasRM)->A1_INSCR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2,"",,"NATUREZA DE OPERAÇÃO",,nSize,,{|| "DEVOLUÇÃO"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection3 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection3,"",,"DESTINATARIO",,nSize,,{||},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"CNPJ",,nSize,,{||"59.114.777/0001-20"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"NOME",,nSize,,{||"ALUMBRA PRODUTOS ELETRICOS ELETRON LTDA"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"ENDERECO",,nSize,,{||"Rua Guimarães Rosa, 450 Jd. Continental"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"MUNICIPIO",,nSize,,{||"São Bernardo do Campo"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"ESTADO",,nSize,,{||"SP"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"CEP",,nSize,,{||"09851-380"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection3,"",,"INSCRICAO ESTADUAL",,nSize,,{||"635.023.191.116"},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection4 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection4,"",,"PRODUTO",,nSize,,{||(cAliasPRO)->ZZY_PROD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"DESC.PRODUTO",,nSize1,,{||(cAliasPRO)->B1_DESC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"CL FISCAL",,nSize,,{||(cAliasPRO)->B1_POSIPI},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"CFOP",,nSize,,{||(cAliasPRO)->ZA2_CFOPIM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"UM",,nSize,,{||(cAliasPRO)->D2_UM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"QTDE",,nSize,,{||(cAliasPRO)->ZZY_QTD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL UNIT",,nSize,,{||(cAliasPRO)->D2_PRCVEN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL TOTAL",,nSize,,{||(cAliasPRO)->D2_TOTAL},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"B.ICMS",,nSize,,{||(cAliasPRO)->D2_BASEICM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL ICMS",,nSize,,{||(cAliasPRO)->D2_VALICM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL IPI",,nSize,,{||(cAliasPRO)->D2_VALIPI},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"% ICMS",,nSize,,{||(cAliasPRO)->D2_PICM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"% IPI",,nSize,,{||(cAliasPRO)->D2_IPI},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"B.ST",,nSize,,{||(cAliasPRO)->D2_BRICMS},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"VL ST",,nSize,,{||(cAliasPRO)->D2_ICMSRET},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"MVA",,nSize,,{||(cAliasPRO)->D2_MARGEM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection4,"",,"TL NF",,nSize,,{||(cAliasPRO)->TOTAL_DA_NOTA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection5 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection5,"",,"INFORMAÇÕES ADICIONAIS",,nSize2,,{||"ATENÇÃO: ESTE PROTOCOLO TEM VALIDADE DE 90 DIAS. APÓS ESTE PERÍODO, O MESMO SERÁ CANCELADO. A NF DE DEVOLUÇÃO DEVERÁ SER ENVIADA PARA CONFERÊNCIA DA ALUMBRA NO PRAZO DE 12 HORAS APÓS A SUA EMISSÃO, UMA VEZ QUE SE FOR NECESSÁRIO O CANCELAMENTO DA MESMA, O CLIENTE TERÁ O PRAZO DE 24HORAS. Modelo de nota fiscal de devolução referente a(s) NF(s): PROTOCOLO: "+aPergs[1][3]+""},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    
    oSection6 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection6,"",,"SERIE",,nSize,,{|| (cAliasNFS)->F2_SERIE},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"NOTA",,nSize,,{|| (cAliasNFS)->F2_DOC},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"SEQUENCIA",,nSize,,{|| (cAliasNFS)->D2_ITEM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"DATA DE EMISSAO" ,,nSize,,{|| (cAliasNFS)->EMISSAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection6,"",,"CHAVE NF-E",,nSize1,,{|| (cAliasNFS)->F2_CHVNFE},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    
    TRFUNCTION():NEW(oSection4:CELL("B.ICMS"),,"SUM",,"BASE CÁLCULO ICMS","@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    TRFUNCTION():NEW(oSection4:CELL("VL ICMS"),,"SUM",,"TOTAL ICMS","@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    TRFUNCTION():NEW(oSection4:CELL("B.ST"),,"SUM",,"BASE CÁLCULO ICMS ST","@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    TRFUNCTION():NEW(oSection4:CELL("VL ST"),,"SUM",,"TOTAL ICMS ST","@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    TRFUNCTION():NEW(oSection4:CELL("VL TOTAL"),,"SUM",,"TOTAL DOS PRODUTOS","@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    TRFUNCTION():NEW(oSection4:CELL("VL IPI"),,"SUM",,"TOTAL IPI","@E 9,999,999,999.99",,.T.,.F.,,oSection4)
    TRFUNCTION():NEW(oSection4:CELL("TL NF"),,"SUM",,"TOTAL DA NOTA","@E 9,999,999,999.99",,.T.,.F.,,oSection4)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport,cAliasRM,cAliasPRO,cAliasNFS,aPergs)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL oSection3 := oReport:SECTION(3)
    LOCAL oSection4 := oReport:SECTION(4)
    LOCAL oSection5 := oReport:SECTION(5)
    LOCAL oSection6 := oReport:SECTION(6)
    LOCAL cQuery    := ""
    LOCAL cQuery1   := ""
    LOCAL cQuery2   := ""
    LOCAL aPro      := aPergs[1][3]

    cQuery := " SELECT DISTINCT " + CRLF
    cQuery += " C.[A1_CGC], " + CRLF
	cQuery += " C.[A1_NOME], " + CRLF
	cQuery += " C.[A1_END], " + CRLF
	cQuery += " C.[A1_EST], " + CRLF
	cQuery += " C.[A1_MUN], " + CRLF
	cQuery += " C.[A1_INSCR], " + CRLF
    cQuery += " A.[ZZW_NUM], " + CRLF
    cQuery += " B.[ZZY_NF] " + CRLF
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
            cQuery1 += " A.[ZZW_NUM], " + CRLF
            cQuery1 += " B.[ZZY_NUM], " + CRLF
            cQuery1 += " B.[ZZY_NF], " + CRLF
            cQuery1 += " D.[B1_DESC], " + CRLF
            cQuery1 += " D.[B1_POSIPI], " + CRLF
	        cQuery1 += " E.[ZA2_CFOPIM], " + CRLF
            cQuery1 += " C.[D2_UM], " + CRLF
            cQuery1 += " B.[ZZY_QTD], " + CRLF
            cQuery1 += " C.[D2_PRCVEN], " + CRLF
            cQuery1 += " C.[D2_PRCVEN] * B.[ZZY_QTD] AS [D2_TOTAL], " + CRLF
            cQuery1 += " C.[D2_BASEICM] * B.[ZZY_QTD] AS [D2_BASEICM], " + CRLF
            cQuery1 += " C.[D2_VALICM], " + CRLF
            cQuery1 += " C.[D2_VALIPI], " + CRLF
            cQuery1 += " C.[D2_PICM], " + CRLF
	        cQuery1 += " C.[D2_IPI], " + CRLF
	        cQuery1 += " CASE " + CRLF
	        cQuery1 += " WHEN A.[ZZW_ST] = '2' THEN '0' " + CRLF
		    cQuery1 += " ELSE C.[D2_BRICMS] " + CRLF
	        cQuery1 += " END AS [D2_BRICMS], " + CRLF
	        cQuery1 += " C.[D2_ICMSRET], " + CRLF
	        cQuery1 += " C.[D2_MARGEM], " + CRLF
            cQuery1 += " C.[D2_PRCVEN] * B.[ZZY_QTD] + C.[D2_VALIPI] AS [TOTAL_DA_NOTA] " + CRLF
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
                    IF (cAliasRM)->ZZY_NF == (cAliasPRO)->ZZY_NF
                        oSection4:INIT()
                        oSection4:PRINTLINE()
                    ENDIF
                    (cAliasPRO)->(DBSKIP())
                ENDDO

                cQuery2 := " SELECT D.[F2_SERIE], " + CRLF
                cQuery2 += " D.[F2_DOC], " + CRLF
                cQuery2 += " C.[D2_ITEM], " + CRLF
                cQuery2 += " FORMAT(CONVERT(DATE, D.[F2_EMISSAO]), 'dd/MM/yy') AS [EMISSAO], " + CRLF
	            cQuery2 += " D.[F2_CHVNFE], " + CRLF
                cQuery2 += " A.[ZZW_NUM], " + CRLF
                cQuery2 += " B.[ZZY_NUM], " + CRLF
                cQuery2 += " B.[ZZY_NF] " + CRLF
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
                        IF (cAliasRM)->ZZY_NF == (cAliasNFS)->ZZY_NF
                            oSection6:INIT()
                            oSection6:PRINTLINE()
                        ENDIF
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
