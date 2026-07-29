codeunit 50153 "Live Mon. Src. Sessions" implements "Live Monitor Source Handler"
{
    procedure GetCaption(): Text
    begin
        exit(SourceCaptionLbl);
    end;

    procedure BuildSnapshot(var TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary)
    var
        ActiveSession: Record "Active Session";
        SnapshotAt: DateTime;
        EntryNo: Integer;
    begin
        TempLiveMonitorBuffer.Reset();
        TempLiveMonitorBuffer.DeleteAll();

        if not ActiveSession.ReadPermission() then
            exit;

        SnapshotAt := CurrentDateTime();

        ActiveSession.SetRange("Server Instance ID", ServiceInstanceId());
        if ActiveSession.FindSet() then
            repeat
                EntryNo += 1;

                TempLiveMonitorBuffer.Init();
                TempLiveMonitorBuffer."Entry No." := EntryNo;
                TempLiveMonitorBuffer."Key Value" := CopyStr(Format(ActiveSession."Session ID"), 1, MaxStrLen(TempLiveMonitorBuffer."Key Value"));
                TempLiveMonitorBuffer.Name := CopyStr(ActiveSession."User ID", 1, MaxStrLen(TempLiveMonitorBuffer.Name));
                TempLiveMonitorBuffer.Description := CopyStr(ActiveSession."Client Computer Name", 1, MaxStrLen(TempLiveMonitorBuffer.Description));
                TempLiveMonitorBuffer."Status Text" := CopyStr(Format(ActiveSession."Client Type"), 1, MaxStrLen(TempLiveMonitorBuffer."Status Text"));
                TempLiveMonitorBuffer."Detail Text" := CopyStr(DetailText(ActiveSession, SnapshotAt), 1, MaxStrLen(TempLiveMonitorBuffer."Detail Text"));
                TempLiveMonitorBuffer.Indicator := CopyStr(IndicatorText(ActiveSession), 1, MaxStrLen(TempLiveMonitorBuffer.Indicator));
                TempLiveMonitorBuffer.Style := CopyStr(StyleText(ActiveSession), 1, MaxStrLen(TempLiveMonitorBuffer.Style));
                TempLiveMonitorBuffer."Sort Order" := SortOrder(ActiveSession);
                TempLiveMonitorBuffer."Snapshot At" := SnapshotAt;
                TempLiveMonitorBuffer.Insert();
            until ActiveSession.Next() = 0;
    end;

    local procedure DetailText(ActiveSession: Record "Active Session"; SnapshotAt: DateTime): Text
    var
        Elapsed: Duration;
    begin
        if ActiveSession."Login Datetime" = 0DT then
            exit(StrSubstNo(SessionTok, ActiveSession."Session ID"));

        Elapsed := SnapshotAt - ActiveSession."Login Datetime";
        exit(StrSubstNo(ConnectedSinceLbl, ActiveSession."Session ID", Format(Elapsed)));
    end;

    local procedure IndicatorText(ActiveSession: Record "Active Session"): Text
    begin
        if ActiveSession."Session ID" = SessionId() then
            exit(CurrentSessionTok);

        exit(OtherSessionTok);
    end;

    local procedure StyleText(ActiveSession: Record "Active Session"): Text
    begin
        if ActiveSession."Session ID" = SessionId() then
            exit(StrongAccentTok);

        exit(FavorableTok);
    end;

    local procedure SortOrder(ActiveSession: Record "Active Session"): Integer
    begin
        if ActiveSession."Session ID" = SessionId() then
            exit(0);

        exit(1);
    end;

    var
        SourceCaptionLbl: Label 'Active sessions', Comment = 'ESP="Sesiones activas"';
        ConnectedSinceLbl: Label 'Session %1 - connected for %2', Comment = 'ESP="Sesión %1 - conectada desde hace %2", %1 = id de sesión, %2 = duración';
        SessionTok: Label 'Session %1', Comment = 'ESP="Sesión %1", %1 = id de sesión';
        CurrentSessionTok: Label '★', Locked = true;
        OtherSessionTok: Label '●', Locked = true;
        StrongAccentTok: Label 'StrongAccent', Locked = true;
        FavorableTok: Label 'Favorable', Locked = true;
}
