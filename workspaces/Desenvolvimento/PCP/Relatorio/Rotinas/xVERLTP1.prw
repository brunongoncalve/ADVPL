#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ROTINA - VERIFICA A PORTA LPT1 
VERIFICA��O DA PORTA LTP1 DA PESAGEM
@author    BRUNO NASCIMENTO GON�ALVES
@since     25/03/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xVERLTP1()

    LOCAL cAcao        := "Open"
    LOCAL cArquivo     := "zd220.bat"
    LOCAL cDirTrabalho := "C:\IMP_ZD220"
    LOCAL nOpc         := 0

    SHELLEXECUTE(cAcao,cArquivo,"",cDirTrabalho,nOpc)

RETURN
