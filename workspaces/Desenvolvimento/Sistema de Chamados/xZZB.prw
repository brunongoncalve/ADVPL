#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "FWMBROWSE.ch"

//---------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ABERTURA DE CHAMADOS
TELA - ABERTURA DE CHAMADOS
@author    BRUNO NASCIMENTO GONÇALVES
@since     29/11/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xZZB()

    LOCAL oBrowse := FWMBROWSE():NEW()
    LOCAL cAlias  := "ZZB"
    LOCAL cTitulo := "Abertura de Chamados"

    oBrowse:SETALIAS(cAlias)
    oBrowse:SETDESCRIPTION(cTitulo)
    oBrowse:SETMENUDEF("xZZB")

    oBrowse:ADDLEGEND("ZZB_STATUS == 'AG'", "YELLOW","Aguardando Aprovação")
    oBrowse:ADDLEGEND("ZZB_STATUS == 'AP'", "GREEN","Aprovado")
    oBrowse:ADDLEGEND("ZZB_STATUS == 'RP'", "RED","Reprovado")

    oBrowse:ACTIVATE()

RETURN

STATIC FUNCTION MENUDEF()

    LOCAL aMenu := {}

    ADD OPTION aMenu TITLE "Novo Ticket" ACTION "VIEWDEF.xZZB" OPERATION 3 ACCESS 0
    ADD OPTION aMenu TITLE "Alterar"     ACTION "VIEWDEF.xZZB" OPERATION 4 ACCESS 0

RETURN aMenu

STATIC FUNCTION MODELDEF()

    LOCAL oModel   := MPFORMMODEL():NEW("xZZBM")
    LOCAL oStruZZB := FWFORMSTRUCT(1,"ZZB")

    oModel:ADDFIELDS("ZZBMASTER",,oStruZZB)
    oModel:SETPRIMARYKEY({"ZZB_FILIAL","ZZB_ID"})

    oModel:GETMODEL("ZZBMASTER"):SETDESCRIPTION("Dados da Abertura de Chamados")
    oModel:SETDESCRIPTION("Modelo de dados de Abertura de Chamados")


RETURN oModel

STATIC FUNCTION VIEWDEF()

    LOCAL oModel   := FWLOADMODEL("xZZB")
    LOCAL oStruZZB := FWFORMSTRUCT(2,"ZZB")
    LOCAL oView    := FWFORMVIEW():NEW()

    oView:SETMODEL(oModel)
    oView:ADDFIELD("VIEWZZB",oStruZZB, "ZZBMASTER")

    oView:CREATEHORIZONTALBOX("V1_ZZB",50)
    oView:SETOWNERVIEW("VIEWZZB","V1_ZZB")

RETURN oView





