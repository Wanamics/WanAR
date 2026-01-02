namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;
using System.Reflection;

tableextension 87191 "Reminder Email Text" extends "Reminder Email Text"
{
    fields
    {
        field(87190; "wan Body Text"; Blob)
        {
            Caption = 'wan Body Text';
            DataClassification = CustomerContent;
        }
    }
    var
        NoRecordSelectedErr: Label 'No reminder email text selected.';

    internal procedure SetWanBodyText(value: Text)
    var
        WriteStream: OutStream;
    begin
        if Rec.IsEmpty() then
            Error(NoRecordSelectedErr);

        if value = '' then begin
            Clear(Rec."wan Body Text");
            Rec.Modify();
            exit;
        end;

        Clear(Rec."wan Body Text");
        Rec."wan Body Text".CreateOutStream(WriteStream, TextEncoding::UTF8);
        WriteStream.WriteText(value);
        Rec.Modify();
    end;

    internal procedure SetWanBodyText(value: Text; var ReminderEmailText: Record "Reminder Email Text")
    begin
        ReminderEmailText.SetWanBodyText(value);
    end;

    internal procedure GetWanBodyText(): Text
    begin
        exit(GetWanBodyText(Rec));
    end;

    internal procedure GetWanBodyLbl(): Text
    var
        WanBodyLbl: Label 'If you have already made the payment, please disregard this email. Thank you for your business.';
    begin
        exit(WanBodyLbl);
    end;

    internal procedure GetWanBodyText(var ReminderEmailText: Record "Reminder Email Text"): Text
    var
        TypeHelper: Codeunit "Type Helper";
        ReadStream: InStream;
        BodyText: Text;
    begin
        if ReminderEmailText.IsEmpty() then
            Error(NoRecordSelectedErr);

        ReminderEmailText.CalcFields("wan Body Text");
        if ReminderEmailText."wan Body Text".HasValue() then begin
            ReminderEmailText."wan Body Text".CreateInStream(ReadStream, TextEncoding::UTF8);
            BodyText := TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(ReadStream, TypeHelper.LFSeparator(), FieldName("wan Body Text"));
        end
        else
            BodyText := '';
        exit(BodyText);
    end;
}
