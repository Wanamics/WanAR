namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

pageextension 87196 "WanAR Reminder Terms Send" extends "Reminder Terms Setup"
{
    layout
    {
        addlast(General)
        {
            field("WanAR Attach Invoices as pdf"; Rec."WanAR Attach Invoices as pdf")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Attach Invoices as pdf field.', Comment = '%';
            }
            // field("WanAR Invoice URL Pattern"; Rec."WanAR Invoice URL Pattern")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Invoice URL Pattern field.', Comment = '%';
            // }
        }
    }
}
