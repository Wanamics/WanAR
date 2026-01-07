namespace Wanamics.Veternity.Outstanding;

using Microsoft.Sales.Reminder;
pageextension 87195 "WanAR Reminder Terms List Send" extends "Reminder Terms List"
{
    layout
    {
        addlast(Control1)
        {
            field("WanAR Attach Invoices as pdf"; Rec."WanAR Attach Invoices as pdf")
            {
                ApplicationArea = All;
            }
        }
    }
}
