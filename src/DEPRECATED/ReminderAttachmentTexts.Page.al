#if FALSE
namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

page 87192 "Reminder Attachment Texts"
// based on page 833 "Reminder Attachment Text"
{
    ApplicationArea = All;
    Caption = 'Reminder Attachment Texts';
    PageType = List;
    // CardPageId = "Reminder Attachment Text";
    SourceTable = "Reminder Attachment Text";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                }
                field("Language Code"; Rec."Language Code")
                {
                    // ToolTip = 'Specifies the language code of the beginning and ending lines.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    // ToolTip = 'Specifies the value of the Source Type field.', Comment = '%';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    // Caption = 'File Name';
                    ToolTip = 'Specifies the file name of the attachment.';
                }
                field("Inline Fee Description"; Rec."Inline Fee Description")
                {
                    ApplicationArea = All;
                    // Caption = 'Inline Fee Description';
                    ToolTip = 'Specifies the description line that will appear in the attachment along side the fee.';
                }
                field("Beginning Line"; Rec."Beginning Lines")
                {
                    ApplicationArea = All;
                    // Caption = 'Beginning Line';
                    ToolTip = 'Shows if there are beginning lines for the current language.';
                    Editable = false;
                    Enabled = false;
                }
                field("Ending Line"; Rec."Ending Lines")
                {
                    ApplicationArea = All;
                    // Caption = 'Ending Line';
                    ToolTip = 'Shows if there are ending lines for the current language.';
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CustomerCommunication)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Communication';
                ToolTip = 'View or edit customer communications for this reminder. Customer communications include texts added to the reminders document and email texts.';
                Image = Text;
                RunObject = Page "Reminder email Text";
                RunPageLink = Id = field(Id);
            }
            action("Edit Text Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit Text Lines';
                ToolTip = 'Edit the attachment text lines that would be generated in the reminder.';
                Image = EditLines;

                trigger OnAction()
                var
                    ReminderAttachmentTLTerm: Page "Reminder Attachment T.L. Term";
                    ReminderAttachmentTLLevel: Page "Reminder Attachment T.L. Level";
                begin
                    case Rec."Source Type" of
                        Rec."Source Type"::"Reminder Term":
                            begin
                                ReminderAttachmentTLTerm.SetRecord(Rec);
                                ReminderAttachmentTLTerm.Run();
                            end;
                        Rec."Source Type"::"Reminder Level":
                            begin
                                ReminderAttachmentTLLevel.SetRecord(Rec);
                                ReminderAttachmentTLLevel.Run();
                            end;
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(CustomerCommunication_Promoted; CustomerCommunication)
            {
            }
            actionref(EditTextLines_Promoted; "Edit Text Lines")
            {
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // if LanguageCode = '' then
        //     exit;

        // if not Rec.Get(Rec.Id, LanguageCode) then
        //     Error(NoAttachmentTextFoundErr, LanguageCode);
    end;

    // var
    // LanguageCode: Code[10];
    //     SourceRecord: Option "Reminder Term","Reminder Level";
    //     NoAttachmentTextFoundErr: Label 'No attachment text found for the selected language %1.', Comment = '%1 = Language code';

    // internal procedure SetSourceDataAsTerm(SelectedLanguageCode: Code[10])
    // begin
    // LanguageCode := SelectedLanguageCode;
    //     SourceRecord := SourceRecord::"Reminder Term";
    // end;

    // internal procedure SetSourceDataAsLevel(SelectedLanguageCode: Code[10])
    // begin
    // LanguageCode := SelectedLanguageCode;
    //     SourceRecord := SourceRecord::"Reminder Level";
    // end;
}
#endif
