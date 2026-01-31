. .\src\script\util\ColorConversion.ps1
. .\src\script\util\Logger.ps1

LogInfo "Starting task: Excel Export"
$ayame_src = Get-Content '.\src\ayame-colors.json' -Raw | ConvertFrom-Json
$ayame_ref = Get-Content '.\bin\ayame.json'        -Raw | ConvertFrom-Json
$excel = New-Object -ComObject Excel.Application
$wb = $excel.Workbooks.Add()
$ws = $wb.Worksheets.Item(1)
$ws.Name = 'Ayame'
$ws.Range("A2").Value2 = "Clipboard:"
$ws.Range("A5").Value2 = "Name"
$ws.Range("B5").Value2 = "Alias"
$ws.Range("C5").Value2 = "Uses"
$ws.Range("D5").Value2 = "Hex"
$ws.Range("E5").Value2 = "sRGB"
$ws.Range("F5").Value2 = "HSL"
$ws.Range("G5").Value2 = "Oklch"
$ws.Range("H5").Value2 = "Red"
$ws.Range("I5").Value2 = "Green"
$ws.Range("J5").Value2 = "Blue"
$ws.Range("K5").Value2 = "WhiteText"
$wb.Names.Add("ClipboardDisplay", $ws.Range("B2")) | Out-Null
$clipboard_display = $ws.Range("ClipboardDisplay")
$ws.Columns(1).ColumnWidth = 12
$ws.Columns(2).ColumnWidth = 24
$ws.Columns(3).ColumnWidth = 24
$ws.Columns(4).ColumnWidth = 8
$ws.Columns(5).ColumnWidth = 14
$ws.Columns(6).ColumnWidth = 24
$ws.Columns(7).ColumnWidth = 24
$ws.Columns(8).ColumnWidth = 6
$ws.Columns(9).ColumnWidth = 6
$ws.Columns(10).ColumnWidth = 6
$tbl = $ws.ListObjects.Add(1, $ws.Range("A5:K6"), $null, 1)
$tbl.Name = "AyameColors"
$tbl.TableStyle = "TableStyleLight8"
foreach ($src_color in $ayame_src) {
    [string] $color_name    = $src_color.name
    [string] $color_aliases = $src_color.aliases -join ', '
    [string] $color_uses    = $src_color.uses    -join ', '
    [string] $color_oklch   = $src_color.oklch
    [string] $color_hex     = $ayame_ref.colors.$color_name.hex
    [string] $color_srgb    = $ayame_ref.colors.$color_name.rgb
    [string] $color_hsl     = $ayame_ref.colors.$color_name.hsl
    [int]    $color_red     = $ayame_ref.colors.$color_name.red
    [int]    $color_green   = $ayame_ref.colors.$color_name.green
    [int]    $color_blue    = $ayame_ref.colors.$color_name.blue

    $new_row = $tbl.ListRows.Add()
    
    $new_row.Range($tbl.ListColumns('Name' ).Index).Value2 = $color_name
    $new_row.Range($tbl.ListColumns('Alias').Index).Value2 = $color_aliases
    $new_row.Range($tbl.ListColumns('Uses' ).Index).Value2 = $color_uses
    $new_row.Range($tbl.ListColumns('Hex'  ).Index).Value2 = $color_hex
    $new_row.Range($tbl.ListColumns('sRGB' ).Index).Value2 = $color_srgb
    $new_row.Range($tbl.ListColumns('HSL'  ).Index).Value2 = $color_hsl
    $new_row.Range($tbl.ListColumns('Oklch').Index).Value2 = $color_oklch
    $new_row.Range($tbl.ListColumns('Red'  ).Index).Value  = $color_red
    $new_row.Range($tbl.ListColumns('Green').Index).Value  = $color_green
    $new_row.Range($tbl.ListColumns('Blue' ).Index).Value  = $color_blue

    $new_row.Range($tbl.ListColumns('Alias').Index).WrapText = $true
    $new_row.Range($tbl.ListColumns('Uses' ).Index).WrapText = $true

    $new_row.Range.Interior.Color = Convert-RgbToExcelColor $color_red $color_green $color_blue
    if ((Get-ReadableTextColor $color_red $color_green $color_blue) -eq [ReadableTextColor]::Black) {
        $new_row.Range.Font.Color = Convert-RgbToExcelColor 0 0 0
        $new_row.Range($tbl.ListColumns('WhiteText').Index).Value = $false
    }
    else {
        $new_row.Range.Font.Color = Convert-RgbToExcelColor 255 255 255
        $new_row.Range($tbl.ListColumns('WhiteText').Index).Value = $true
    }
}
$tbl.ListRows(1).Delete()
$tbl.ListColumns("WhiteText").Range.EntireColumn.Hidden = $true

