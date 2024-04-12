#INCLUDE "RPTDEF.CH"
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TOTVS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ESPELHO DE DEVOLUÇÃO
RELATORIO - ESPELHO DE DEVOLUÇÃO
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     15/02/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xESPELHO()

Local cFTPHost := "alumbraprodutos145046.protheus.cloudtotvs.com.br:2600" // Endereço do servidor FTP
Local cFTPUser := "ftp_CMT8F4_development" // Nome de usuário do FTP
Local cFTPPassword := "FPcR6Mbv" // Senha do FTP
Local cLocalFilePath := "C:\Users\bruno.goncalves\Desktop/teste.txt" // Caminho local do arquivo a ser enviado
Local cRemoteFilePath := "teste_bruno/teste.txt" // Caminho remoto onde o arquivo será salvo no FTP

IF !FTPFilePut(cFTPHost, cFTPUser, cFTPPassword, cLocalFilePath, cRemoteFilePath)
    Alert("Falha ao enviar o arquivo para o FTP!")
Else
    Alert("Arquivo enviado com sucesso para o FTP!")
ENDIF

RETURN
