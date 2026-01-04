namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

tableextension 87194 "WanAR Issued Reminder Header" extends "Issued Reminder Header"
{
    fields
    {
        field(87190; "WanAR Sell-to E-Mail"; Text[100])
        {
            Caption = 'Sell-to E-Mail';
            DataClassification = CustomerContent;
        }
    }
}
