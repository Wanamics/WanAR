#if FALSE
namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;
using Microsoft.Sales.History;

pageextension 87194 "Reminder Lines" extends "Reminder Lines"
{
    actions
    {
        addlast(Processing)
        {
            action(ShowDocument)
            {
                ApplicationArea = All;
                Caption = 'Show Invoice';
                ToolTip = 'Opens the invoice related to the selected issued reminder line.';
                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    Rec.TestField("Document Type", Rec."Document Type"::Invoice);
                    SalesInvoiceHeader.Get(Rec."Document No.");
                    Page.RunModal(Page::"Posted Sales Invoice", SalesInvoiceHeader);
                end;
            }
        }
    }
}
#endif
