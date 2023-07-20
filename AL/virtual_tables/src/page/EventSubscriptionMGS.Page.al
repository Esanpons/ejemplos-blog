page 90012 "Event SubscriptionMGS"
{
    ApplicationArea = All;
    Caption = 'Event Subscription';
    PageType = List;
    SourceTable = "Event Subscription";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies if the event subscription is active.';
                    ApplicationArea = All;
                }
                field("Active Manual Instances"; Rec."Active Manual Instances")
                {
                    ToolTip = 'Specifies manual event subscriptions that are active.';
                    ApplicationArea = All;
                }
                field("Error Information"; Rec."Error Information")
                {
                    ToolTip = 'Specifies an error that occurred for the event subscription.';
                    ApplicationArea = All;
                }
                field("Event Type"; Rec."Event Type")
                {
                    ToolTip = 'Specifies the event type, which can be Business, Integration, or Trigger.';
                    ApplicationArea = All;
                }
                field("Number of Calls"; Rec."Number of Calls")
                {
                    ToolTip = 'Specifies how many times the event subscriber function has been called. The event subscriber function is called when the published event is raised in the application.';
                    ApplicationArea = All;
                }
                field("Originating App Name"; Rec."Originating App Name")
                {
                    ToolTip = 'Specifies the object that triggers the event.';
                    ApplicationArea = All;
                }
                field("Originating Package ID"; Rec."Originating Package ID")
                {
                    ToolTip = 'Specifies the value of the Originating Package ID field.';
                    ApplicationArea = All;
                }
                field("Published Function"; Rec."Published Function")
                {
                    ToolTip = 'Specifies the name of the event publisher function in the publisher object that the event subscriber function subscribes to.';
                    ApplicationArea = All;
                }
                field("Publisher Object ID"; Rec."Publisher Object ID")
                {
                    ToolTip = 'Specifies the ID of the object that contains the event publisher function that publishes the event.';
                    ApplicationArea = All;
                }
                field("Publisher Object Type"; Rec."Publisher Object Type")
                {
                    ToolTip = 'Specifies the type of object that contains the event publisher function that publishes the event.';
                    ApplicationArea = All;
                }
                field("Subscriber Codeunit ID"; Rec."Subscriber Codeunit ID")
                {
                    ToolTip = 'Specifies the ID of codeunit that contains the event subscriber function.';
                    ApplicationArea = All;
                }
                field("Subscriber Function"; Rec."Subscriber Function")
                {
                    ToolTip = 'Specifies the event subscriber function in the subscriber codeunit that subscribes to the event.';
                    ApplicationArea = All;
                }
                field("Subscriber Instance"; Rec."Subscriber Instance")
                {
                    ToolTip = 'Specifies the event subscription.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
