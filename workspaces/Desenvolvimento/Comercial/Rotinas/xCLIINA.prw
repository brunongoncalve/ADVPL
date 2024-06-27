#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} CLIENTES INATIVOS
ROTINA - CLIENTES INATIVOS
@author    BRUNO NASCIMENTO GONÇALVES
@since     20/04/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xCLIINA()

    LOCAL oReport    := NIL
    LOCAL aPergs     := {}
    LOCAL aResps     := {}

    IF CUSERNAME == "FATIMA.TOJO"
        AADD(aPergs, {1, "INATIVAR CLIENTE",STOD(""),,,,,100,.F.})
        IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T., .T.)
            IF LEN(aResps) == 1
                MSBRGETDBASE()
            ENDIF
        ENDIF
    ELSEIF CUSERNAME <> "FATIMA.TOJO"
        AADD(aPergs, {1, "REPRESENTANTE",SPACE(TAMSX3("A3_COD")[1]),,,"SA3",,100,.F.})
        IF PARAMBOX(aPergs,"Parametros do relatorio",@aResps,,,,,,,,.T., .T.)
            IF LEN(aResps) == 1
                oReport := REPORTDEF(aResps)
                oReport:PRINTDIALOG()
            ENDIF
        ENDIF
    ENDIF    

RETURN

STATIC FUNCTION REPORTDEF(aResps)

    LOCAL oReport      := NIL
    LOCAL oSection1    := NIL
    LOCAL oSection2    := NIL
    LOCAL nColSpace    := 0
    LOCAL nSize        := 25
    LOCAL lLineBreak   := .T.
    LOCAL lAutoSize    := .T.
    LOCAL cAlign       := "LEFT"
    LOCAL cHeaderAlign := "LEFT"
    LOCAL cAliasCL     := ""
    LOCAL cAliasNU     := ""
    LOCAL cNomeArq     := "CLIENTES INATIVOS"
    LOCAL cTitulo      := "CLIENTES INATIVOS"

    oReport := TREPORT():NEW(cNomeArq, cTitulo, "", {|oReport| REPORTPRINT(oReport, @cAliasCL, @cAliasNU, aResps)}, "IMPRESSÃO DE RELATORIO")

    oSection1 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection1,"A1_COD",cAliasCL,"COD.CLI",,nSize,,{|| (cAliasCL)->A1_COD},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_NOME",cAliasCL,"NOME.CLI",,nSize,,{|| (cAliasCL)->A1_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A1_VEND",cAliasCL,"COD.VEND",,nSize,,{|| (cAliasCL)->A1_VEND},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"A3_NOME",cAliasCL,"NOME.VEND",,nSize,,{|| (cAliasCL)->A3_NOME},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)
    TRCELL():NEW(oSection1,"F2_EMISSAO",cAliasCL,"ULTIMA COMPRA",,nSize,,{|| (cAliasCL)->ULTIMA_COMPRA},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

    oSection2 := TRSECTION():NEW(oReport)
    TRCELL():NEW(oSection2,"C5_NUM",cAliasNU,"ULTIMOS PEDIDOS DE VENDA",,nSize,,{|| (cAliasNU)->C5_NUM},cAlign,lLineBreak,cHeaderAlign,,nColSpace,lAutoSize)

RETURN oReport

STATIC FUNCTION REPORTPRINT(oReport, cAliasCL, cAliasNU, aResps)

    LOCAL oSection1 := oReport:SECTION(1)
    LOCAL oSection2 := oReport:SECTION(2)
    LOCAL aVend     := aResps[1]
    LOCAL cQuery    := ""
    LOCAL cQuery1   := ""

    cQuery := " SELECT A.[A1_COD], A.[A1_NOME], A.[A1_VEND], C.[A3_NOME], MAX(FORMAT(CONVERT(DATE, B.[F2_EMISSAO]), 'dd/MM/yy')) AS ULTIMA_COMPRA, A.[A1_MSBLQL] " + CRLF
    cQuery += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery += " LEFT JOIN (SELECT A.[A1_COD], B.[F2_EMISSAO], B.[F2_CLIENTE] FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SF2") + " B " + CRLF
    cQuery += " ON A.[A1_COD] = B.[F2_CLIENTE]) " + " B " + CRLF
    cQuery += " ON A.[A1_COD] = B.[F2_CLIENTE] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA3") + " C " + CRLF
    cQuery += " ON A.[A1_VEND] = C.[A3_COD] " + CRLF  
    cQuery += " WHERE A.[A1_LOJA] = '01' AND A.[A1_MSBLQL] = '1' AND A.[A1_VEND] = '"+ aVend +"' AND NOT EXISTS (SELECT 1 FROM " + RETSQLNAME("SF2") + " B "  + CRLF
    cQuery += " WHERE A.[A1_COD] = B.[F2_CLIENTE] AND B.[F2_EMISSAO] >= DATEADD(MONTH, -6, GETDATE())) AND B.[F2_EMISSAO] <> 'NULL'"  + CRLF
    cQuery += " GROUP BY B.[F2_CLIENTE], A.[A1_COD], A.[A1_NOME], A.[A1_VEND], C.[A3_NOME], A.[A1_MSBLQL] " + CRLF
    cQuery += " ORDER BY B.[F2_CLIENTE] ASC " + CRLF

    cAliasCL := MPSYSOPENQUERY(cQuery)

    WHILE (cAliasCL)->(!EOF())
        oSection1:INIT()
        oSection1:PRINTLINE()
        oSection1:SETPAGEBREAK(.T.)

            cQuery1 := " SELECT TOP 10 A.[C5_NUM] " + CRLF
            cQuery1 += " FROM " + RETSQLNAME("SC5") + " A " + CRLF
            cQuery1 += " WHERE A.[C5_CLIENTE] = '"+ (cAliasCL)->A1_COD +"'

            cAliasNU := MPSYSOPENQUERY(cQuery1)

            WHILE (cAliasNU)->(!EOF())
                oSection2:INIT()
                oSection2:PRINTLINE()

                (cAliasNU)->(DBSKIP())
            ENDDO
             
            (cAliasNU)->(DBCLOSEAREA())
            oSection2:FINISH()

        oReport:SKIPLINE(1)
        (cAliasCL)->(DBSKIP())
        oSection1:FINISH()
    ENDDO

    (cAliasCL)->(DBCLOSEAREA())

