namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;
using Microsoft.Foundation.Address;
using System.Security.AccessControl;
using System.Text;
using Microsoft.EServices.EDocument;
using Microsoft.Sales.History;
reportextension 87190 Reminder extends Reminder
{
    dataset
    {
        add(Integer)
        {
            column(wanCompanyInfoPicture; CompanyInfo.Picture) { }
        }
        modify(integer)
        {
            trigger OnAfterAfterGetRecord()
            begin
                CompanyInfo.CalcFields(Picture);
            end;
        }
        add("Issued Reminder Header")
        {
            column(wanCompanyAddress; CompanyAddress) { }
            column(wanCompanyContactInfo; CompanyContactInfo) { }
            column(wanCompanyLegalInfo; CompanyLegalInfo) { }
            column(wanToAddress; ToAddress) { }
        }
        modify("Issued Reminder Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                Addr: array[8] of Text;
            begin
                FormatAddress.IssuedReminder(Addr, "Issued Reminder Header");
                ToAddress := DocumentHelper.FullAddress(Addr);
            end;
        }
        add("Issued Reminder Line")
        {
            column(wanDescription; DocumentHelper.iIf("Line Type" in ["Line Type"::"Reminder Line", "Line Type"::"Not Due"], Format("Document Type") + ' ' + "Document No.", Description)) { }
            column(wanInvoice_Url; DocumentHelper.iIf("Line Type" in ["Line Type"::"Reminder Line", "Line Type"::"Not Due"], wanInvoiceUrl("Issued Reminder Line"), Description)) { }
            column(wanInvoice_UrlText; DocumentHelper.iIf("Line Type" in ["Line Type"::"Reminder Line", "Line Type"::"Not Due"], Format("Document Type") + ' ' + "Document No.", Description)) { }
            column(wanOriginalAmtBWZ; DocumentHelper.BlankZero("Original Amount", "Auto Format"::AmountFormat, "Issued Reminder Header"."Currency Code")) { }
            column(wanRemainingAmtBWZ; DocumentHelper.BlankZero("Remaining Amount", "Auto Format"::AmountFormat, "Issued Reminder Header"."Currency Code")) { }
        }
        // add(IssuedReminderLine2)
        // {
        //     column(wanOriginalAmt2BWZ; DocumentHelper.BlankZero("Original Amount", "Auto Format"::AmountFormat, "Issued Reminder Header"."Currency Code")) { }
        //     column(wanRemainingAmt2BWZ; DocumentHelper.BlankZero("Remaining Amount", "Auto Format"::AmountFormat, "Issued Reminder Header"."Currency Code")) { }
        // }
        add(LetterText)
        {
            column(wanBodyText; wanBodyText) { }
            column(wanCreatedByName; wanCreatedByName("Issued Reminder Header".SystemCreatedBy)) { }
            column(wanUserName; wanUserName()) { }
        }
        modify(LetterText)
        {
            trigger OnAfterPreDataItem()
            var
                wanReminderCommunication: Codeunit "Reminder Communication";
            begin
                wanBodyText := '';
                wanReminderCommunication.PopulateEmailText("Issued Reminder Header", wanBodyText)
            end;
        }
    }
    rendering
    {
        layout(wanReminder)
        {
            Type = Word;
            LayoutFile = './ReportLayouts/wanaReminder.docx';
            Caption = 'WanAR Reminder (Word)';
            Summary = 'The WanAR Reminder (Word) provides a detailed layout.';
        }
        layout(wanReminderEmail)
        {
            Type = Word;
            LayoutFile = './ReportLayouts/wanaReminderEmail.docx';
            Caption = 'WanAR Reminder e-mail (Word)';
            Summary = 'The WanAR Reminder e-mail (Word) provides a detailed layout.';
        }
    }
    trigger OnPreReport()
    begin
        DocumentHelper.GetCompanyInfo(CompanyAddress, CompanyContactInfo, CompanyLegalInfo);
    end;

    var
        FormatAddress: Codeunit "Format Address";
        DocumentHelper: Codeunit "Document Helper Subset";
        ToAddress: Text;
        CompanyAddress: Text;
        CompanyContactInfo: Text;
        CompanyLegalInfo: Text;
        wanBodyText: Text;

    local procedure wanCreatedByName(pUserID: Guid): Text
    var
        User: Record User;
    begin
        if User.GetBySystemId(pUserID) then
            exit(User."Full Name");
    end;

    local procedure wanUserName(): Text
    var
        User: Record User;
    begin
        if User.Get(UserSecurityId()) then
            exit(User."Full Name");
    end;

    local procedure wanInvoiceUrl(pRec: Record "Issued Reminder Line") ReturnValue: Text
    begin
        OnBeforeWanInvoiceUrl("Issued Reminder Header", pRec, ReturnValue);
        if ReturnValue <> '' then
            exit;
        GetIncomingDocumentUrl(pRec."Document No.", ReturnValue);
    end;

    local procedure GetIncomingDocumentUrl(pDocumentNo: code[20]; var ReturnValue: Text);
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        IncomingDocument: Record "Incoming Document";
    begin
        if not SalesInvoiceHeader.Get(pDocumentNo) then
            exit;
        IncomingDocument.SetCurrentKey("Document No.");
        IncomingDocument.SetRange("Document Type", IncomingDocument."Document Type"::"Sales Invoice");
        IncomingDocument.SetRange("Document No.", pDocumentNo);
        if IncomingDocument.FindFirst() then
            ReturnValue := IncomingDocument.URL;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeWanInvoiceUrl(IssuedReminderHeader: Record "Issued Reminder Header"; IssuedReminderLine: Record "Issued Reminder Line"; ReturnValue: Text)
    begin
    end;
}