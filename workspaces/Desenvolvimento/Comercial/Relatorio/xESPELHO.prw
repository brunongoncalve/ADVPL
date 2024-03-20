#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ESPELHO DE DEVOLU��O
RELATORIO - ESPELHO DE DEVOLU��O
@author    BRUNO NASCIMENTO GON�ALVES
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
oPrinter:SAY(20,30,"C�digo de barras EAN13:")
 
oPrinter:SETUP()
    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    EndIf

RETURN
