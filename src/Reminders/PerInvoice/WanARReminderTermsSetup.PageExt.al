namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

pageextension 87192 "WanAR Reminder Terms Setup" extends "Reminder Terms Setup"
{
    layout
    {
        addlast(General)
        {
            field("WanAR Per Invoice"; Rec."WanAR Per Invoice")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Per invoice field.', Comment = '%';
            }
        }
    }
}
