#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ROTINA - VERIFICA A PORTA LPT1 
VERIFICAÇÃO DA PORTA LTP1 DA PESAGEM
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     25/03/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xVERLTP1()

    LOCAL cAcao        := "Open"
    LOCAL cArquivo     := "zd220.bat"
    LOCAL cDirTrabalho := "C:\IMP_ZD220"
    LOCAL nOpc         := 0
    LOCAL lExiste      := .F.
    
    lExiste := ExistDir(cDirTrabalho)

    IF lExiste 
        SHELLEXECUTE(cAcao,cArquivo,"",cDirTrabalho,nOpc)
        U_ALU10681()
    ELSE
        FWALERTWARNING("Impressora nao disponivél. Favor abrir uma solicitação de serviço para o departamento de T.I","ATENÇÃO !")
        RETURN .F.    
    ENDIF
    
RETURN
