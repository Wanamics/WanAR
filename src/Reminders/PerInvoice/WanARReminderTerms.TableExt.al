namespace Wanamics.Veternity.Outstanding;

using Microsoft.Sales.Reminder;
tableextension 87192 "WanAR Reminder Terms" extends "Reminder Terms"
{
    fields
    {
        field(87190; "WanAR Per Invoice"; Boolean)
        {
            Caption = 'Per invoice';
            DataClassification = CustomerContent;
            ToolTip = 'Create distinct reminder for each invoice and use e-mail "Sell-to contact E-mail" from sales invoice.';
        }
    }
}
