namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;
using Microsoft.Foundation.Address;
reportextension 87191 "Reminder - Test" extends "Reminder - Test"
{
    WordLayout = './ReportLayouts/wanaReminderTest.docx';
    dataset
    {
        add("Reminder Header")
        {
            column(wanCompanyAddress; CompanyAddress) { }
            column(wanCompanyContactInfo; CompanyContactInfo) { }
            column(wanCompanyLegalInfo; CompanyLegalInfo) { }
            column(wanToAddress; ToAddress) { }
        }
        modify("Reminder Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                Addr: array[8] of Text;
            begin
                FormatAddress.Reminder(Addr, "Reminder Header");
                ToAddress := DocumentHelper.FullAddress(Addr);
            end;
        }
    }
    var
        FormatAddress: Codeunit "Format Address";
        DocumentHelper: Codeunit "Document Helper Subset";
        ToAddress: Text;
        CompanyAddress: Text;
        CompanyContactInfo: Text;
        CompanyLegalInfo: Text;

    trigger OnPreReport()
    begin
        DocumentHelper.GetCompanyInfo(CompanyAddress, CompanyContactInfo, CompanyLegalInfo);
    end;
}