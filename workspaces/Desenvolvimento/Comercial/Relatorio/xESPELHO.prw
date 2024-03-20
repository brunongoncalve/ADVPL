#INCLUDE "RPTDEF.CH"
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

LOCAL lAdjustToLegacy := .F.
LOCAL lDisableSetup   := .T.
LOCAL cLocal          := "\spool"
LOCAL oPrinter
 
oPrinter := FWMSPRINTER():NEW("exemplo.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup,,,,,,.F.,)
oPrinter:BOX(50,10,100,300,"-4")
oPrinter:SAY(20,30,"Código de barras EAN13:")
 
oPrinter:SETUP()
    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    EndIf

RETURN
