codeunit 50151 "Live Monitor PBT"
{
    trigger OnRun()
    var
        TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary;
        LiveMonitorMgt: Codeunit "Live Monitor Mgt.";
        MonitorSource: Interface "Live Monitor Source Handler";
        SourceEnum: Enum "Live Monitor Source";
        Parameters: Dictionary of [Text, Text];
        Results: Dictionary of [Text, Text];
        IntervalMs: Integer;
        SourceOrdinal: Integer;
        TickNo: Integer;
    begin
        Parameters := Page.GetBackgroundParameters();

        IntervalMs := LiveMonitorMgt.ClampInterval(ReadInteger(Parameters, LiveMonitorMgt.IntervalKey(), 5000));
        SourceOrdinal := ReadInteger(Parameters, LiveMonitorMgt.SourceKey(), 0);
        TickNo := ReadInteger(Parameters, LiveMonitorMgt.TickKey(), 0);

        // El latido: la sesión hija es la que espera, no el usuario.
        Sleep(IntervalMs);

        SourceEnum := Enum::"Live Monitor Source".FromInteger(SourceOrdinal);
        MonitorSource := SourceEnum;
        MonitorSource.BuildSnapshot(TempLiveMonitorBuffer);

        Results.Add(LiveMonitorMgt.SnapshotKey(), LiveMonitorMgt.SnapshotToJson(TempLiveMonitorBuffer));
        Results.Add(LiveMonitorMgt.TickKey(), Format(TickNo + 1));
        Results.Add(LiveMonitorMgt.TimestampKey(), Format(CurrentDateTime(), 0, 9));

        Page.SetBackgroundTaskResult(Results);
    end;

    local procedure ReadInteger(var Parameters: Dictionary of [Text, Text]; ParameterName: Text; DefaultValue: Integer) ReturnValue: Integer
    var
        ParameterValue: Text;
    begin
        ReturnValue := DefaultValue;

        if not Parameters.ContainsKey(ParameterName) then
            exit;

        if not Parameters.Get(ParameterName, ParameterValue) then
            exit;

        if not Evaluate(ReturnValue, ParameterValue) then
            ReturnValue := DefaultValue;
    end;
}
