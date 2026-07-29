enum 50150 "Live Monitor Source" implements "Live Monitor Source Handler"
{
    Extensible = true;

    value(0; "Job Queue")
    {
        Caption = 'Job Queue', Comment = 'ESP="Cola de proyectos"';
        Implementation = "Live Monitor Source Handler" = "Live Mon. Src. Job Queue";
    }
    value(1; "Active Sessions")
    {
        Caption = 'Active Sessions', Comment = 'ESP="Sesiones activas"';
        Implementation = "Live Monitor Source Handler" = "Live Mon. Src. Sessions";
    }
}
