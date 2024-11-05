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

    IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
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

    cQuery := " SELECT A.[BE_LOCALIZ], A.[BE_DESCRIC] " + CRLF
    cQuery += " FROM " + RETSQLNAME("SBE") + " A " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = '' AND A.[BE_LOCAL] BETWEEN '"+nALXDe+"' AND '"+nALXAte+"' AND A.[BE_LOCALIZ] BETWEEN '"+cENDDe+"' AND '"+cENDAte+"'" + CRLF

    cAlias := MPSYSOPENQUERY(cQuery)

    WHILE (cAlias)->(!Eof())

    // VALIDAR SE EXISTE ENDEREÇO

        MSCBPRINTER(cModelo,cPorta,,10,.F.,,,,,,.F.,)
        MSCBCHKSTATUS(.F.)
        MSCBBEGIN(1,6)
        cEtiqueta := "^XA " + CRLF
        cEtiqueta += "^FX NUMERO DA NOTA " + CRLF
        cEtiqueta += "^CF0,80 " + CRLF
        cEtiqueta += "^FO20,40^FDNF: "+ ALLTRIM((cAlias)->BE_DESCRIC) +"^FS " + CRLF
        cEtiqueta += "^FX CLIENTE, FORNECEDOR E PRODUTO " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO10,220^FD CLIENTE: "+ ALLTRIM((cAlias)->BE_DESCRIC) +"^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO10,250^FD FORNECEDOR: ALUMBRA PRODUTOS ELETRICOS^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO10,280^FD PRODUTO: "+ ALLTRIM((cAlias)->BE_DESCRIC) +"^FS " + CRLF
        cEtiqueta += "^FX QUANTIDADE DE PEÇAS " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO10,370^FD QTDE: "+ ALLTRIM((cAlias)->BE_DESCRIC) +"^FS " + CRLF
        cEtiqueta += "^FX VOLUME " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO400,350^FD VOLUME:^FS " + CRLF
        cEtiqueta += "^FO450,400^FD"+ ALLTRIM((cAlias)->BE_DESCRIC) +"^FS " + CRLF
        cEtiqueta += "^FX CODIGO DE BARRA. " + CRLF
        cEtiqueta += "^BY3,1,80 " + CRLF
        cEtiqueta += "^FO250,450^BC^FD"+ ALLTRIM((cAlias)->BE_LOCALIZ) +"^FS " + CRLF
        cEtiqueta += "^XZ "
        MSCBWRITE(cEtiqueta)
        MSCBEND()
        MSCBCLOSEPRINTER()

        (cAlias)->(DBSKIP())

    ENDDO

    (cAlias)->(DBCLOSEAREA())

RETURN 
