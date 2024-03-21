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
oPrinter:BOX(20,5,70,100,"-4")
oPrinter:SAYBITMAP(20,10,"C:\Logo\logo_novo.png",90,28)
oPrinter:BOX(20,100,70,590,"-4")
oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLUÇÃO")

oPrinter:SETUP()

    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    EndIf

RETURN
