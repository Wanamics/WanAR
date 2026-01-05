namespace Wanamics.Reminders;

using System.EMail;
using Microsoft.Foundation.Reporting;
using Microsoft.Sales.History;
using Microsoft.Sales.Reminder;
using System.Utilities;

codeunit 87191 "Reminder Attach. Event Handler"
{
    // Subset of codeunit 6753 "Send Reminder Event Handler" to be used while send a reminder email without reminder automation  
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", OnBeforeEmailItemPreparation, '', false, false)]
    local procedure OnBeforeEmailItemPreparation(var TempEmailItem: Record "Email Item" temporary; var HtmlBody: Codeunit "Temp Blob"; var EmailSubject: Text[250]; var ToEmailAddress: Text[250]; var PostedDocNo: Code[20]; var EmailDocName: Text[250]; var HideDialog: Boolean; var ReportUsage: Integer; var IsFromPostedDoc: Boolean; var SenderUserID: Code[50]; var EmailScenario: Enum "Email Scenario"; var EmailSentSuccessfully: Boolean; var IsHandled: Boolean)
    var
        SourceTableList: List of [Integer];
        SourceIDList: List of [Guid];
        SourceRelationTypeList: List of [Integer];
        SourceTableID: Integer;
        SourceRelationID: Integer;
        SourceID: Guid;
        i: Integer;
    begin
        if ReportUsage <> Enum::"Report Selection Usage"::Reminder.AsInteger() then
            exit;
        if not AttachInvoices(PostedDocNo) then
            exit;

        TempEmailItem.GetSourceDocuments(SourceTableList, SourceIDList, SourceRelationTypeList);

        for i := 1 to SourceTableList.Count() do begin
            SourceTableID := SourceTableList.Get(i);
            SourceRelationID := SourceRelationTypeList.Get(i);
            SourceID := SourceIDList.Get(i);
            if SourceTableID = Database::"Sales Invoice Header" then
                AttachInvoice(TempEmailItem, SourceTableID, SourceRelationID, SourceID);
        end;
    end;

    local procedure AttachInvoices(pPostedDocNo: Code[20]): Boolean
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
        ReminderTerms: Record "Reminder Terms";
    begin
        if IssuedReminderHeader.Get(pPostedDocNo) then
            if ReminderTerms.Get(IssuedReminderHeader."Reminder Terms Code") then
                exit(ReminderTerms."WanAR Attach Invoices as pdf");
    end;

    local procedure AttachInvoice(var TempEmailItem: Record "Email Item" temporary; SourceTableID: Integer; SourceRelationID: Integer; SourceID: Guid)
    var
        ReportSelections: Record "Report Selections";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TempAttachementReportSelections: Record "Report Selections" temporary;
        ReportDistributionManagement: Codeunit "Report Distribution Management";
        DocumentMailing: Codeunit "Document-Mailing";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: InStream;
        AttachmentFileName: Text[250];
        DocumentName: Text[250];
    begin
        if SourceRelationID <> Enum::"Email Relation Type"::"Related Entity".AsInteger() then
            exit;
        if SourceTableID <> Database::"Sales Invoice Header" then
            exit;
        if not SalesInvoiceHeader.GetBySystemId(SourceID) then
            exit;
        if not ReportSelections.FindEmailAttachmentUsageForCust(ReportSelections.Usage::"S.Invoice", SalesInvoiceHeader."Bill-to Customer No.", TempAttachementReportSelections) then
            exit;

        SalesInvoiceHeader.SetRecFilter();
        DocumentName := ReportDistributionManagement.GetFullDocumentTypeText(SalesInvoiceHeader);
        DocumentMailing.GetAttachmentFileName(AttachmentFileName, SalesInvoiceHeader."No.", DocumentName, ReportSelections.Usage::"S.Invoice".AsInteger());
        repeat
            TempAttachementReportSelections.SaveReportAsPDFInTempBlob(TempBlob, TempAttachementReportSelections."Report ID", SalesInvoiceHeader, TempAttachementReportSelections."Custom Report Layout Code", ReportSelections.Usage::"S.Invoice");
            TempBlob.CreateInStream(AttachmentStream);

            TempEmailItem.AddAttachment(AttachmentStream, AttachmentFileName);
        until ReportSelections.Next() = 0;
    end;

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Report Distribution Management", OnAfterGetFullDocumentTypeText, '', false, false)]
    local procedure OnAfterGetFullDocumentTypeText(DocumentVariant: Variant; var DocumentTypeText: Text[50]; var DocumentRecordRef: RecordRef)
    begin
        if DocumentRecordRef.Number = Database::"Issued Reminder Header" then
            DocumentTypeText := format(Enum::"Report Selection Usage"::Reminder);
    end;
    */

    // [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnSendEmailDirectlyOnBeforeSendFiles, '', false, false)]
    // local procedure OnSendEmailDirectlyOnBeforeSendFiles(ReportUsage: Integer; RecordVariant: Variant; var DefaultEmailAddress: Text[250]; var TempAttachReportSelections: Record "Report Selections" temporary; var CustomReportSelection: Record "Custom Report Selection"; var ReportSelections: Record "Report Selections")
    // begin
    //     if ReportUsage <> Enum::"Report Selection Usage"::Reminder.AsInteger() then
    //         exit;
    //     //TODO ????
    // end;

    // [EventSubscriber(ObjectType::Report, Report::Reminder, OnLetterTextOnPreDataItemOnAfterSetAmtDueTxt, '', false, false)]
    // local procedure OnLetterTextOnPreDataItemOnAfterSetAmtDueTxt(var IssuedReminderHeader: Record "Issued Reminder Header"; var AmtDueTxt: Text; var GreetingTxt: Text; var BodyTxt: Text; var ClosingTxt: Text; var DescriptionTxt: Text)
    // var
    //     // Split: List of [Text];
    //     // LineFeed: Text[1];
    //     TypeHelper: Codeunit "Type Helper";
    // begin
    //     // LineFeed[1] := 10;
    //     AmtDueTxt := AmtDueTxt.Replace('\', TypeHelper.LFSeparator());
    //     GreetingTxt := GreetingTxt.Replace('\', TypeHelper.LFSeparator());
    //     ClosingTxt := ClosingTxt.Replace('\', TypeHelper.LFSeparator());

    //     // if ClosingTxt <> '' then
    //     //     exit;
    //     // Split := BodyTxt.Split('#');
    //     // if Split.Count() <= 1 then
    //     //     exit;
    //     // BodyTxt := Split.Get(1);
    //     // ClosingTxt := Split.Get(2);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnSendEmailDirectlyOnBeforeSaveReportAsPDFInTempBlob, '', false, false)]
    // local procedure OnSendEmailDirectlyOnBeforeSaveReportAsPDFInTempBlob(ReportSelection: Record "Report Selections"; RecordVariant: Variant; ReportUsage: Enum "Report Selection Usage"; var TempBlob: Codeunit "Temp Blob"; var IsHandled: Boolean)
    // begin
    //     if ReportUsage <> Enum::"Report Selection Usage"::Reminder then
    //         exit;
    //     // IsHandled := true;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnBeforeSaveReportAsPDF, '', false, false)]
    // local procedure OnBeforeSaveReportAsPDF(var ReportID: Integer; RecordVariant: Variant; var LayoutCode: Code[20]; var IsHandled: Boolean; FilePath: Text[250]; ReportUsage: Enum "Report Selection Usage"; SaveToBlob: Boolean; var TempBlob: Codeunit "Temp Blob"; var ReportSelections: Record "Report Selections")
    // begin
    //     if ReportUsage <> Enum::"Report Selection Usage"::Reminder then
    //         exit;
    //     // IsHandled := true;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Email Item", OnBeforeSetAttachments, '', false, false)]
    // local procedure OnBeforeSetAttachments(var EmailItem: Record "Email Item"; var TempBlobList: Codeunit "Temp Blob List"; var Names: List of [Text])
    // var
    //     RemoveLbl: Label '.', Locked = true;
    // begin
    //     if Names.Count() = 0 then
    //         exit;
    //     if not Names.Get(1).StartsWith(RemoveLbl) then
    //         exit;
    //     TempBlobList.RemoveAt(1);
    //     Names.RemoveAt(1);
    // end;
    // [EventSubscriber(ObjectType::Table, Database::"Email Item", OnBeforeGetBodyText, '', false, false)]
    // local procedure OnBeforeGetBodyText(var EmailItem: Record "Email Item"; var Value: Text; var IsHandled: Boolean)
    // begin
    //     //TODO
    // end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Mail Management", OnBeforeSendEmail, '', false, false)]
    // local procedure OnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var IsFromPostedDoc: Boolean; var PostedDocNo: Code[20]; var HideDialog: Boolean; var ReportUsage: Integer; var EmailSentSuccesfully: Boolean; var IsHandled: Boolean; EmailDocName: Text[250]; SenderUserID: Code[50]; EmailScenario: Enum "Email Scenario")
    // begin

    // end;
    // [EventSubscriber(ObjectType::Table, database::"Reminder Header", OnGetReportParameters, '', false, false)]
    // internal procedure OnGetReportParameters(var LogInteraction: Boolean; var ShowNotDueAmounts: Boolean; var ShowMIRLines: Boolean; ReportID: Integer; var Handled: Boolean)
    // begin
    //     ShowNotDueAmounts := true;
    // end;
}
