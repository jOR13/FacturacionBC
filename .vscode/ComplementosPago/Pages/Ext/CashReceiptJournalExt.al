pageextension 70106 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        addafter(Description)
        {
            field("Forma de pago"; "Forma de pago")
            {
                CaptionML = ENG = 'Payment method', ESP = 'Forma de pago';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}