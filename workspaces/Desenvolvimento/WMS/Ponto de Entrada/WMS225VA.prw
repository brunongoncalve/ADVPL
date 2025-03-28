#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'
#INCLUDE "FWPRINTSETUP.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} PONTO DE ENTRADA / ENVIO DE EMAIL DE MATERIAL N�O CONFORME
@author    BRUNO NASCIMENTO GON�ALVES
@since     28/02/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION WMS225VA()
    
    LOCAL oModel        := ParamIxb[1]
    LOCAL oModelSel     := oModel:GETMODEL("SELECAO")
    LOCAL oModelMaster  := oModel:GETMODEL("DCFMASTER")
    LOCAL nI            := 0
    PRIVATE cServEmail  := GETMV("AL_SERVEMA")
    PRIVATE cLoginEmail := GETMV("AL_LOGINEM")
    PRIVATE cPassEmail  := GETMV("AL_PASSEMA")
    PRIVATE cTo         := GETMV("AL_EMATNC")
    
    FOR nI := 1 TO oModelSel:LENGTH()
        IF !oModelSel:ISDELETED(nI)
            IF oModelSel:GETVALUE("LOCDES",nI) == "CFQ"
                cAssunto := "ALUMBRA | CONTROLE DE MATERIAL NC - CODIGO: "+ALLTRIM(oModelSel:GETVALUE("CODPRO",nI))+""
                cCorpo   := ""
                cCorpo   += " <html> " + CRLF
                cCorpo   += " <head> " + CRLF
                cCorpo   += " <title> CONTROLE DE MATERIAL NC </title> " + CRLF
                cCorpo   += " </head> " + CRLF
                cCorpo   += " <body> " + CRLF
                cCorpo   += " <left> Prezados,</left> " + CRLF
                cCorpo   += " <br>" + CRLF
                cCorpo   += " <left> Transfer�ncia de Material para o dep�sito CFQ: </left> " + CRLF
                cCorpo   += " <br>" + CRLF
                cCorpo   += " <left> Responsavel pela transfer�ncia: "+ALLTRIM(CUSERNAME)+" </left> " + CRLF
                cCorpo   += " <br>" + CRLF
                cCorpo   += " <left> Documento: "+ALLTRIM(oModelMaster:GETVALUE("DCF_DOCTO",nI))+" </left> " + CRLF
                cCorpo   += " <br> " + CRLF
                cCorpo   += " <left> Item: "+ALLTRIM(oModelSel:GETVALUE("CODPRO",nI))+" </left> " + CRLF
                cCorpo   += " <br>" + CRLF
                cCorpo   += " <left> Endere�o Destino: "+ALLTRIM(oModelSel:GETVALUE("ENDDES",nI))+" </left> " + CRLF
                cCorpo   += " <br>" + CRLF
                cCorpo   += " <left> Quantidade: "+TRANSFORM(oModelSel:GETVALUE("QUANT",nI),"@E 999,999,999.99")+" </left> " + CRLF
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
                    FWALERTERROR("Erro na autentica��o SMTP","ERRO !")
                    RETURN .F.
                ENDIF
     
                oMessage := TMAILMESSAGE():NEW()
                oMessage:CLEAR()
                oMessage:cDate    := CVALTOCHAR(DATE())
	            oMessage:cFrom    := cLoginEmail
                IF oModelSel:GETVALUE("ENDDES",nI) <> "CQNC"
                    oMessage:cTo := ALLTRIM(cTo)
                ELSE
                    oMessage:cTo := "joaquim@alumbra.com.br"
                ENDIF
                IF oModelSel:GETVALUE("ENDDES",nI) <> "CQNC"
                    oMessage:cSubject := ALLTRIM(cAssunto)
                ELSE
                    oMessage:cSubject := "ALUMBRA | CONTROLE DE MATERIAL NC (CQNC) - CODIGO: "+ALLTRIM(oModelSel:GETVALUE("CODPRO",nI))+""
                ENDIF
	            oMessage:cBody 	  := ALLTRIM(cCorpo)

                IF oMessage:SEND(oMailServ) != 0
                    FWALERTERROR("Erro ao enviar o e-mail","ERRO !")
                    RETURN .F.
                ELSE 
                    oMailServ:SMTPDISCONNECT()
                ENDIF

                EXIT
            ENDIF
        ENDIF
    NEXT nI

RETURN

