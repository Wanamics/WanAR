#if FALSE
namespace WanAR.WanAR;

using Microsoft.Sales.Reminder;

pageextension 87193 "Reminder Terms Setup" extends "Reminder Terms Setup"
{
    actions
    {
        addafter(CustomerCommunication)
        {
            action(wanCustomerCommunications)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Communications';
                ToolTip = 'View or edit customer communications for this reminder. Customer communications include texts added to the reminders document and email texts.';
                Image = Text;
                // RunObject = Page "Reminder Term Communication";
                // RunPageLink = Code = field(Code);
                RunObject = Page "Reminder Attachment Texts";
                RunPageLink = Id = field("Reminder Email Text");
            }
        }
        addafter(Category_Process)
        {
            actionref(wanCustomerCommunications_Promoted; wanCustomerCommunications)
            {
            }
        }
    }
}
#endif
