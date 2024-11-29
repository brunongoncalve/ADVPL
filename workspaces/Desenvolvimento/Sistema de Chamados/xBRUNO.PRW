//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "TESTE"
Static cTabPai := "SC5"
Static cTabFilho := "SC6"

/*/{Protheus.doc} User Function XBRUNO
TESTE
@author Bruno Nascimento Goncalves
@since 29/11/2024
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function XBRUNO()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao XBRUNO
@author Bruno Nascimento Goncalves
@since 29/11/2024
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "TESTE" ACTION "XTESTE1" OPERATION 1 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao XBRUNO
@author Bruno Nascimento Goncalves
@since 29/11/2024
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ModelDef()
	Local oStruPai := FWFormStruct(1, cTabPai)
	Local oStruFilho := FWFormStruct(1, cTabFilho)
	Local aRelation := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("XBRUNOM", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("SC5MASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("SC6DETAIL","SC5MASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	oModel:GetModel("SC5MASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("SC6DETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"C6_FILIAL", "FWxFilial('SC6')"} )
	aAdd(aRelation, {"C6_NUM", "C5_NUM"})
	oModel:SetRelation("SC6DETAIL", aRelation, SC6->(IndexKey(1)))

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao XBRUNO
@author Bruno Nascimento Goncalves
@since 29/11/2024
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ViewDef()
	Local oModel := FWLoadModel("XBRUNO")
	Local oStruPai := FWFormStruct(2, cTabPai)
	Local oStruFilho := FWFormStruct(2, cTabFilho)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_SC5", oStruPai, "SC5MASTER")
	oView:AddGrid("VIEW_SC6",  oStruFilho,  "SC6DETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_SC5", "CABEC")
	oView:SetOwnerView("VIEW_SC6", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_SC5", "Cabecalho - SC5")
	oView:EnableTitleView("VIEW_SC6", "Grid - SC6")

	//Adicionando campo incremental na grid
	oView:AddIncrementField("VIEW_SC6", "C6_ITEM")

Return oView
