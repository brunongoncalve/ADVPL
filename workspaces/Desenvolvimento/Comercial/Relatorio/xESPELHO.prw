#INCLUDE "RPTDEF.CH"
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TOTVS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ESPELHO DE DEVOLU��O
RELATORIO - ESPELHO DE DEVOLU��O
@author    BRUNO NASCIMENTO GON�ALVES
@since     15/02/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xESPELHO()

bOk := CpyS2T( "\spool\pedido por clientes.prt", "C:\Users\bruno.goncalves\Desktop", .F. )

RETURN bOk
