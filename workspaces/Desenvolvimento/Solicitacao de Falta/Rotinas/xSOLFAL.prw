#INCLUDE 'PROTHEUS.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} TELA / SOLICITAÇÃO DE FALTAS
@author    BRUNO NASCIMENTO GONÇALVES
@since     04/04/2025
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xSOLFAL()

    LOCAL oBrowse := FWMBROWSE():NEW()
    
    oBrowse:SETALIAS("ZA6")
    oBrowse:SETDESCRIPTION("Solicitação de Faltas")
    oBrowse:ACTIVATE()

RETURN

STATIC FUNCTION MENUDEF()

    LOCAL aMenu := {}

    ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.xCFOP' OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.xCFOP' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.xCFOP' OPERATION MODEL_OPERATION_VIEW   ACCESS 0
    ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.xCFOP' OPERATION MODEL_OPERATION_DELETE ACCESS 0

RETURN aMenu

STATIC FUNCTION MODELDEF()

    LOCAL oModel := NIL
    LOCAL oStructZA6 := FWFORMSTRUCT(1,"ZA6")

    oModel := MPFORMMODEL():NEW("xSOLFALM")
    oModel:ADDFIELDS("FORMZA6",,oStructZA6)
    oModel:SETPRIMARYKEY({"ZA6_FILIAL","ZA6_NUM"})
    oModel:SETDESCRIPTION("Solicitação de Faltas")
    oModel:GETMODEL("FORMZA6"):SETDESCRIPTION("Solicitação de Faltas")

RETURN oModel

STATIC FUNCTION VIEWDEF()

    LOCAL oView := NIL
    LOCAL oModel := FWLOADMODEL("xSOLFAL")
    LOCAL oStructZA6 := FWFORMSTRUCT(2,"ZA6")

    oView := FWFORMVIEW():NEW()
    oView:SETMODEL(oModel)
    oView:ADDFIELD("VIEWZA6",oStructZA6,"FORMZA6")
    oView:CREATEHORIZONTALBOX("TELAZA6",100)
    oView:ENABLETITLEVIEW("VIEWZA6","Solicitação de Faltas")
    oView:SETCLOSEONOK({||.T.})
    oView:SETOWNERVIEW("VIEWZA6","TELAZA6")

RETURN oView
