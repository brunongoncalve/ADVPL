#INCLUDE 'TOTVS.ch'
#INCLUDE "FWMBROWSE.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} TELA DE CADASTRO - DE PARA CFOP
TELA - DE PARA CFOP
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     18/09/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

/*
2 - visualiza
3 - inclui
4 - altera
5 - exclui
6 - outras ações
*/

USER FUNCTION xCADCFOP()

    LOCAL oBrowse := FWLOADBRW("xCADCFOP")
 
    oBrowse:ACTIVATE()

RETURN

STATIC FUNCTION BROWSEDEF()

    LOCAL oBrowse := FWMBROWSE():NEW()

    oBrowse:SETALIAS("ZZ9")
    oBrowse:SETDESCRIPTION("CADASTRO - DE PARA CFOP")
    oBrowse:ACTIVATE()

RETURN oBrowse

STATIC FUNCTION MENUDEF()

    LOCAL aMenu := {}

    ADD OPTION aMenu TITLE 'Incluir' ACTION 'VIEWDEF.xCADCFOP' OPERATION 3 ACCESS 0
    ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.xCADCFOP' OPERATION 2 ACCESS 0
    ADD OPTION aMenu TITLE "Alterar" ACTION 'U_ALERT' OPERATION 4 ACCESS 0

RETURN aMenu

STATIC FUNCTION MODELDEF()

    LOCAL oModel := NIL
    LOCAL oStructZZ9 := FWFORMSTRUCT(1, "ZZ9")

    oModel := MPFORMMODEL():NEW("xCADCFOPM")
    oModel:ADDFIELDS("FORMZZ9",,oStructZZ9)
    oModel:SETPRIMARYKEY({"ZZ9_FILIAL","ZZ9_CODREC"})
    oModel:SETDESCRIPTION("DE PARA CFOP")
    oModel:GETMODEL("FORMZZ9"):SETDESCRIPTION("CADASTRO DE PARA CFOP")

RETURN oModel

STATIC FUNCTION VIEWDEF()

    LOCAL oView := NIL
    LOCAL oModel := FWLOADMODEL("xCADCFOP")
    LOCAL oStructZZ9 := FWFORMSTRUCT(2, "ZZ9")

    oView := FWFORMVIEW():NEW()
    oView:SETMODEL(oModel)
    oView:ADDFIELD("VIEWZZ9",oStructZZ9,"FORMZZ9")
    oView:CREATEHORIZONTALBOX("TELAZZ9",100)
    oView:ENABLETITLEVIEW("VIEWZZ9","DE PARA CFOP")
    oView:SETCLOSEONOK({||.T.})
    oView:SETOWNERVIEW("VIEWZZ9","TELAZZ9")

RETURN oView

STATIC FUNCTION ALERT()

    ALERT("OIIII")

RETURN 
