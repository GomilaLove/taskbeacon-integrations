' --- TaskBeacon: put this in a module of the workbook (.xlsm) ---
' Task Scheduler starts Excel with the workbook; Workbook_Open (below) calls RunReport and closes Excel.
Const TB As String = "https://taskbeacon.io/ping/YOUR-JOB-ADDRESS"

Private Sub TbPing(ByVal path As String)
    On Error Resume Next            ' a failed ping must never stop the macro
    Dim http As Object
    Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    http.setTimeouts 2000, 3000, 2500, 2500   ' resolve, connect, send, receive (ms): at most 10 seconds in all
    http.Open "GET", TB & path, False
    http.send
End Sub

Public Sub RunReport()
    TbPing "/start"
    On Error GoTo Failed
    ' --- your code here ---
    ThisWorkbook.Worksheets(1).Calculate
    Dim tbRows As Long
    tbRows = ThisWorkbook.Worksheets(1).UsedRange.Rows.Count
    TbPing "?rows=" & tbRows
    Exit Sub
Failed:
    Dim msg As String
    msg = Left(Err.Description, 200)
    TbPing "/fail?error=" & Application.WorksheetFunction.EncodeURL(msg)
End Sub

' --- TaskBeacon: put this in ThisWorkbook (not in the module) ---
' Runs when the workbook opens, then closes Excel, also after an error, so no Excel stays open.
Private Sub Workbook_Open()
    On Error Resume Next            ' an error in RunReport must not leave Excel waiting
    RunReport
    ThisWorkbook.Saved = True       ' no "Save changes?" question (call ThisWorkbook.Save in RunReport to keep changes)
    Application.Quit
End Sub
