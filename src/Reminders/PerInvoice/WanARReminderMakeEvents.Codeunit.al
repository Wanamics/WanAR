namespace Wanamics.Veternity.Outstanding;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Reminder;
using Microsoft.Sales.History;

codeunit 87193 "WanAR Reminder-Make Events"
{
    [EventSubscriber(ObjectType::Report, Report::"Create Reminders", OnAfterGetRecordCustomerOnBeforeMakeReminder, '', false, false)]
    local procedure OnAfterGetRecordCustomerOnBeforeMakeReminder(Customer: Record Customer; var CustLedgEntry: Record "Cust. Ledger Entry"; ReminderHeaderReq: Record "Reminder Header"; OverdueEntriesOnly: Boolean; IncludeEntriesOnHold: Boolean; var CustLedgEntryLineFeeOn: Record "Cust. Ledger Entry"; var Result: Boolean; var IsHandled: Boolean)
    var
        CLE: Record "Cust. Ledger Entry";
        CLE2: Record "Cust. Ledger Entry";
        ReminderTerms: Record "Reminder Terms";
        MakeReminder: Codeunit "Reminder-Make";
    begin
        if not ReminderTerms.Get(Customer."Reminder Terms Code") or not ReminderTerms."WanAR Per Invoice" then
            exit;
        IsHandled := true;

        CLE.CopyFilters(CustLedgEntry);
        CLE.SetCurrentKey("Customer No.", Open, Positive);
        CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
        CLE.SetRange("Customer No.", Customer."No.");
        CLE.SetRange(Open, true);
        CLE.SetRange(Positive, true);
        if CLE.FindSet() then
            repeat
                CLE2 := CLE;
                CLE2.SetRange("Entry No.", CLE."Entry No.");
                MakeReminder.Set(Customer, CLE2, ReminderHeaderReq, OverdueEntriesOnly, IncludeEntriesOnHold, CustLedgEntryLineFeeOn);
                MakeReminder.Code();
                Clear(MakeReminder);
            until CLE.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reminder-Make", OnBeforeReminderHeaderFind, '', false, false)]
    local procedure OnBeforeReminderHeaderFind(var ReminderHeader: Record "Reminder Header"; ReminderHeaderReq: Record "Reminder Header"; ReminderTerms: Record "Reminder Terms"; Customer: Record Customer)
    begin
        if not ReminderTerms."WanAR Per Invoice" then
            exit;
        ReminderHeader.SetRange("No.", '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reminder-Make", OnBeforeReminderHeaderModify, '', false, false)]
    local procedure OnBeforeReminderHeaderModify(var ReminderHeader: Record "Reminder Header"; var ReminderHeaderReq: Record "Reminder Header"; HeaderExists: Boolean; ReminderTerms: Record "Reminder Terms"; Customer: Record Customer; ReminderLevel: Record "Reminder Level"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if not ReminderTerms."WanAR Per Invoice" then
            exit;
        if SalesInvoiceHeader.Get(CustLedgerEntry."Document No.") then
            ReminderHeader.Name := SalesInvoiceHeader."Sell-to Contact"
        else
            ReminderHeader.Name := CustLedgerEntry."Document No.";
        ReminderHeader.Address := SalesInvoiceHeader."Sell-to Address";
        ReminderHeader."Address 2" := SalesInvoiceHeader."Sell-to Address 2";
        ReminderHeader."Post Code" := SalesInvoiceHeader."Sell-to Post Code";
        ReminderHeader.City := SalesInvoiceHeader."Sell-to City";
        ReminderHeader.County := SalesInvoiceHeader."Sell-to County";
        ReminderHeader."Country/Region Code" := SalesInvoiceHeader."Sell-to Country/Region Code";
        ReminderHeader."WanAR Sell-to E-Mail" := SalesInvoiceHeader."Sell-to E-Mail";
        // ReminderHeader."Phone No." := SalesInvoiceHeader."Sell-to Phone No.";
    end;
}
