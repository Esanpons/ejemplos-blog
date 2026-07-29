codeunit 50150 "Live Monitor Mgt."
{
    #region Claves del protocolo entre la página y la tarea en segundo plano

    procedure SourceKey(): Text
    begin
        exit('source');
    end;

    procedure IntervalKey(): Text
    begin
        exit('interval');
    end;

    procedure TickKey(): Text
    begin
        exit('tick');
    end;

    procedure SnapshotKey(): Text
    begin
        exit('snapshot');
    end;

    procedure TimestampKey(): Text
    begin
        exit('timestamp');
    end;

    procedure TimeoutMarginMs(): Integer
    begin
        exit(15000);
    end;

    procedure MinIntervalMs(): Integer
    begin
        exit(1000);
    end;

    procedure MaxIntervalMs(): Integer
    begin
        exit(60000);
    end;

    #endregion

    #region Serialización del buffer

    procedure SnapshotToJson(var TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary) ReturnValue: Text
    var
        RowsArray: JsonArray;
        RowObject: JsonObject;
    begin
        TempLiveMonitorBuffer.Reset();
        if TempLiveMonitorBuffer.FindSet() then
            repeat
                Clear(RowObject);
                RowObject.Add('key', TempLiveMonitorBuffer."Key Value");
                RowObject.Add('name', TempLiveMonitorBuffer.Name);
                RowObject.Add('description', TempLiveMonitorBuffer.Description);
                RowObject.Add('status', TempLiveMonitorBuffer."Status Text");
                RowObject.Add('detail', TempLiveMonitorBuffer."Detail Text");
                RowObject.Add('indicator', TempLiveMonitorBuffer.Indicator);
                RowObject.Add('style', TempLiveMonitorBuffer.Style);
                RowObject.Add('sort', TempLiveMonitorBuffer."Sort Order");
                RowsArray.Add(RowObject);
            until TempLiveMonitorBuffer.Next() = 0;

        RowsArray.WriteTo(ReturnValue);
    end;

    procedure ApplySnapshot(SnapshotJson: Text; var TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary)
    var
        RowsArray: JsonArray;
        RowToken: JsonToken;
        RowObject: JsonObject;
        SeenKeys: List of [Text];
        ObsoleteEntries: List of [Integer];
        SnapshotAt: DateTime;
        SelectedKey: Text;
        RowKey: Text;
        EntryNo: Integer;
    begin
        if not RowsArray.ReadFrom(SnapshotJson) then
            exit;

        SnapshotAt := CurrentDateTime();
        SelectedKey := TempLiveMonitorBuffer."Key Value";

        foreach RowToken in RowsArray do begin
            RowObject := RowToken.AsObject();
            RowKey := GetTextValue(RowObject, 'key');
            SeenKeys.Add(RowKey);

            TempLiveMonitorBuffer.Reset();
            TempLiveMonitorBuffer.SetCurrentKey("Key Value");
            TempLiveMonitorBuffer.SetRange("Key Value", CopyStr(RowKey, 1, MaxStrLen(TempLiveMonitorBuffer."Key Value")));
            if not TempLiveMonitorBuffer.FindFirst() then begin
                TempLiveMonitorBuffer.Reset();
                if TempLiveMonitorBuffer.FindLast() then
                    EntryNo := TempLiveMonitorBuffer."Entry No." + 1
                else
                    EntryNo := 1;

                TempLiveMonitorBuffer.Init();
                TempLiveMonitorBuffer."Entry No." := EntryNo;
                TempLiveMonitorBuffer."Key Value" := CopyStr(RowKey, 1, MaxStrLen(TempLiveMonitorBuffer."Key Value"));
                TempLiveMonitorBuffer.Insert();
            end;

            TempLiveMonitorBuffer.Name := CopyStr(GetTextValue(RowObject, 'name'), 1, MaxStrLen(TempLiveMonitorBuffer.Name));
            TempLiveMonitorBuffer.Description := CopyStr(GetTextValue(RowObject, 'description'), 1, MaxStrLen(TempLiveMonitorBuffer.Description));
            TempLiveMonitorBuffer."Status Text" := CopyStr(GetTextValue(RowObject, 'status'), 1, MaxStrLen(TempLiveMonitorBuffer."Status Text"));
            TempLiveMonitorBuffer."Detail Text" := CopyStr(GetTextValue(RowObject, 'detail'), 1, MaxStrLen(TempLiveMonitorBuffer."Detail Text"));
            TempLiveMonitorBuffer.Indicator := CopyStr(GetTextValue(RowObject, 'indicator'), 1, MaxStrLen(TempLiveMonitorBuffer.Indicator));
            TempLiveMonitorBuffer.Style := CopyStr(GetTextValue(RowObject, 'style'), 1, MaxStrLen(TempLiveMonitorBuffer.Style));
            TempLiveMonitorBuffer."Sort Order" := GetIntegerValue(RowObject, 'sort');
            TempLiveMonitorBuffer."Snapshot At" := SnapshotAt;
            TempLiveMonitorBuffer.Modify();
        end;

        TempLiveMonitorBuffer.Reset();
        if TempLiveMonitorBuffer.FindSet() then
            repeat
                if not SeenKeys.Contains(TempLiveMonitorBuffer."Key Value") then
                    ObsoleteEntries.Add(TempLiveMonitorBuffer."Entry No.");
            until TempLiveMonitorBuffer.Next() = 0;

        foreach EntryNo in ObsoleteEntries do
            if TempLiveMonitorBuffer.Get(EntryNo) then
                TempLiveMonitorBuffer.Delete();

        TempLiveMonitorBuffer.Reset();
        TempLiveMonitorBuffer.SetCurrentKey("Sort Order", "Name");
        RestoreSelectedRow(TempLiveMonitorBuffer, SelectedKey);
    end;

    local procedure RestoreSelectedRow(var TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary; SelectedKey: Text)
    begin
        if SelectedKey = '' then
            exit;

        TempLiveMonitorBuffer.SetRange("Key Value", CopyStr(SelectedKey, 1, MaxStrLen(TempLiveMonitorBuffer."Key Value")));
        if TempLiveMonitorBuffer.FindFirst() then;
        TempLiveMonitorBuffer.SetRange("Key Value");
    end;

    local procedure GetTextValue(RowObject: JsonObject; PropertyName: Text): Text
    var
        PropertyToken: JsonToken;
    begin
        if not RowObject.Get(PropertyName, PropertyToken) then
            exit('');

        if not PropertyToken.IsValue() then
            exit('');

        if PropertyToken.AsValue().IsNull() then
            exit('');

        exit(PropertyToken.AsValue().AsText());
    end;

    local procedure GetIntegerValue(RowObject: JsonObject; PropertyName: Text): Integer
    var
        PropertyToken: JsonToken;
    begin
        if not RowObject.Get(PropertyName, PropertyToken) then
            exit(0);

        if not PropertyToken.IsValue() then
            exit(0);

        if PropertyToken.AsValue().IsNull() then
            exit(0);

        exit(PropertyToken.AsValue().AsInteger());
    end;

    #endregion

    #region Utilidades de formato

    procedure FormatTimestamp(TimestampText: Text): Text
    var
        RefreshedAt: DateTime;
    begin
        if Evaluate(RefreshedAt, TimestampText, 9) then
            exit(Format(DT2Time(RefreshedAt), 0, TimeFormatTok));

        exit(TimestampText);
    end;

    procedure ClampInterval(IntervalMs: Integer): Integer
    begin
        if IntervalMs < MinIntervalMs() then
            exit(MinIntervalMs());

        if IntervalMs > MaxIntervalMs() then
            exit(MaxIntervalMs());

        exit(IntervalMs);
    end;

    #endregion

    var
        TimeFormatTok: Label '<Hours24,2>:<Minutes,2>:<Seconds,2>', Locked = true;
}
