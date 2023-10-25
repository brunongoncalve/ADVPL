#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELAT01
RELATORIO - PEDIDOS POR CLIENTES
@author    BRUNO NASCIMENTO GONÇALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xMATR730()

    LOCAL oReport
    Local cPerg   := "MTR730"

    PERGUNTE(cPerg,.F.)
    oReport := REPORTDEF(cPerg)
    oReport:PRINTDIALOG()

RETURN

STATIC FUNCTION REPORTDEF(cPerg)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL oSection2    := NIL
    LOCAL oSection3    := NIL
    LOCAL nColSpace    := 3
    LOCAL nSize        := 255
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "CENTER"
    LOCAL cHeaderAlign := "CENTER"
    LOCAL cAliasCL     := ""
    LOCAL cAliasPD     := ""
    LOCAL cAliasOB     := ""
    LOCAL cNomeArq     := "RELAT01"
    LOCAL cTitulo      := "PEDIDOS POR CLIENTES"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasCL, @cAliasPD, @cAliasOB)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1, "A1_COD",      cAliasCL,  "COD.CLI"            ,,nSize,,   {|| (cAliasCL)->A1_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_NREDUZ",   cAliasCL,  "NOME CLI"           ,,nSize,,   {|| (cAliasCL)->A1_NREDUZ},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_END",      cAliasCL,  "ENDEREÇO"           ,,nSize,,   {|| (cAliasCL)->A1_END},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_NUM",      cAliasCL,  "N° DO PEDIDO"       ,,nSize,,   {|| (cAliasCL)->C5_NUM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "C5_EMISSAO",  cAliasCL,  "EMISSAO"            ,,nSize,,   {|| (cAliasCL)->C5_EMISSAO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A4_NOME",     cAliasCL,  "TRANSPORTADORA"     ,,nSize,,   {|| (cAliasCL)->A4_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "E4_DESCRI",   cAliasCL,  "COND.PAG"           ,,nSize,,   {|| (cAliasCL)->E4_DESCRI},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1, "A1_TEL",      cAliasCL,  "TEL"                ,,nSize,,   {|| (cAliasCL)->A1_TEL},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2, "EMBAL",       cAliasPD, "EMBAL"         ,,nSize,,   {|| (cAliasPD)->EMBAL},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_PRODUTO",  cAliasPD, "ITEM"          ,,nSize,,   {|| (cAliasPD)->C6_PRODUTO},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_QTDVEN",   cAliasPD, "QTDE"          ,,nSize,,   {|| (cAliasPD)->C6_QTDVEN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_DESCRI",   cAliasPD, "DESCRIÇÃO"     ,,nSize,,   {|| (cAliasPD)->C6_DESCRI},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_PRCVEN",   cAliasPD, "PREÇO UNIT"    ,,nSize,,   {|| (cAliasPD)->C6_PRCVEN},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection2, "C6_VALOR",    cAliasPD, "VALOR"         ,,nSize,,   {|| (cAliasPD)->C6_VALOR},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection3 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection3, "C5_COMENT",   cAliasOB, "OBSERVAÇÃO"    ,,nSize,,   {|| (cAliasOB)->C5_COMENT},,lLineBreak,,,nColSpace,lAutoSize)

    TRFUNCTION():NEW(oSection2:CELL("C6_PRCVEN") ,,  "SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection2)
    TRFUNCTION():NEW(oSection2:CELL("C6_VALOR")  ,,  "SUM",,,"@E 9,999,999,999.99",,.T.,.F.,,oSection2)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasCL, cAliasPD, cAliasOB, cPerg)

    LOCAL oSection1   := oReport:SECTION(1)
    LOCAL oSection2   := oReport:SECTION(2)
    LOCAL oSection3   := oReport:SECTION(3)
    LOCAL cQuery      := ""
    LOCAL cQuery1     := ""
    LOCAL cQuery2     := ""
   
    cQuery := " SELECT B.[A1_COD], " + CRLF
    cQuery += " B.[A1_NREDUZ], " + CRLF
    cQuery += " B.[A1_END], " + CRLF
    cQuery += " A.[C5_VEND1], " + CRLF
    cQuery += " A.[C5_NUM], " + CRLF
    cQuery += " A.[C5_EMISSAO], " + CRLF
    cQuery += " A.[C5_TIPO], " + CRLF
    cQuery += " A.[C5_CONDPAG], " + CRLF
    cQuery += " B.[A1_TEL], " + CRLF
    cQuery += " A.[C5_CLIENTE], " + CRLF
    cQuery += " C.[A4_NOME], " + CRLF
    cQuery += " D.[E4_DESCRI] " + CRLF
	cQuery += " FROM " + RETSQLNAME("SC5") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " B " + CRLF
    cQuery += " ON A.[C5_CLIENTE] = B.[A1_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA4") + " C " + CRLF
    cQuery += " ON A.[C5_TRANSP] = C.[A4_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SE4") + " D " + CRLF
    cQuery += " ON A.[C5_CONDPAG] = D.[E4_CODIGO] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' '"

    cAliasCL := MPSYSOPENQUERY(cQuery)

        WHILE (cAliasCL)->(!EOF())
            oSection1:INIT()
            oSection1:PRINTLINE()
            oSection1:SETPAGEBREAK(.T.)
               
                cQuery1 := " SELECT ROUND(COALESCE(B.[C6_QTDVEN] / NULLIF(C.[B5_EAN142],0), 0), 0) AS [EMBAL], " + CRLF
                cQuery1 += " A.[C5_NUM], " + CRLF
                cQuery1 += " B.[C6_NUM], " + CRLF
                cQuery1 += " B.[C6_QTDVEN], " + CRLF
                cQuery1 += " B.[C6_PRODUTO], " + CRLF
                cQuery1 += " B.[C6_DESCRI], " + CRLF
                cQuery1 += " B.[C6_PRCVEN], " + CRLF
                cQuery1 += " B.[C6_VALOR] " + CRLF
	            cQuery1 += " FROM " + RETSQLNAME("SC5") + " A " + CRLF
                cQuery1 += " LEFT JOIN " + RETSQLNAME("SC6") + " B " + CRLF 
                cQuery1 += " ON A.[C5_NUM] = B.[C6_NUM] " + CRLF
                cQuery1 += " LEFT JOIN " + RETSQLNAME("SB5") + " C " + CRLF
                cQuery1 += " ON B.[C6_PRODUTO] = C.[B5_COD] " + CRLF
                cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND 'SC5.C5_XSTEX = '" + cFt +"'"
	                                                                
                cAliasPD := MPSYSOPENQUERY(cQuery1)

                    WHILE (cAliasPD)->(!EOF())
                        IF (cAliasCL)->C5_NUM == (cAliasPD)->C6_NUM
                            oSection2:INIT()
                            oSection2:PRINTLINE()
                        ENDIF
                        (cAliasPD)->(DBSKIP())
                    ENDDO

                        cQuery2 := " SELECT B.[A1_COD], " + CRLF
                        cQuery2 += " B.[A1_NREDUZ], " + CRLF
                        cQuery2 += " B.[A1_END], " + CRLF
                        cQuery2 += " A.[C5_VEND1], " + CRLF
                        cQuery2 += " A.[C5_NUM], " + CRLF
                        cQuery2 += " A.[C5_EMISSAO], " + CRLF
                        cQuery2 += " A.[C5_TIPO], " + CRLF
                        cQuery2 += " A.[C5_CONDPAG], " + CRLF
                        cQuery2 += " B.[A1_TEL], " + CRLF
                        cQuery2 += " A.[C5_COMENT], " + CRLF
                        cQuery2 += " A.[C5_CLIENTE] " + CRLF
                     	cQuery2 += " FROM " + RETSQLNAME("SC5") + " A " + CRLF
                        cQuery2 += " LEFT JOIN " + RETSQLNAME("SA1") + " B " + CRLF 
                        cQuery2 += " ON A.[C5_CLIENTE] = B.[A1_COD] " + CRLF
                        cQuery2 += " WHERE A.[D_E_L_E_T_] = ' '"
	                                                                
                        cAliasOB := MPSYSOPENQUERY(cQuery2)

                            WHILE (cAliasOB)->(!EOF())
                                IF (cAliasCL)->C5_NUM == (cAliasOB)->C5_NUM
                                    oSection3:INIT()
                                    oSection3:PRINTLINE()
                                ENDIF        
                                (cAliasOB)->(DBSKIP())
                            ENDDO

                            oSection3:FINISH()
                            (cAliasOB)->(DBCLOSEAREA()) 

                    oReport:SKIPLINE(1)
                    oSection2:FINISH()
                    (cAliasPD)->(DBCLOSEAREA())  

            (cAliasCL)->(DBSKIP())
            oSection1:FINISH()
        ENDDO

        (cAliasCL)->(DBCLOSEAREA())

RETURN 
