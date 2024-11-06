#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ETIQUETA DE ENDEREÇO
RELATORIO - ETIQUETA DE ENDEREÇO
@author    BRUNO NASCIMENTO GONÇALVES
@since     05/11/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------


USER FUNCTION xETIQENDER()

    LOCAL aPergs := {}
    LOCAL aResps := {}

    AADD(aPergs,{1,"Do Almoxarifado", SPACE(TAMSX3("NNR_CODIGO")[1]),,,"NNR",,30,.F.})
    AADD(aPergs,{1,"Ate Almoxarifado", SPACE(TAMSX3("NNR_CODIGO")[1]),,,"NNR",,30,.F.})
    AADD(aPergs,{1,"Do Endereco", SPACE(TAMSX3("BE_LOCALIZ")[1]),,,"SBE",,100,.F.})
    AADD(aPergs,{1,"Ate Endereco", SPACE(TAMSX3("BE_LOCALIZ")[1]),,,"SBE",,100,.F.})

    IF PARAMBOX(aPergs, "Parametros da Etiqueta", @aResps,,,,,,,, .T., .T.)
        IMPETIQ(aResps)
    ENDIF  

RETURN

STATIC FUNCTION IMPETIQ(aResps)

	LOCAL cQuery	:= ""
	LOCAL nALXDe    := aResps[1]
    LOCAL nALXAte   := aResps[2]
    LOCAL cENDDe    := aResps[3]
    LOCAL cENDAte   := aResps[4]
    LOCAL cPorta    := "LPT1"
    LOCAL cModelo   := "ZEBRA"
    LOCAL cEtiqueta := ""

    cQuery := " SELECT " + CRLF
    cQuery += " A.[BE_LOCALIZ], " + CRLF
    cQuery += " A.[BE_DESCRIC], " + CRLF
    cQuery += " B.[DC8_DESEST] " + CRLF
    cQuery += " FROM " + RETSQLNAME("SBE") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("DC8") + " B " + CRLF
    cQuery += " ON A.[BE_ESTFIS] = B.[DC8_CODEST] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = '' AND A.[BE_LOCAL] BETWEEN '"+nALXDe+"' AND '"+nALXAte+"' AND A.[BE_LOCALIZ] BETWEEN '"+cENDDe+"' AND '"+cENDAte+"'" + CRLF

    cAlias := MPSYSOPENQUERY(cQuery)

    IF (cAlias)->(!Eof())
        WHILE (cAlias)->(!Eof())
            MSCBPRINTER(cModelo,cPorta,,10,.F.,,,,,,.F.,)
            MSCBCHKSTATUS(.F.)
            MSCBBEGIN(1,6)
            cEtiqueta := " ^XA " + CRLF
            cEtiqueta += " ^FX NUMERO DA NOTA " + CRLF
            cEtiqueta += " ^CF0,80 " + CRLF
            cEtiqueta += " ^FO100,40^FD"+ALLTRIM(FWNOACCENT((cAlias)->BE_DESCRIC))+"^FS " + CRLF
            cEtiqueta += " ^FX CODIGO DE BARRA. " + CRLF
            cEtiqueta += " ^BY2,2,170 " + CRLF
            cEtiqueta += " ^FO190,190^BC^FD"+(cAlias)->BE_LOCALIZ+"^FS " + CRLF
            cEtiqueta += " ^FO100,470^FD"+ALLTRIM(FWNOACCENT((cAlias)->DC8_DESEST))+"^FS " + CRLF
            cEtiqueta += " ^XZ " + CRLF
            MSCBWRITE(cEtiqueta)
            MSCBEND()
            MSCBCLOSEPRINTER()

            (cAlias)->(DBSKIP())
        ENDDO
        FWALERTSUCCESS("Impressão concluida com sucesso. ", "Concluída !")
    ELSE
        FWALERTWARNING("Endereço não existe para este armazén. ", "Atenção !")    
    ENDIF    

    (cAlias)->(DBCLOSEAREA())

RETURN 


