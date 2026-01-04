namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

tableextension 87193 "WanAR Reminder Header" extends "Reminder Header"
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
