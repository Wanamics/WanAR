namespace Wanamics.Reminders;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Reminder;

tableextension 87190 "Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(87190; "No. of Issued Reminders"; Integer)
        {
            Caption = 'No. of Issued Reminders';
            FieldClass = FlowField;
            CalcFormula = count("Issued Reminder Line" where("Entry No." = field("Entry No.")));
            BlankZero = true;
            Width = 4;
        }
    }
}
