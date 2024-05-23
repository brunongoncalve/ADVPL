#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ESPELHO DE DEVOLU플O
RELATORIO - ESPELHO DE DEVOLU플O
@author    BRUNO NASCIMENTO GON占폗LVES
@since     15/02/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xESPELHO()

    Local cArquivo := "tmp\arquivo.html"
    Local cHtml	:= ""

    cHtml := MemoRead(cArquivo)

    DEFINE DIALOG oDlg TITLE "Arquivo" FROM 0, 0 TO 550, 800 PIXEL
    oEdit := tSimpleEditor():New(0, 0, oDlg, 500, 300)
    oEdit:TextFormat(1)
    oEdit:Load(" <!DOCTYPE html> "+;
           " <html> "+;
           " <head> "+;
           " <style> "+;
           " table { "+;
           " width:100%; "+;
           " } "+;
           " table, th, td { "+;
           " border: 1px solid black; "+;
           " border-collapse: collapse; "+;
           " } "+;
           " </style> "+;
           " </head> "+;
           " <body> "+;
           " "+;
           " <table> "+;
           " <tr style='width:100px' > "+;
           " <th><span style='font-size:5pt; font-weight:50;'>MODELO DE NOTA FISCAL DE DEVOLU플O</span></th> "+;
           " <th><span style='font-size:5pt; font-weight:50;'>N� DA DEVOLU플O <br> 8 <br> DATA DA DEVOLU플O <br> 23/05/2024</span></th> "+;
           " </tr> "+;
           " </table> "+;
           " </body> "+;
           " </html> ")
    oEdit:Align := CONTROL_ALIGN_ALLCLIENT 
    ACTIVATE DIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oEdit:SaveToPDF("C:\tmp\contrato.pdf"), MsgInfo("Arquivo salvo em C:\tmp\contrato.pdf","Info") },{|| oDlg:End()}) CENTERED

RETURN

