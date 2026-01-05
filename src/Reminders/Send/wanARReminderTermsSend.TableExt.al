namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

tableextension 87195 "wanAR Reminder Terms Send" extends "Reminder Terms"
{
    fields
    {
        field(87195; "WanAR Attach Invoices as pdf"; Boolean)
        {
            Caption = 'Attach Invoices as pdf';
            DataClassification = SystemMetadata;
        }
        // field(87196; "WanAR Invoice URL Pattern"; Text[100])
        // {
        //     Caption = 'Invoice URL Pattern';
        //     DataClassification = SystemMetadata;
        //     ToolTip = 'Specifies URL pattern with placeholders (%1:Document type, %2:Document No.).';
        // }
    }
}
