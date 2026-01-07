#if FALSE
// Subset of codeunit 1890 "Reminder Communication" for wanBodyText handling (like Body Text)
namespace Wanamics.Reminders;
using Microsoft.Sales.Reminder;

using Microsoft.Sales.Customer;
using System.Globalization;
using System.Text;
using Microsoft.Sales.FinanceCharge;
using System.Reflection;
using Microsoft.Foundation.Reporting;
using System.Utilities;

codeunit 87192 "Reminder Communication"
{
    local procedure GetCustomerLanguageOrDefaultUserLanguage(CustomerNo: Code[20]): Code[10]
    var
        Customer: Record Customer;
        Language: Codeunit Language;
        LanguageCode: Code[10];
    begin
        if Customer.Get(CustomerNo) then
            LanguageCode := Customer."Language Code";

        if LanguageCode = '' then
            LanguageCode := Language.GetUserLanguageCode();

        if LanguageCode = '' then
            LanguageCode := Language.GetLanguageCode(Language.GetDefaultApplicationLanguageId());

        exit(LanguageCode);
    end;

    procedure PopulateEmailText(var IssuedReminderHeader: Record "Issued Reminder Header"; /*var CompanyInfo: Record "Company Information"; var GreetingTxt: Text; var AmtDueTxt: Text;*/ var BodyTxt: Text /*; var ClosingTxt: Text; var DescriptionTxt: Text; NNC_TotalInclVAT: Decimal*/)
    var
        ReminderEmailText: Record "Reminder Email Text";
    begin
        BodyTxt := wanReplaceTextTok;
        ReminderEmailText.SetAutoCalcFields("wan Body Text");
        if GetReminderEmailText(IssuedReminderHeader, ReminderEmailText) then;
    end;

    local procedure SelectEmailBodyText(var ReminderEmailText: Record "Reminder Email Text"; var IssuedReminderHeader: Record "Issued Reminder Header"; var BodyTxt: Text)
    begin
        BodyTxt += ReminderEmailText.GetWanBodyText();
    end;

    local procedure SubstituteRelatedValues(var BodyTxt: Text; var IssuedReminderHeader: Record "Issued Reminder Header"; NNC_TotalInclVAT: Decimal; CompanyName: Text[100])
    var
        FinanceChargeTerms: Record "Finance Charge Terms";
        AutoFormat: Codeunit "Auto Format";
        AutoFormatType: Enum "Auto Format";
    begin
        if IssuedReminderHeader."Fin. Charge Terms Code" <> '' then
            FinanceChargeTerms.Get(IssuedReminderHeader."Fin. Charge Terms Code");

        BodyTxt := StrSubstNo(
            BodyTxt,
            IssuedReminderHeader."Document Date",
            IssuedReminderHeader."Due Date",
            FinanceChargeTerms."Interest Rate",
            Format(IssuedReminderHeader."Remaining Amount", 0,
                AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, IssuedReminderHeader."Currency Code")),
            IssuedReminderHeader."Interest Amount",
            IssuedReminderHeader."Additional Fee",
            Format(NNC_TotalInclVAT, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, IssuedReminderHeader."Currency Code")),
            IssuedReminderHeader."Reminder Level",
            IssuedReminderHeader."Currency Code",
            IssuedReminderHeader."Posting Date",
            CompanyName,
            IssuedReminderHeader."Add. Fee per Line");
    end;

    local procedure ReplaceHTMLText(var IssuedReminderHeader: Record "Issued Reminder Header"; var HtmlContent: Text)
    var
        ReminderEmailText: Record "Reminder Email Text";
        BodyText: Text;
    begin
        ReminderEmailText.SetAutoCalcFields("wan Body Text");
        if GetReminderEmailText(IssuedReminderHeader, ReminderEmailText) then
            SelectEmailBodyText(ReminderEmailText, IssuedReminderHeader, BodyText)
        else
            SelectEmailBodyText(IssuedReminderHeader, BodyText);

        SubstituteRelatedValues(BodyText, IssuedReminderHeader, IssuedReminderHeader.CalculateTotalIncludingVAT(), CopyStr(CompanyName, 1, 100));
        HtmlContent := HtmlContent.Replace(wanReplaceTextTok, BodyText);
    end;

    local procedure SelectEmailBodyText(var IssuedReminderHeader: Record "Issued Reminder Header"; var BodyTxt: Text)
    var
        ReminderEmailText: Record "Reminder Email Text";
        TypeHelper: Codeunit "Type Helper";
        EmailBodyTextInStream: InStream;
    begin
        // if there is an email text on the reminder itself, read that it  
        if IssuedReminderHeader."Email Text".HasValue() then begin
            IssuedReminderHeader."Email Text".CreateInStream(EmailBodyTextInStream, TextEncoding::UTF8);
            BodyTxt := TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(EmailBodyTextInStream, TypeHelper.LFSeparator(), IssuedReminderHeader.FieldName("Email Text"));
        end
        else
            BodyTxt := ReminderEmailText.GetWanBodyLbl();
    end;

    local procedure GetReminderEmailText(var IssuedReminderHeader: Record "Issued Reminder Header"; var ReminderEmailText: Record "Reminder Email Text"): Boolean
    var
        ReminderLevel: Record "Reminder Level";
        ReminderTerms: Record "Reminder Terms";
        LanguageCode: Code[10];
    begin
        if (IssuedReminderHeader."Reminder Level" = 0) or (IssuedReminderHeader."Reminder Terms Code" = '') then
            exit(false);

        if not ReminderLevel.Get(IssuedReminderHeader."Reminder Terms Code", IssuedReminderHeader."Reminder Level") then
            Error(ReminderLevelNotFoundErr, IssuedReminderHeader."Reminder Level", IssuedReminderHeader."Reminder Terms Code");

        LanguageCode := GetCustomerLanguageOrDefaultUserLanguage(IssuedReminderHeader."Customer No.");
        if ReminderEmailText.Get(ReminderLevel."Reminder Email Text", LanguageCode) then
            exit(true);

        if not ReminderTerms.Get(IssuedReminderHeader."Reminder Terms Code") then
            Error(ReminderTermNotFoundErr, IssuedReminderHeader."Reminder Terms Code");

        if ReminderEmailText.Get(ReminderTerms."Reminder Email Text", LanguageCode) then
            exit(true);

        exit(false);
    end;

    var
        wanReplaceTextTok: Label '==wanReplaceText==', Locked = true;
        ReminderLevelNotFoundErr: Label 'Reminder Level %1 on Reminder Term %2 was not found.', Comment = '%1 = Reminder Level No., %2 = Reminder Term Code';
        ReminderTermNotFoundErr: Label 'Reminder Term %1 was not found.', Comment = '%1 = Reminder Term Code';

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnAfterDoSaveReportAsHTMLInTempBlob, '', true, true)]
    local procedure OnReplaceHTMLText(ReportID: Integer; var TempBlob: Codeunit "Temp Blob"; var RecordVariant: Variant)
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
        TypeHelper: Codeunit "Type Helper";
        RecordReference: RecordRef;
        ReadStream: InStream;
        WriteStream: OutStream;
        HtmlContent: Text;
        ReportIDExit: Boolean;
    begin
        if ReportID <> Report::Reminder then begin
            ReportIDExit := true;
            OnBeforeExitReportIDOnReplaceHTMLText(ReportID, RecordVariant, ReportIDExit);
            if ReportIDExit then
                exit;
        end;
        if not RecordVariant.IsRecordRef() then
            exit;

        RecordReference.GetTable(RecordVariant);
        if RecordReference.Number <> IssuedReminderHeader.RecordId.TableNo then
            exit;
        IssuedReminderHeader.Copy(RecordVariant);

        TempBlob.CreateInStream(ReadStream, TextEncoding::UTF8);
        TypeHelper.TryReadAsTextWithSeparator(ReadStream, TypeHelper.LFSeparator(), HtmlContent);
        Clear(ReadStream);
        Clear(TempBlob);

        ReplaceHTMLText(IssuedReminderHeader, HtmlContent);

        TempBlob.CreateOutStream(WriteStream, TextEncoding::UTF8);
        WriteStream.WriteText(HtmlContent);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExitReportIDOnReplaceHTMLText(ReportID: Integer; var RecordVariant: Variant; var ReportIDExit: Boolean)
    begin
    end;
}
#endif
