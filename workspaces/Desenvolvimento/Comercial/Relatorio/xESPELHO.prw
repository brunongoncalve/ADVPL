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
oPrinter:BOX(20,5,70,100,"-4")
oPrinter:SAYBITMAP(20,10,"C:\Logo\logo_novo.png",90,28)
oPrinter:BOX(20,100,70,590,"-4")
oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLU��O")

oPrinter:SETUP()

    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    EndIf

RETURN
