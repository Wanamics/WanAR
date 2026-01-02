namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;

page 87191 "Issued Reminder Lines DrllDwn"

{
    Caption = 'Issued Reminder Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Issued Reminder Line";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No. of Reminders"; Rec."No. of Reminders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reminder Level';
                    ToolTip = 'Specifies a number that indicates the reminder level.';
                    Visible = false;
                }
                field("Reminder No."; Rec."Reminder No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Reminder No.';
                    Lookup = true;
                    LookupPageId = "Issued Reminder";
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        IssuedReminderHeader: Record "Issued Reminder Header";
                    begin
                        IssuedReminderHeader.SetRange("No.", Rec."Reminder No.");
                        Page.RunModal(Page::"Issued Reminder", IssuedReminderHeader);
                    end;
                }
                field("Reminder Posting Date"; IssuedReminderHeader."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date of the reminder.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date of the customer ledger entry that this reminder line is for.';
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document type of the customer ledger entry this reminder line is for.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number of the customer ledger entry this reminder line is for.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the due date of the customer ledger entry this reminder line is for.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an entry description, based on the contents of the Type field.';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the original amount of the customer ledger entry that this reminder line is for.';
                    Visible = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    ToolTip = 'Specifies the remaining amount of the customer ledger entry this reminder line is for.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    ToolTip = 'Specifies the amount in the currency of the reminder.';
                }
                // field("Applies-To Document Type"; Rec."Applies-To Document Type")
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                //     Visible = false;
                // }
                // field("Applies-To Document No."; Rec."Applies-To Document No.")
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                //     Visible = false;
                // }
            }
        }
    }

    var
        IssuedReminderHeader: Record "Issued Reminder Header";

    trigger OnAfterGetRecord()
    begin
        IssuedReminderHeader.Get(Rec."Reminder No.");
    end;
}