$code = @"
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    On Error GoTo ExitHandler

    If Target.CountLarge <> 1 Then GoTo ExitHandler

    Dim tbl As ListObject
    Set tbl = Me.ListObjects("AyameColors")

    Dim colHex As ListColumn
    Dim colSRGB As ListColumn
    Dim colHSL As ListColumn
    Dim colOklch As ListColumn

    Set colHex = tbl.ListColumns("Hex")
    Set colSRGB = tbl.ListColumns("sRGB")
    Set colHSL = tbl.ListColumns("HSL")
    Set colOklch = tbl.ListColumns("Oklch")

    Dim inHex As Boolean
    Dim inSRGB As Boolean
    Dim inHSL As Boolean
    Dim inOklch As Boolean

    inHex = Not Intersect(Target, colHex.DataBodyRange) Is Nothing
    inSRGB = Not Intersect(Target, colSRGB.DataBodyRange) Is Nothing
    inHSL = Not Intersect(Target, colHSL.DataBodyRange) Is Nothing
    inOklch = Not Intersect(Target, colOklch.DataBodyRange) Is Nothing

    If inHex Or inSRGB Or inHSL Or inOklch Then
        Clipboard Target.Value

        Range("ClipboardDisplay").Value = Target.Value

        Dim SelectedRow As Range
        Set SelectedRow = GetSelectedRow("AyameColors")
        Dim Red As Integer: Red = SelectedRow(tbl.ListColumns("Red").Index).Value2
        Dim Green As Integer: Green = SelectedRow(tbl.ListColumns("Green").Index).Value2
        Dim Blue As Integer: Blue = SelectedRow(tbl.ListColumns("Blue").Index).Value2
        Range("ClipboardDisplay").Interior.Color = RGB(Red, Green, Blue)

        Dim WhiteText As Boolean: WhiteText = SelectedRow(tbl.ListColumns("WhiteText").Index).Value2
        If WhiteText Then
            Range("ClipboardDisplay").Font.Color = RGB(255, 255, 255)
        Else
            Range("ClipboardDisplay").Font.Color = RGB(0, 0, 0)
        End If
    End If

ExitHandler:
End Sub

Function Clipboard`$(Optional s`$)
    Dim v: v = s  'Cast to variant for 64-bit VBA support
    With CreateObject("htmlfile")
    With .parentWindow.clipboardData
        Select Case True
            Case Len(s): .setData "text", v
            Case Else:   Clipboard = .GetData("text")
        End Select
    End With
    End With
End Function

Public Function GetSelectedRow(TableName As String) As Range
    Dim ThisTable As ListObject: Set ThisTable = Range(TableName).ListObject
    If TypeName(Selection) = "Range" Then
        If Intersect(Selection, ThisTable.Range) Is Nothing Then
            Err.Raise Number:=vbObjectError + 617, _
                Description:="The selected cell is not in the " & TableName & " table."
            Exit Function
        End If
    End If

    Set GetSelectedRow = ThisTable.ListRows(Selection.Row - ThisTable.Range.Row).Range
End Function
"@
$module = $wb.VBProject.VBComponents('Sheet1').CodeModule
$module.AddFromString($code)

$save_path = [System.IO.Path]::Combine($PWD, 'bin', 'excel', 'Ayame.xlsm')
[System.IO.Directory]::CreateDirectory((Split-Path $save_path -Parent)) | Out-Null
if (Test-Path $save_path) { Remove-Item $save_path -Force }
$wb.SaveAs($save_path, 52)

$wb.Close($false)
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($ws)    | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($wb)    | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

LogInfo "Completed task: Excel Export"