RETURN

STATIC FUNCTION MSBRGETDBASE()
 
    LOCAL aDados    := {}
    LOCAL cQuery1   := ""
    LOCAL cSituacao := ""
    LOCAL oBrowse   := NIL
 
    DEFINE DIALOG oDlg TITLE "CLIENTES" FROM 180, 180 TO 550, 700 PIXEL

        cQuery1 := " SELECT A.[A1_COD], A.[A1_NOME], A.[A1_MSBLQL], MAX(FORMAT(CONVERT(DATE, B.[F2_EMISSAO]), 'dd/MM/yy')) AS ULTIMA_COMPRA " + CRLF
        cQuery1 += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
        cQuery1 += " LEFT JOIN (SELECT A.[A1_COD], B.[F2_EMISSAO], B.[F2_CLIENTE] FROM " + RETSQLNAME("SA1") + " A " + CRLF
        cQuery1 += " LEFT JOIN " + RETSQLNAME("SF2") + " B " + CRLF
        cQuery1 += " ON A.[A1_COD] = B.[F2_CLIENTE]) " + " B " + CRLF
        cQuery1 += " ON A.[A1_COD] = B.[F2_CLIENTE] " + CRLF  
        cQuery1 += " WHERE A.[A1_LOJA] = '01' AND A.[A1_MSBLQL] = '2' AND NOT EXISTS (SELECT 1 FROM " + RETSQLNAME("SF2") + " B "  + CRLF
        cQuery1 += " WHERE A.[A1_COD] = B.[F2_CLIENTE] AND B.[F2_EMISSAO] >= DATEADD(MONTH, -6, GETDATE())) AND B.[F2_EMISSAO] <> 'NULL'"  + CRLF
        cQuery1 += " GROUP BY B.[F2_CLIENTE], A.[A1_COD], A.[A1_NOME], A.[A1_MSBLQL] " + CRLF
        cQuery1 += " ORDER BY B.[F2_CLIENTE] ASC " + CRLF

        cAliasCLI := MPSYSOPENQUERY(cQuery1)

        IF (cAliasCLI)->(!EOF())
            WHILE (cAliasCLI)->(!EOF())
                IF (cAliasCLI)->A1_MSBLQL == '2'
                    cSituacao := "ATIVO"
                ELSE
                    cSituacao := "INATIVO"
                ENDIF

                AADD(aDados,{(cAliasCLI)->A1_COD,(cAliasCLI)->A1_NOME,cSituacao,(cAliasCLI)->ULTIMA_COMPRA})
        
                (cAliasCLI)->(DBSKIP())
            ENDDO

            (cAliasCLI)->(DBCLOSEAREA())

            oBrowse := MSBRGETDBASE():NEW(0,0,260,170,,,,oDlg,,,,,,,,,,,,.F.,"",.T.,,.F.,,,)
            oBrowse:SETARRAY(aDados)

            oBrowse:ADDCOLUMN(TCCOLUMN():NEW("COD. CLI",{|| aDados[oBrowse:nAt,1]},,,,"LEFT",,.F.,.F.,,,,.F.))
            oBrowse:ADDCOLUMN(TCCOLUMN():NEW("NOME",{|| aDados[oBrowse:nAt,2]},,,,"LEFT",,.F.,.F.,,,,.F.))
            oBrowse:ADDCOLUMN(TCCOLUMN():NEW("SITUAÇÃO",{|| aDados[oBrowse:nAt,3]},,,,"LEFT",,.F.,.F.,,,,.F.))
            oBrowse:ADDCOLUMN(TCCOLUMN():NEW("ULTIMA COMPRA",{|| aDados[oBrowse:nAt,4]},,,,"LEFT",,.F.,.F.,,,,.F.))
            oBrowse:REFRESH()

            TBUTTON():NEW(172,002,"OK",oDlg,{|| oDlg:END(), MSGRUN("Inativando os clientes! Aguarde...","Inativação",{|| INACLI()})},40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
            TBUTTON():NEW(172,052,"Cancelar",oDlg,{|| oDlg:END()},40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        ELSE
            MSGINFO("NÃO EXISTE CLIENTE PARA INATIVAR !")
            oDlg:END()
        ENDIF     

    ACTIVATE DIALOG oDlg CENTERED

RETURN

STATIC FUNCTION INACLI()

    LOCAL cQuery1       := ""
    LOCAL aAuto         := {}
    LOCAL cStatus       := ""
    PRIVATE lMsHelpAuto := .T.
    PRIVATE lMsErroAuto := .F.

    cQuery1 := " SELECT A.[A1_COD], A.[A1_MSBLQL], MAX(B.[F2_EMISSAO]) AS ULTIMA_COMPRA " + CRLF
    cQuery1 += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery1 += " LEFT JOIN (SELECT A.[A1_COD], B.[F2_EMISSAO], B.[F2_CLIENTE] FROM " + RETSQLNAME("SA1") + " A " + CRLF
    cQuery1 += " LEFT JOIN " + RETSQLNAME("SF2") + " B " + CRLF
    cQuery1 += " ON A.[A1_COD] = B.[F2_CLIENTE]) " + " B " + CRLF
    cQuery1 += " ON A.[A1_COD] = B.[F2_CLIENTE] " + CRLF  
    cQuery1 += " WHERE A.[A1_LOJA] = '01' AND NOT EXISTS (SELECT 1 FROM " + RETSQLNAME("SF2") + " B "  + CRLF
    cQuery1 += " WHERE A.[A1_COD] = B.[F2_CLIENTE] AND B.[F2_EMISSAO] >= DATEADD(MONTH, -6, GETDATE())) AND B.[F2_EMISSAO] <> 'NULL'"  + CRLF
    cQuery1 += " GROUP BY B.[F2_CLIENTE], A.[A1_COD], A.[A1_MSBLQL] " + CRLF
    cQuery1 += " ORDER BY B.[F2_CLIENTE] ASC " + CRLF

    cAliasINA := MPSYSOPENQUERY(cQuery1)

    WHILE (cAliasINA)->(!EOF())
        IF (cAliasINA)->A1_MSBLQL == '2'
            cStatus := '1'
        ELSEIF (cAliasINA)->A1_MSBLQL == '1'    
            cStatus := '1'
        ENDIF
    
        AADD(aAuto,{"A1_COD",(cAliasINA)->A1_COD,NIL})
        AADD(aAuto,{"A1_MSBLQL",cStatus,NIL})

        lMsErroAuto := .F.

        BEGIN TRANSACTION
            MSEXECAUTO({|x,y| MATA030(x,y)},aAuto,4)
            IF lMsErroAuto
                MOSTRAERRO()
                DISARMTRANSACTION()
            ENDIF
        END TRANSACTION    

        aAuto := {}

        (cAliasINA)->(DBSKIP())
    ENDDO
   
    (cAliasINA)->(DBCLOSEAREA())
    MSGINFO("Processo Finalizado !")

RETURN
