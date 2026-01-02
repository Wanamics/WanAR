namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;
using Microsoft.Sales.Receivables;
pageextension 87190 "Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Open")
        {
            field("No. of Reminder Issued"; Rec."No. of Issued Reminders")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Reminder Issued Entries field.', Comment = '%';
                Visible = false;
                trigger OnDrillDown()
                var
                    IssuedReminderLine: Record "Issued Reminder Line";
                begin
                    IssuedReminderLine.SetRange("No.");
                    IssuedReminderLine.SetRange(Type, IssuedReminderLine.Type::"Customer Ledger Entry");
                    IssuedReminderLine.SetRange("Entry No.", Rec."Entry No.");
                    if IssuedReminderLine.IsEmpty() then
                        Rec.FieldError("No. of Issued Reminders");
                    Page.RunModal(Page::"Issued Reminder Lines DrllDwn", IssuedReminderLine);
                end;
            }
            field("Last Issued Reminder Date"; LastIssuedReminderDate())
            {
                Caption = 'Last Issued Reminder Date';
                ToolTip = 'Specifies the posting date of the last Issued Reminder.', Comment = '%';
                ApplicationArea = All;
                Visible = false;
                Width = 8;
            }
            // Field("Last Issued Reminder Level"; Rec."Last Issued Reminder Level")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the Last Issued Reminder Level.';
            //     BlankZero = true;
            //     Visible = false;
            //     Width = 5;
            // }

            Field(wanLatePaymentDays; wanGetLatePaymentDays(Rec))
            {
                ApplicationArea = All;
                Caption = 'Late Payment Days';
                ToolTip = 'Specifies the number of days that have passed since the due date of the customer ledger entry.';
                BlankZero = true;
                Visible = false;
                Width = 5;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("Late Payment Invoices")
            {
                ApplicationArea = All;
                Caption = 'Late Payment Invoices';
                Image = DueDate;
                ToolTip = 'Filter invoices overdue or where %1 is greater than %2.', Comment = '%1:FieldName("Closed at Date"), %2:FieldName("Due Date")';
                trigger OnAction()
                begin
                    Rec.ClearMarks();
                    Rec.SetRange("Document Type", Rec."Document Type"::Invoice);
                    Rec.SetFilter("Original Amount", '<>0');
                    if Rec.FindSet() then
                        repeat
                            if (Rec."Closed at Date" = 0D) or (Rec."Closed at Date" > Rec."Due Date") then
                                Rec.Mark(true);
                        until Rec.Next() = 0;
                    Rec.SetRange("Document Type");
                    Rec.SetRange("Original Amount");
                    Rec.MarkedOnly(true);
                end;
            }
        }
    }

    local procedure LastIssuedReminderDate(): Date
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
        IssuedReminderLine: Record "Issued Reminder Line";
    begin
        IssuedReminderLine.SetRange("Entry No.", Rec."Entry No.");
        if not IssuedReminderLine.FindLast() then
            exit(0D);
        if IssuedReminderHeader.Get(IssuedReminderLine."Reminder No.") then
            exit(IssuedReminderHeader."Posting Date");
    end;

    local procedure wanGetLatePaymentDays(pRec: Record "Cust. Ledger Entry"): Integer
    begin
        if pRec."Closed at Date" <> 0D then
            exit(pRec."Closed at Date" - pRec."Due Date");
        if pRec.Open and (pRec."Due Date" < WorkDate()) then
            exit(WorkDate() - pRec."Due Date");
    end;
}