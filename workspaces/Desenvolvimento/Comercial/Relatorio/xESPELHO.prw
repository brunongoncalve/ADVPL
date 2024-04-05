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

Local cFTPHost := "ftp.example.com" // Endere�o do servidor FTP
Local cFTPUser := "seu_usuario_ftp" // Nome de usu�rio do FTP
Local cFTPPassword := "sua_senha_ftp" // Senha do FTP
Local cLocalFilePath := "caminho_do_arquivo_no_servidor/local.txt" // Caminho local do arquivo a ser enviado
Local cRemoteFilePath := "caminho_no_ftp/remoto.txt" // Caminho remoto onde o arquivo ser� salvo no FTP

IF !FTPFilePut(cFTPHost, cFTPUser, cFTPPassword, cLocalFilePath, cRemoteFilePath)
    Alert("Falha ao enviar o arquivo para o FTP!")
Else
    Alert("Arquivo enviado com sucesso para o FTP!")
ENDIF

RETURN
