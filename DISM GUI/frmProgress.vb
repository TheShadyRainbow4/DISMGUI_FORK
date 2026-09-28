Public Class frmProgress
    Dim Progress As Integer
    

    Private Sub frmProgress_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Using stream As System.IO.Stream = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceStream("DISM_GUI.DISM_GUI.ico")
                If stream IsNot Nothing Then
                    Me.Icon = New System.Drawing.Icon(stream)
                Else
                    Me.Icon = System.Drawing.Icon.ExtractAssociatedIcon(System.Windows.Forms.Application.ExecutablePath)
                End If
            End Using
        Catch ex As Exception
        End Try
        Timer1.Enabled = True
    End Sub

End Class