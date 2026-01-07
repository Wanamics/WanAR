namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

tableextension 87195 "wanAR Reminder Terms Send" extends "Reminder Terms"
{
    fields
    {
        field(87195; "WanAR Attach Invoices as pdf"; Boolean)
        {
            Caption = 'Attach Invoices as pdf';
            ToolTip = 'Specifie each sales invoice will be printed as pdf and attached to reminder e-mail.';
            DataClassification = SystemMetadata;
        }
    }
}
