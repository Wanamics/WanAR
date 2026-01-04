namespace WanAR.WanAR;

using Microsoft.Foundation.Reporting;
using Microsoft.Sales.Reminder;

codeunit 87194 GetEmailAddress
{

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnGetEmailAddressOnAfterGetEmailAddressForCust, '', false, false)]
    local procedure OnGetEmailAddressOnAfterGetEmailAddressForCust(ReportUsage: Enum "Report Selection Usage"; RecordVariant: Variant; var TempBodyReportSelections: Record "Report Selections" temporary; var EmailAddress: Text[250]; CustNo: Code[20])
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
    begin
        if ReportUsage <> "Report Selection Usage"::Reminder then
            exit;
        if EmailAddress <> '' then
            exit;
        IssuedReminderHeader := RecordVariant;
        EmailAddress := IssuedReminderHeader."WanAR Sell-to E-Mail";
    end;
}
