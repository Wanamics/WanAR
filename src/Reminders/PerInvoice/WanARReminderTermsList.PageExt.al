namespace Wanamics.Veternity.Outstanding;

using Microsoft.Sales.Reminder;
pageextension 87193 "WanAR Reminder Terms List" extends "Reminder Terms List"
{
    layout
    {
        addlast(Control1)
        {
            field("WanAR Per Invoice"; Rec."WanAR Per Invoice")
            {
                ApplicationArea = All;
            }
        }
    }
}
