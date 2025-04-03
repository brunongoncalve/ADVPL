#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PONTO DE ENTRADA / ENVIO DE EMAIL DE MATERIAL NÃO CONFORME
@author    BRUNO NASCIMENTO GONÇALVES
@since     28/02/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION WMS225VA()
    
    LOCAL oModel        := ParamIxb[1]
    LOCAL oModelSel     := oModel:GETMODEL("SELECAO")
    LOCAL oModelMaster  := oModel:GETMODEL("DCFMASTER")
    LOCAL nI            := 0
    LOCAL nQuant        := 0
    LOCAL cCodpro       := ""
    LOCAL cDoc          := ""
    LOCAL cEnd          := ""
    LOCAL cLocdes       := ""
    PRIVATE cServEmail  := GETMV("AL_SERVEMA")
    PRIVATE cLoginEmail := GETMV("AL_LOGINEM")
    PRIVATE cPassEmail  := GETMV("AL_PASSEMA")
    PRIVATE cTo         := GETMV("AL_EMATNC")
    
    FOR nI := 1 TO oModelSel:LENGTH()
        IF !oModelSel:ISDELETED(nI) .AND. oModelSel:GETVALUE("LOCDES",nI) == "CFQ"
            cLocdes := ALLTRIM(oModelSel:GETVALUE("LOCDES",nI))
            cCodpro := ALLTRIM(oModelSel:GETVALUE("CODPRO",nI))
            cDoc    := ALLTRIM(oModelMaster:GETVALUE("DCF_DOCTO",nI))
            cEnd    := ALLTRIM(oModelSel:GETVALUE("ENDDES",nI))
            nQuant  += oModelSel:GETVALUE("QUANT",nI)
        ENDIF
    NEXT nI
    
    IF cLocdes == "CFQ"
        cAssunto := "ALUMBRA | CONTROLE DE MATERIAL NC - CODIGO: "+cCodpro+""
        cCorpo   := ""
        cCorpo   += " <html> " + CRLF
        cCorpo   += " <head> " + CRLF
        cCorpo   += " <title> CONTROLE DE MATERIAL NC </title> " + CRLF
        cCorpo   += " </head> " + CRLF
        cCorpo   += " <body> " + CRLF
        cCorpo   += " <left> Prezados,</left> " + CRLF
        cCorpo   += " <br>" + CRLF
        cCorpo   += " <left> Transferência de Material para o depósito CFQ: </left> " + CRLF
        cCorpo   += " <br> " + CRLF
        cCorpo   += " <left> Responsavel pela transferência: "+ALLTRIM(CUSERNAME)+" </left> " + CRLF
        cCorpo   += " <br> " + CRLF
        cCorpo   += " <left> Documento: "+cDoc+" </left> " + CRLF
        cCorpo   += " <br> " + CRLF
        cCorpo   += " <left> Item: "+cCodpro+" </left> " + CRLF
        cCorpo   += " <br> " + CRLF
        cCorpo   += " <left> Endereço Destino: "+cEnd+" </left> " + CRLF
        cCorpo   += " <br> " + CRLF
        cCorpo   += " <left> Quantidade: "+TRANSFORM(nQuant,"@E 999,999,999.99")+" </left> " + CRLF
        cCorpo   += " </body> " + CRLF
        cCorpo   += " </html> " + CRLF

        oMailServ := TMAILMANAGER():NEW()
        oMailServ:SETUSETLS(.T.)
        oMailServ:INIT("",cServEmail,cLoginEmail,cPassEmail,0,587)
        oMailServ:SETSMTPTIMEOUT(60)
    
        IF oMailServ:SMTPCONNECT() != 0
            FWALERTERROR("Erro ao conectar ao servidor SMTP","ERRO !")
            RETURN .F.  
        ENDIF

        IF oMailServ:SMTPAUTH(cLoginEmail,cPassEmail) != 0
            FWALERTERROR("Erro na autenticação SMTP","ERRO !")
            RETURN .F.
        ENDIF
     
        oMessage := TMAILMESSAGE():NEW()
        oMessage:CLEAR()
        oMessage:cDate := CVALTOCHAR(DATE())
	    oMessage:cFrom := cLoginEmail
        IF cEnd <> "CQNC"
            oMessage:cTo := ALLTRIM(cTo)
        ELSE
            oMessage:cTo := "joaquim@alumbra.com.br"
        ENDIF
        IF cEnd <> "CQNC"
            oMessage:cSubject := ALLTRIM(cAssunto)
        ELSE
            oMessage:cSubject := "ALUMBRA | CONTROLE DE MATERIAL NC (CQNC) - CODIGO: "+cCodpro+""
        ENDIF
	    oMessage:cBody := ALLTRIM(cCorpo)

        IF oMessage:SEND(oMailServ) != 0
            FWALERTERROR("Erro ao enviar o e-mail","ERRO !")
            RETURN .F.
        ELSE 
            oMailServ:SMTPDISCONNECT()
        ENDIF
    ENDIF    

RETURN


