namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;

pageextension 87191 "Reminder Email Text" extends "Reminder Email Text"
{
    layout
    {
        addafter(BodyTextGroup)
        {
            group(wanBodyTextGroup)
            {
                ShowCaption = false;
                field("wan Body Text Editor"; wanBodyText)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                    ExtendedDatatype = RichContent;
                    StyleExpr = false;
                    Caption = 'wan Body Text';
                    ToolTip = 'Specifies the main text of the email, which appears between the greeting and the closing.';

                    trigger OnValidate()
                    begin
                        Rec.SetWanBodyText(wanBodyText);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        wanBodyText := Rec.GetWanBodyText();
    end;

    var
        wanBodyText: Text;
}
