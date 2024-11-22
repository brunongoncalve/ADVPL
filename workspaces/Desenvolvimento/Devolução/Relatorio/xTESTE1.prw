#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 

USER FUNCTION xTESTE1()

Local lAdjustToLegacy := .F.
Local lDisableSetup := .T.
Local cLocal := "\spool"
Local oPrinter
 
oPrinter:= FWMSPrinter():New("exemplo.rel",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,)

RETURN
