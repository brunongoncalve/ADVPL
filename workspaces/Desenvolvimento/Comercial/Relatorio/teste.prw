#INCLUDE "RPTDEF.CH"
#INCLUDE 'TOPCONN.ch'
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

USER FUNCTION xxESPELHO()

LOCAL lAdjustToLegacy := .F.
LOCAL lDisableSetup   := .T.
LOCAL cLocal          := "\spool"
LOCAL oPrinter
LOCAL nN              := 0
LOCAL nT              :=

cQuery := " SELECT TOP 10 * " + CRLF
cQuery += " FROM " + RETSQLNAME("SA1") + " A " + CRLF
cQuery += " WHERE A.[D_E_L_E_T_] = ' '"

cQuery := CHANGEQUERY(cQuery)
cAlias := GETNEXTALIAS()
DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)
 
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
FOR nN := 1 TO LEN(cAlias)
    oPrinter:BOX(310 + ,5,320,590,"-5")
    (cAlias)->(DBSKIP())
NEXT

(cAlias)->(DBCLOSEAREA())

oPrinter:SETUP()

    IF oPrinter:nModalResult == PD_OK
        oPrinter:PREVIEW()
    EndIf

RETURN

