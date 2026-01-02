namespace Wanamics.Reminders;

using Microsoft.Sales.Reminder;

report 87190 "Remove Beginning/Ending Lines"
{
    Caption = 'Remove Beginning/Ending Lines', Locked = true;
    ProcessingOnly = true;
    Permissions = tabledata "Issued Reminder Line" = d;
    UsageCategory = None;

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            RequestFilterFields = "No.";
            dataitem("Issued Reminder Line"; "Issued Reminder Line")
            {
                DataItemLinkReference = "Issued Reminder Header";
                DataItemLink = "Reminder No." = field("No.");
                DataItemTableView = sorting("Reminder No.", "Line No.") where("Line Type" = filter("Beginning Text" | "Ending Text"));
                trigger OnPreDataItem()
                begin
                    DeleteAll();
                end;
            }

            trigger OnPreDataItem()
            begin
                if not Confirm('Do you want to remove all beginning and ending lines from %1 %2?', false, Count, TableCaption) then
                    CurrReport.Quit();
            end;
        }
    }
}
