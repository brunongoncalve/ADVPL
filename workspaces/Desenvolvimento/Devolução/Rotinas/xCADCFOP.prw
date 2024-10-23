#INCLUDE "TOTVS.ch"
#INCLUDE "FWMBROWSE.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} TELA DE CADASTRO - DE PARA CFOP
TELA - DE PARA CFOP
@author    BRUNO NASCIMENTO GON�ALVES
@since     18/09/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xCADCFOP()

    LOCAL oBrowse := FWMBROWSE():NEW()
    
    oBrowse:SETALIAS("ZA2")
    oBrowse:SETDESCRIPTION("De / Para - CFOP")
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
    LOCAL oStructZA2 := FWFORMSTRUCT(1, "ZA2")

    oModel := MPFORMMODEL():NEW("xCADCFOPM")
    oModel:ADDFIELDS("FORMZA2",,oStructZA2)
    oModel:SETPRIMARYKEY({"ZA2_FILIAL","ZA2_COD"})
    oModel:SETDESCRIPTION("DE PARA CFOP")
    oModel:GETMODEL("FORMZA2"):SETDESCRIPTION("Cadastro - De / Para - CFOP")

RETURN oModel

STATIC FUNCTION VIEWDEF()

    LOCAL oView := NIL
    LOCAL oModel := FWLOADMODEL("xCADCFOP")
    LOCAL oStructZA2 := FWFORMSTRUCT(2,"ZA2")

    oView := FWFORMVIEW():NEW()
    oView:SETMODEL(oModel)
    oView:ADDFIELD("VIEWZA2",oStructZA2,"FORMZA2")
    oView:CREATEHORIZONTALBOX("TELAZA2",100)
    oView:ENABLETITLEVIEW("VIEWZA2","DE PARA CFOP")
    oView:SETCLOSEONOK({||.T.})
    oView:SETOWNERVIEW("VIEWZA2","TELAZA2")

RETURN oView
