namespace Wanamics.Reminders;

using Microsoft.Foundation.Address;
using System.Text;
using Microsoft.Foundation.Company;
codeunit 87190 "Document Helper Subset"
// Subset of WanaDoc DocumentHelper to avoid dependency
{
    var
        FormatAddress: Codeunit "Format Address";
        AutoFormat: Codeunit "Auto Format";

    procedure GetCompanyInfo(var pCompanyAddress: Text; var pCompanyContactInfo: Text; var pCompanyLegalInfo: Text)
    var
        CompanyInfo: Record "Company Information";
        Addr: array[8] of Text[100];
    begin
        CompanyInfo.Get();
        FormatAddress.Company(Addr, CompanyInfo);
        pCompanyAddress := FullAddress(Addr);

        if CompanyInfo."Phone No." <> '' then
            pCompanyContactInfo += CompanyInfo."Phone No.";
        if CompanyInfo."E-Mail" <> '' then
            pCompanyContactInfo += LineFeed() + CompanyInfo."E-Mail";
        if CompanyInfo."Home Page" <> '' then
            pCompanyContactInfo += LineFeed() + CompanyInfo."Home Page";

        if CompanyInfo."Registration No." <> '' then
            pCompanyLegalInfo += LineFeed() + CompanyInfo.FieldCaption("Registration No.") + ' ' + CompanyInfo."Registration No.";
        if CompanyInfo."VAT Registration No." <> '' then
            pCompanyLegalInfo += LineFeed() + CompanyInfo.FieldCaption("VAT Registration No.") + ' ' + CompanyInfo."VAT Registration No.";
    end;

    procedure LineFeed() ReturnValue: Text[1];
    begin
        ReturnValue[1] := 10;
    end;

    procedure FullAddress(pAddr: array[8] of Text[100]) ReturnValue: Text;
    var
        i: Integer;
        LastOne: Integer;
    begin
        LastOne := ArrayLen(pAddr);
        while (pAddr[LastOne] = '') and (LastOne > 1) do
            LastOne -= 1;
        ReturnValue := pAddr[1];
        for i := 2 to LastOne do
            ReturnValue += LineFeed() + pAddr[i];
    end;

    procedure iIf(pIf: Boolean; pThen: Text; pElse: Text): Text
    begin
        if pIf then
            exit(pThen)
        else
            exit(pElse);
    end;

    procedure BlankZero(pDecimal: Decimal; pAutoFormatType: Enum "Auto Format"; pCurrencyCode: Code[10]): Text
    begin
        if pDecimal = 0 then
            exit('')
        else
            exit(Format(pDecimal, 0, AutoFormat.ResolveAutoFormat(pAutoFormatType, pCurrencyCode)));
    end;
}
