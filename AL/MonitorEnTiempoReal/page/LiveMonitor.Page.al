page 50150 "Live Monitor"
{
    ApplicationArea = All;
    Caption = 'Live Monitor', Comment = 'ESP="Monitor en vivo"';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Live Monitor Buffer";
    SourceTableTemporary = true;
    SourceTableView = sorting("Sort Order", "Name");
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Indicator; Rec.Indicator)
                {
                    Caption = 'St.', Comment = 'ESP="Est."';
                    ToolTip = 'Specifies the current state of the row', comment = 'ESP="Especifica el estado actual de la fila"';
                    ApplicationArea = All;
                    StyleExpr = Rec.Style;
                }
                field("Name"; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the monitored element', comment = 'ESP="Especifica el nombre del elemento monitorizado"';
                    ApplicationArea = All;
                    StyleExpr = Rec.Style;
                }
                field("Status Text"; Rec."Status Text")
                {
                    ToolTip = 'Specifies the state reported in the last snapshot', comment = 'ESP="Especifica el estado reportado en la última instantánea"';
                    ApplicationArea = All;
                    StyleExpr = Rec.Style;
                }
                field("Description"; Rec.Description)
                {
                    ToolTip = 'Specifies the description of the monitored element', comment = 'ESP="Especifica la descripción del elemento monitorizado"';
                    ApplicationArea = All;
                }
                field("Detail Text"; Rec."Detail Text")
                {
                    ToolTip = 'Specifies additional information about the monitored element', comment = 'ESP="Especifica información adicional del elemento monitorizado"';
                    ApplicationArea = All;
                }
                field("Snapshot At"; Rec."Snapshot At")
                {
                    ToolTip = 'Specifies when this row was refreshed for the last time', comment = 'ESP="Especifica cuándo se actualizó esta fila por última vez"';
                    ApplicationArea = All;
                }
            }

            group(Heartbeat)
            {
                Caption = 'Live status', Comment = 'ESP="Estado del monitor"';

                field(MonitorStateTxt; MonitorStateTxt)
                {
                    Caption = 'Monitor', Comment = 'ESP="Monitor"';
                    ToolTip = 'Specifies whether the live refresh is running', comment = 'ESP="Especifica si la actualización en vivo está activa"';
                    ApplicationArea = All;
                    StyleExpr = MonitorStyleTxt;
                }
                field(SourceCaptionTxt; SourceCaptionTxt)
                {
                    Caption = 'Source', Comment = 'ESP="Fuente"';
                    ToolTip = 'Specifies what the monitor is watching', comment = 'ESP="Especifica qué está vigilando el monitor"';
                    ApplicationArea = All;
                }
                field(LastRefreshTxt; LastRefreshTxt)
                {
                    Caption = 'Last refresh', Comment = 'ESP="Última actualización"';
                    ToolTip = 'Specifies the time of the last completed background task', comment = 'ESP="Especifica la hora de la última tarea en segundo plano completada"';
                    ApplicationArea = All;
                }
                field(TickCount; TickCount)
                {
                    Caption = 'Ticks', Comment = 'ESP="Latidos"';
                    ToolTip = 'Specifies how many background refreshes have been completed', comment = 'ESP="Especifica cuántas actualizaciones en segundo plano se han completado"';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ToggleMonitor)
            {
                Caption = 'Start / Stop', Comment = 'ESP="Iniciar / Parar"';
                ToolTip = 'Starts or stops the live refresh', comment = 'ESP="Inicia o detiene la actualización en vivo"';
                ApplicationArea = All;
                Image = Continue;

                trigger OnAction()
                begin
                    SwitchMonitorState();
                end;
            }
            action(RefreshNowAction)
            {
                Caption = 'Refresh now', Comment = 'ESP="Actualizar ahora"';
                ToolTip = 'Takes a snapshot immediately, without waiting for the next tick', comment = 'ESP="Toma una instantánea inmediatamente, sin esperar al siguiente latido"';
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                begin
                    RefreshNow();
                end;
            }
            action(WatchJobQueue)
            {
                Caption = 'Watch job queue', Comment = 'ESP="Vigilar cola de proyectos"';
                ToolTip = 'Switches the monitor to the job queue entries', comment = 'ESP="Cambia el monitor a los proyectos de la cola"';
                ApplicationArea = All;
                Image = Job;

                trigger OnAction()
                begin
                    SwitchSource(CurrentSource::"Job Queue");
                end;
            }
            action(WatchSessions)
            {
                Caption = 'Watch active sessions', Comment = 'ESP="Vigilar sesiones activas"';
                ToolTip = 'Switches the monitor to the active sessions', comment = 'ESP="Cambia el monitor a las sesiones activas"';
                ApplicationArea = All;
                Image = Users;

                trigger OnAction()
                begin
                    SwitchSource(CurrentSource::"Active Sessions");
                end;
            }
            action(Faster)
            {
                Caption = 'Faster', Comment = 'ESP="Más rápido"';
                ToolTip = 'Reduces the time between refreshes by one second', comment = 'ESP="Reduce en un segundo el tiempo entre actualizaciones"';
                ApplicationArea = All;
                Image = NextRecord;

                trigger OnAction()
                begin
                    ChangeInterval(-1);
                end;
            }
            action(Slower)
            {
                Caption = 'Slower', Comment = 'ESP="Más lento"';
                ToolTip = 'Increases the time between refreshes by one second', comment = 'ESP="Aumenta en un segundo el tiempo entre actualizaciones"';
                ApplicationArea = All;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    ChangeInterval(1);
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'ESP="Proceso"';

                actionref(ToggleMonitorRef; ToggleMonitor)
                {
                }
                actionref(RefreshNowRef; RefreshNowAction)
                {
                }
                actionref(WatchJobQueueRef; WatchJobQueue)
                {
                }
                actionref(WatchSessionsRef; WatchSessions)
                {
                }
                actionref(FasterRef; Faster)
                {
                }
                actionref(SlowerRef; Slower)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IntervalSeconds := 5;
        CurrentSource := CurrentSource::"Job Queue";
        MonitorActive := true;
        RefreshNow();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        StartNextTick();
    end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    var
        SnapshotJson: Text;
        TickText: Text;
        TimestampText: Text;
    begin
        if TaskId <> MonitorTaskId then
            exit;

        TaskRunning := false;
        LastTickAt := CurrentDateTime();

        if Results.Get(LiveMonitorMgt.SnapshotKey(), SnapshotJson) then
            LiveMonitorMgt.ApplySnapshot(SnapshotJson, Rec);

        if Results.Get(LiveMonitorMgt.TickKey(), TickText) then
            if not Evaluate(TickCount, TickText) then
                TickCount += 1;

        if Results.Get(LiveMonitorMgt.TimestampKey(), TimestampText) then
            LastRefreshTxt := CopyStr(LiveMonitorMgt.FormatTimestamp(TimestampText), 1, MaxStrLen(LastRefreshTxt));

        UpdateStateTexts();
        StartNextTick();
    end;

    trigger OnPageBackgroundTaskError(TaskId: Integer; ErrorCode: Text; ErrorText: Text; ErrorCallStack: Text; var IsHandled: Boolean)
    var
        MonitorNotification: Notification;
    begin
        if TaskId <> MonitorTaskId then
            exit;

        TaskRunning := false;
        IsHandled := true;

        if ErrorCode = TimeoutCodeTok then begin
            UpdateStateTexts();
            StartNextTick();
            exit;
        end;

        MonitorActive := false;
        UpdateStateTexts();

        MonitorNotification.Message(StrSubstNo(MonitorStoppedLbl, ErrorText));
        MonitorNotification.Send();
    end;

    trigger OnClosePage()
    begin
        MonitorActive := false;

        if TaskRunning then
            CurrPage.CancelBackgroundTask(MonitorTaskId);
    end;

    #region Latido

    local procedure StartNextTick()
    var
        TaskParameters: Dictionary of [Text, Text];
        TimeoutMs: Integer;
    begin
        if not MonitorActive then
            exit;

        if TaskRunning then begin
            if not IsTickStalled() then
                exit;

            CurrPage.CancelBackgroundTask(MonitorTaskId);
            TaskRunning := false;
        end;

        TimeoutMs := (IntervalSeconds * 1000) + LiveMonitorMgt.TimeoutMarginMs();

        TaskParameters.Add(LiveMonitorMgt.SourceKey(), Format(CurrentSource.AsInteger()));
        TaskParameters.Add(LiveMonitorMgt.IntervalKey(), Format(IntervalSeconds * 1000));
        TaskParameters.Add(LiveMonitorMgt.TickKey(), Format(TickCount));

        QueueFull := not CurrPage.EnqueueBackgroundTask(MonitorTaskId, Codeunit::"Live Monitor PBT", TaskParameters, TimeoutMs, PageBackgroundTaskErrorLevel::Warning);

        if QueueFull then
            MonitorActive := false
        else begin
            TaskRunning := true;
            LastTickAt := CurrentDateTime();
        end;

        UpdateStateTexts();
    end;

    local procedure IsTickStalled(): Boolean
    var
        StallLimit: Duration;
    begin
        if LastTickAt = 0DT then
            exit(false);

        StallLimit := (IntervalSeconds * 3000) + LiveMonitorMgt.TimeoutMarginMs();
        exit((CurrentDateTime() - LastTickAt) > StallLimit);
    end;

    #endregion

    #region Acciones del usuario

    local procedure RefreshNow()
    var
        TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary;
        MonitorSource: Interface "Live Monitor Source Handler";
    begin
        MonitorSource := CurrentSource;
        MonitorSource.BuildSnapshot(TempLiveMonitorBuffer);
        LiveMonitorMgt.ApplySnapshot(LiveMonitorMgt.SnapshotToJson(TempLiveMonitorBuffer), Rec);

        LastRefreshTxt := CopyStr(LiveMonitorMgt.FormatTimestamp(Format(CurrentDateTime(), 0, 9)), 1, MaxStrLen(LastRefreshTxt));
        UpdateStateTexts();
        CurrPage.Update(false);
    end;

    local procedure SwitchSource(NewSource: Enum "Live Monitor Source")
    begin
        if TaskRunning then
            CurrPage.CancelBackgroundTask(MonitorTaskId);

        TaskRunning := false;
        CurrentSource := NewSource;
        TickCount := 0;

        Rec.Reset();
        Rec.DeleteAll();

        RefreshNow();
        StartNextTick();
    end;

    local procedure SwitchMonitorState()
    begin
        MonitorActive := not MonitorActive;
        QueueFull := false;

        if MonitorActive then
            StartNextTick()
        else begin
            if TaskRunning then
                CurrPage.CancelBackgroundTask(MonitorTaskId);

            TaskRunning := false;
            UpdateStateTexts();
        end;
    end;

    local procedure ChangeInterval(DeltaSeconds: Integer)
    begin
        IntervalSeconds := LiveMonitorMgt.ClampInterval((IntervalSeconds + DeltaSeconds) * 1000) div 1000;
        UpdateStateTexts();
    end;

    local procedure UpdateStateTexts()
    var
        MonitorSource: Interface "Live Monitor Source Handler";
    begin
        MonitorSource := CurrentSource;
        SourceCaptionTxt := CopyStr(MonitorSource.GetCaption(), 1, MaxStrLen(SourceCaptionTxt));

        if QueueFull then begin
            MonitorStateTxt := CopyStr(QueueFullLbl, 1, MaxStrLen(MonitorStateTxt));
            MonitorStyleTxt := UnfavorableTok;
            exit;
        end;

        if MonitorActive then begin
            MonitorStateTxt := CopyStr(StrSubstNo(RunningLbl, IntervalSeconds), 1, MaxStrLen(MonitorStateTxt));
            MonitorStyleTxt := FavorableTok;
        end else begin
            MonitorStateTxt := CopyStr(StoppedLbl, 1, MaxStrLen(MonitorStateTxt));
            MonitorStyleTxt := AmbiguousTok;
        end;
    end;

    #endregion

    var
        LiveMonitorMgt: Codeunit "Live Monitor Mgt.";
        CurrentSource: Enum "Live Monitor Source";
        LastTickAt: DateTime;
        MonitorTaskId: Integer;
        IntervalSeconds: Integer;
        TickCount: Integer;
        MonitorActive: Boolean;
        TaskRunning: Boolean;
        QueueFull: Boolean;
        MonitorStateTxt: Text[80];
        MonitorStyleTxt: Text[30];
        SourceCaptionTxt: Text[80];
        LastRefreshTxt: Text[30];
        RunningLbl: Label 'Live - refreshing every %1 s', Comment = 'ESP="En vivo - actualizando cada %1 s", %1 = segundos';
        StoppedLbl: Label 'Stopped', Comment = 'ESP="Detenido"';
        QueueFullLbl: Label 'Stopped - the child session queue is full', Comment = 'ESP="Detenido - la cola de sesiones hijas está llena"';
        MonitorStoppedLbl: Label 'The live monitor has stopped: %1', Comment = 'ESP="El monitor en vivo se ha detenido: %1", %1 = texto del error';
        TimeoutCodeTok: Label 'ChildSessionTaskTimeout', Locked = true;
        FavorableTok: Label 'Favorable', Locked = true;
        UnfavorableTok: Label 'Unfavorable', Locked = true;
        AmbiguousTok: Label 'Ambiguous', Locked = true;
}
