#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOTVS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} RELATORIO - DESPESAS
PDF DESPESAS
@author    BRUNO
@since     28/03/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xCUSTOS()

    LOCAL lAdjustToLegacy := .F.
    LOCAL lDisableSetup   := .T.
    LOCAL cLocal          := "C:\tmp"
    LOCAL cQuery          := ""
    LOCAL oPrinter
    
    cQuery := " SELECT " + CRLF
    cQuery += " [C7_FORNECE], " + CRLF
	cQuery += " [C7_NUM], " + CRLF
    cQuery += " [Jan] AS Janeiro, " + CRLF
    cQuery += " [Feb] AS Fevereiro, " + CRLF
    cQuery += " [Mar] AS Março, " + CRLF
    cQuery += " [Apr] AS Abril, " + CRLF
    cQuery += " [May] AS Maio, " + CRLF
    cQuery += " [Jun] AS Junho, " + CRLF
    cQuery += " [Jul] AS Julho, " + CRLF
    cQuery += " [Aug] AS Agosto, " + CRLF
    cQuery += " [Sep] AS Setembro, " + CRLF
    cQuery += " [Oct] AS Outubro, " + CRLF
    cQuery += " [Nov] AS Novembro, " + CRLF
    cQuery += " [Dec] AS Dezembro " + CRLF
    cQuery += " FROM " + CRLF
    cQuery += " (SELECT " + CRLF
	cQuery += " [C7_NUM], " + CRLF
	cQuery += " [C7_FORNECE], " + CRLF
	cQuery += " FORMAT(CONVERT(DATE, [C7_DATPRF]), 'MMM') AS MES, " + CRLF
	cQuery += " [C7_TOTAL] " + CRLF
    cQuery += " FROM [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[SC7010] " + CRLF
	cQuery += " WHERE [C7_CC] = '90201012001' AND [C7_DATPRF] BETWEEN '20250101' AND '20253112' AND [C7_UM] = 'UN' AND D_E_L_E_T_ = '' " + CRLF
	cQuery += " GROUP BY " + CRLF
	cQuery += " [C7_NUM], " + CRLF
	cQuery += " [C7_FORNECE], " + CRLF
	cQuery += " [C7_DATPRF], " + CRLF
	cQuery += " [C7_TOTAL] " + CRLF
	cQuery += " ) AS A " + CRLF
    cQuery += " PIVOT " + CRLF
    cQuery += " (SUM([C7_TOTAL]) FOR MES IN ([Jan], [Feb], [Mar], [Apr], [May], [Jun], [Jul], [Aug], [Sep], [Oct], [Nov], [Dec])) AS pivot_table; " + CRLF

    oPrinter := FWMSPRINTER():NEW("CUSTOS.pdf",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,.F.)
    oFont    := TFONT():NEW("Arial",,9,.T.)

    oPrinter:STARTPAGE()
    oPrinter:SAYBITMAP(28,9,"tmp\logo_novo.png",90,28)
    oPrinter:ENDPAGE()
    
RETURN
