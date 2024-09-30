#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'TopConn.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ELIMINAÇÃO DE RESIDUOS
@author    BRUNO NASCIMENTO GONÇALVES
@since     01/05/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------
  
USER FUNCTION M410VRES()

    LOCAL aArea := GetArea()

    DBSELECTAREA("SC6")
    DBSETORDER(1) 
    DBSEEK(XFILIAL("SC6")+SC5->C5_NUM)  
    SET FILTER TO SC6->C6_FILIAL == XFILIAL("SC6") .And. SC6->C6_NUM == SC5->C5_NUM

    WHILE SC6->(!Eof())
        IF (SC6->C6_QTDVEN-SC6->C6_QTDENT) <> 0
            RECLOCK("SC6", .F.)
                SC6->C6_CANCELA := dDataBase
            MSUNLOCK()
        ENDIF       
        SC6->(DBSKIP())
    ENDDO

    SC6->(DBCLOSEAREA())
    RESTAREA(aArea)

RETURN .T.
