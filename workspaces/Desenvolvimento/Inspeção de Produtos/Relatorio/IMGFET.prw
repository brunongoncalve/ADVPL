#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO FET DE PRODUTO
RELATORIO - EFAZ SALDO A CLASSIFICAR
@author    FET DE PRODUTO
@since     02/07/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION IMGFET()

    LOCAL aPergs := {}
    LOCAL aResps := {}

    AADD(aPergs, {1, "Produto De", SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100, .F.})
    AADD(aPergs, {1, "Produto Ate", SPACE(TAMSX3("B1_COD")[1]),,,"SB1",,100, .F.})

    IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
        oReport := REPORTDEF(aResps)
        oReport:PRINTDIALOG()
    ENDIF    

RETURN

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 25
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasPro    := ""
    LOCAL cNomeArq     := "PEDIDO POR CLIENTES"
    LOCAL cTitulo      := "PEDIDO POR CLIENTES"

    oReport := TREPORT():NEW(cNomeArq,cTitulo,"",{|oReport| REPORTPRINT(oReport,@cAliasPro,aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"FOTO",cAliasPro,"COD.CLI",,nSize,,{|| Decode64((cAliasPro)->FOTO)},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasPro, aResps)

    LOCAL oSection1  := oReport:SECTION(1)
    LOCAL cQuery     := ""
    LOCAL aProdutDe  := aResps[1]
    LOCAL aProdutAte := aResps[2]

    cQuery := " SELECT TOP 1 MAX(A.[QE6_DTINI]) AS DATA_FINAL, " + CRLF
    cQuery += " A.[QE6_DTDES] AS DATA_INICIO, " + CRLF
    cQuery += " A.[QE6_DTDES] AS DATA_INICIO, " + CRLF
    cQuery += " C.[MEMO] AS FOTO" + CRLF
    cQuery += " FROM " + RETSQLNAME("QE6") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("QE7") + " B " + CRLF
    cQuery += " ON A.[QE6_PRODUT] = B.[QE7_PRODUT] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("PROTHEUS_REPOSIT") + " C " + CRLF
    cQuery += " ON A.[QE6_PRODUT] = C.[BMPNAME] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[QE6_PRODUT] BETWEEN '"+ aProdutDe +"' AND '"+ aProdutAte +"' " + CRLF
    cQuery += " GROUP BY A.[QE6_DTINI], " + CRLF
    cQuery += " A.[QE6_DTDES], " + CRLF
    cQuery += " C.[MEMO] " + CRLF
    cQuery += " ORDER BY A.[QE6_DTINI] DESC " + CRLF

    cAliasPro := MPSYSOPENQUERY(cQuery)

    WHILE (cAliasPro)->(!EOF())
        Section1:INIT()
        oSection1:PRINTLINE()
        oSection1:SETPAGEBREAK(.T.)

        oReport:SAYBITMAP(50,1700,(cAliasPro)->FOTO,150,150)

        (cAliasPro)->(DBSKIP())
        oSection1:FINISH()
    ENDDO

    (cAliasPro)->(DBCLOSEAREA())

RETURN     
