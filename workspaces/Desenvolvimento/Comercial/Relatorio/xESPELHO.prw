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

Local cFTPHost := "alumbraprodutos145046.protheus.cloudtotvs.com.br:2600" // Endere�o do servidor FTP
Local cFTPUser := "ftp_CMT8F4_development" // Nome de usu�rio do FTP
Local cFTPPassword := "FPcR6Mbv" // Senha do FTP
Local cLocalFilePath := "C:\Users\bruno.goncalves\Desktop/teste.txt" // Caminho local do arquivo a ser enviado
Local cRemoteFilePath := "teste_bruno/teste.txt" // Caminho remoto onde o arquivo ser� salvo no FTP

IF !FTPFilePut(cFTPHost, cFTPUser, cFTPPassword, cLocalFilePath, cRemoteFilePath)
    Alert("Falha ao enviar o arquivo para o FTP!")
Else
    Alert("Arquivo enviado com sucesso para o FTP!")
ENDIF

RETURN
