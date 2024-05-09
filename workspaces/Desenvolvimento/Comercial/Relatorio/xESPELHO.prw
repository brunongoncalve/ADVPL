#INCLUDE "RPTDEF.CH"
#INCLUDE 'TOPCONN.ch'
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
    
    Local aArea := GetArea()
    Local cPasta := Directory(Alltrim("\system\tmp\arquivo")+"*.txt")

    cTextHtml := "<!DOCTYPE html>"
    
    MemoWrite(cPasta, cTextHtml)
    RestArea(aArea)

RETURN 

