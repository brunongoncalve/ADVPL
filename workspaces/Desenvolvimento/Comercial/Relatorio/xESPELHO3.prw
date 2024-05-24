#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.ch"

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ESPELHO DE DEVOLUÇÃO
RELATORIO - ESPELHO DE DEVOLUÇÃO
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     15/02/2024
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION teste()

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
           " <table style='overflow-x:auto;'> "+;
           " <tr style='overflow-x:auto;'> "+;
           " <th style='overflow-x:auto;'><span style='font-size:5pt; font-weight:50;'>MODELO DE NOTA FISCAL DE DEVOLUÇÃO</span></th> "+;
           " <th style='overflow-x:auto;'><span style='font-size:5pt; font-weight:50;'>N° DA DEVOLUÇÃO <br> 8 <br> DATA DA DEVOLUÇÃO <br> 23/05/2024</span></th> "+;
           " </tr> "+;
           " </table> "+;
           " <br> <br>"+;
           " <span style='font-size:15pt; font-weight:100;'>1 - Remente</span> "+;
           " <table style='overflow-x:auto;'> "+;
           " <tr style='overflow-x:auto;'> "+;
           " <th style='overflow-x:auto;'><span style='font-size:5pt; font-weight:50;'>CNPJ</span></th> "+;
           " <th style='overflow-x:auto;'><span style='font-size:5pt; font-weight:50;'>RAZÃO SOCIAL</span></th> "+;
           " </tr> "+;
           " <tr> "+;
           " <td style='overflow-x:auto;'><span style='font-size:5pt; font-weight:50;'>TESTE 0101010</span></td>"+;
           " <td style='overflow-x:auto;'><span style='font-size:5pt; font-weight:50;'>TESTE 2020202</span></td>"+;
           " </table> "+;
           " </body> "+;
           " </html> ")
    oEdit:Align := CONTROL_ALIGN_ALLCLIENT 
    ACTIVATE DIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oEdit:SaveToPDF("C:\tmp\contrato.pdf"), MsgInfo("Arquivo salvo em C:\tmp\contrato.pdf","Info") },{|| oDlg:End()}) CENTERED

RETURN

