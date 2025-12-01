namespace Wanamics.Reminders;

using System.EMail;
using Microsoft.Foundation.Reporting;
using Microsoft.Sales.History;
using System.Utilities;

codeunit 87191 "Reminder Events"
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
        AttachRelatedDocument: Boolean;
        I: Integer;
    begin
        if ReportUsage <> Enum::"Report Selection Usage"::Reminder.AsInteger() then
            exit;

#if false
            if SendRemindersSetup."Attach Invoice Documents" = SendRemindersSetup."Attach Invoice Documents"::No then
                exit;
#endif
        TempEmailItem.GetSourceDocuments(SourceTableList, SourceIDList, SourceRelationTypeList);

        for I := 1 to SourceTableList.Count() do begin
            SourceTableID := SourceTableList.Get(I);
            SourceRelationID := SourceRelationTypeList.Get(I);
            SourceID := SourceIDList.Get(I);

            if SourceTableID = Database::"Sales Invoice Header" then
#if false
                    if SendRemindersSetup."Attach Invoice Documents" = SendRemindersSetup."Attach Invoice Documents"::All then
                            AttachRelatedDocument := true
                        else
                            AttachRelatedDocument := IsInvoiceOverdue(PostedDocNo, SourceID);

                    if AttachRelatedDocument then
#endif
                AttachDocument(TempEmailItem, SourceTableID, SourceRelationID, SourceID);
        end;
    end;


    local procedure AttachDocument(var TempEmailItem: Record "Email Item" temporary; SourceTableID: Integer; SourceRelationID: Integer; SourceID: Guid)
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
}
