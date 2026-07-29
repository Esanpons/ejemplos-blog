codeunit 50152 "Live Mon. Src. Job Queue" implements "Live Monitor Source Handler"
{
    procedure GetCaption(): Text
    begin
        exit(SourceCaptionLbl);
    end;

    procedure BuildSnapshot(var TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary)
    var
        JobQueueEntry: Record "Job Queue Entry";
        SnapshotAt: DateTime;
        EntryNo: Integer;
    begin
        TempLiveMonitorBuffer.Reset();
        TempLiveMonitorBuffer.DeleteAll();

        if not JobQueueEntry.ReadPermission() then
            exit;

        SnapshotAt := CurrentDateTime();

        if JobQueueEntry.FindSet() then
            repeat
                EntryNo += 1;

                TempLiveMonitorBuffer.Init();
                TempLiveMonitorBuffer."Entry No." := EntryNo;
                TempLiveMonitorBuffer."Key Value" := CopyStr(Format(JobQueueEntry.ID, 0, 4), 1, MaxStrLen(TempLiveMonitorBuffer."Key Value"));
                TempLiveMonitorBuffer.Name := CopyStr(ObjectText(JobQueueEntry), 1, MaxStrLen(TempLiveMonitorBuffer.Name));
                TempLiveMonitorBuffer.Description := CopyStr(JobQueueEntry.Description, 1, MaxStrLen(TempLiveMonitorBuffer.Description));
                TempLiveMonitorBuffer."Status Text" := CopyStr(Format(JobQueueEntry.Status), 1, MaxStrLen(TempLiveMonitorBuffer."Status Text"));
                TempLiveMonitorBuffer."Detail Text" := CopyStr(DetailText(JobQueueEntry), 1, MaxStrLen(TempLiveMonitorBuffer."Detail Text"));
                TempLiveMonitorBuffer.Indicator := CopyStr(IndicatorText(JobQueueEntry), 1, MaxStrLen(TempLiveMonitorBuffer.Indicator));
                TempLiveMonitorBuffer.Style := CopyStr(StyleText(JobQueueEntry), 1, MaxStrLen(TempLiveMonitorBuffer.Style));
                TempLiveMonitorBuffer."Sort Order" := SortOrder(JobQueueEntry);
                TempLiveMonitorBuffer."Snapshot At" := SnapshotAt;
                TempLiveMonitorBuffer.Insert();
            until JobQueueEntry.Next() = 0;
    end;

    local procedure ObjectText(JobQueueEntry: Record "Job Queue Entry"): Text
    begin
        if JobQueueEntry."Object Caption to Run" <> '' then
            exit(StrSubstNo(ObjectWithCaptionTok, Format(JobQueueEntry."Object Type to Run"), JobQueueEntry."Object ID to Run", JobQueueEntry."Object Caption to Run"));

        exit(StrSubstNo(ObjectTok, Format(JobQueueEntry."Object Type to Run"), JobQueueEntry."Object ID to Run"));
    end;

    local procedure DetailText(JobQueueEntry: Record "Job Queue Entry"): Text
    var
        JobQueueLogEntry: Record "Job Queue Log Entry";
    begin
        if JobQueueEntry.Status = JobQueueEntry.Status::Error then
            if JobQueueLogEntry.ReadPermission() then begin
                JobQueueLogEntry.SetRange(ID, JobQueueEntry.ID);
                JobQueueLogEntry.SetRange(Status, JobQueueLogEntry.Status::Error);
                if JobQueueLogEntry.FindLast() then
                    exit(ConvertStr(JobQueueLogEntry."Error Message", '\', ' '));
            end;

        if JobQueueEntry."Earliest Start Date/Time" <> 0DT then
            exit(StrSubstNo(NextRunLbl, Format(JobQueueEntry."Earliest Start Date/Time")));

        exit('');
    end;

    local procedure IndicatorText(JobQueueEntry: Record "Job Queue Entry"): Text
    begin
        case JobQueueEntry.Status of
            JobQueueEntry.Status::Ready:
                exit(ReadyTok);
            JobQueueEntry.Status::"In Process":
                exit(InProcessTok);
            JobQueueEntry.Status::Error:
                exit(ErrorTok);
            JobQueueEntry.Status::"On Hold",
            JobQueueEntry.Status::"On Hold with Inactivity Timeout":
                exit(OnHoldTok);
            JobQueueEntry.Status::Finished:
                exit(FinishedTok);
        end;

        exit(UnknownTok);
    end;

    local procedure StyleText(JobQueueEntry: Record "Job Queue Entry"): Text
    begin
        case JobQueueEntry.Status of
            JobQueueEntry.Status::"In Process":
                exit(StrongAccentTok);
            JobQueueEntry.Status::Ready:
                exit(FavorableTok);
            JobQueueEntry.Status::Error:
                exit(UnfavorableTok);
            JobQueueEntry.Status::"On Hold",
            JobQueueEntry.Status::"On Hold with Inactivity Timeout":
                exit(AmbiguousTok);
        end;

        exit(SubordinateTok);
    end;

    local procedure SortOrder(JobQueueEntry: Record "Job Queue Entry"): Integer
    begin
        case JobQueueEntry.Status of
            JobQueueEntry.Status::Error:
                exit(0);
            JobQueueEntry.Status::"In Process":
                exit(1);
            JobQueueEntry.Status::Ready:
                exit(2);
            JobQueueEntry.Status::"On Hold",
            JobQueueEntry.Status::"On Hold with Inactivity Timeout":
                exit(3);
        end;

        exit(4);
    end;

    var
        SourceCaptionLbl: Label 'Job queue', Comment = 'ESP="Cola de proyectos"';
        NextRunLbl: Label 'Next run: %1', Comment = 'ESP="Próxima ejecución: %1", %1 = fecha y hora';
        ObjectWithCaptionTok: Label '%1 %2 - %3', Locked = true;
        ObjectTok: Label '%1 %2', Locked = true;
        ReadyTok: Label '●', Locked = true;
        InProcessTok: Label '▶', Locked = true;
        ErrorTok: Label '✖', Locked = true;
        OnHoldTok: Label '■', Locked = true;
        FinishedTok: Label '✔', Locked = true;
        UnknownTok: Label '·', Locked = true;
        FavorableTok: Label 'Favorable', Locked = true;
        UnfavorableTok: Label 'Unfavorable', Locked = true;
        AmbiguousTok: Label 'Ambiguous', Locked = true;
        StrongAccentTok: Label 'StrongAccent', Locked = true;
        SubordinateTok: Label 'Subordinate', Locked = true;
}
