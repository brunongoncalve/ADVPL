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

    LOCAL aPergs := {}
    LOCAL aResps := {}

    AADD(aPergs, {1, "NUMERO DA NOTA FISCAL", SPACE(TAMSX3("A1_COD")[1]),,,"SA1",,100, .F.})

        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            IMPESPE(aResps)
        ENDIF    

RETURN

STATIC FUNCTION IMPESPE(aResps)

LOCAL lAdjustToLegacy := .F.
LOCAL lDisableSetup   := .T.
LOCAL cLocal          := "\spool"
LOCAL oPrinter
 
oPrinter := FWMSPRINTER():NEW("exemplo.rel",IMP_PDF,lAdjustToLegacy,cLocal,lDisableSetup,,,,,,.F.,)
oPrinter:BOX(20,5,70,100,"-5")
oPrinter:SAYBITMAP(20,10,"C:\Logo\logo_novo.png",90,28)
oPrinter:BOX(20,100,70,500,"-5")
oPrinter:SAY(50,200,"MODELO DE NOTA FISCAL DE DEVOLUÇÃO")
oPrinter:BOX(20,500,70,590,"-5")
oPrinter:SAY(35,505,"N DA DEVOLUÇÃO")
oPrinter:SAY(50,505,"8")
oPrinter:SAY(65,505,"28/03/2024")
oPrinter:SAY(90,10,"1 - Remetente")
oPrinter:BOX(150,5,100,590,"-5")
oPrinter:SAY(170,10,"2 - Natureza de Operação")
oPrinter:BOX(180,5,200,590,"-5")
oPrinter:SAY(193,10,"Devolução")
oPrinter:SAY(220,10,"3 - Destinatário")
oPrinter:BOX(230,5,280,590,"-5")
oPrinter:SAY(300,10,"4 - Dados do Produto")
oPrinter:BOX(310,5,320,590,"-5")
oPrinter:SAY(319,10,"PROD")
oPrinter:SAY(319,45,"DESCRIÇÃO DO PRODUTO")
oPrinter:SAY(319,95,"CL FISCAL")

oPrinter:SETUP()

    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    EndIf

RETURN

