pageextension 50536 ItemLineTrackingCardExtHG extends "Item Tracking Lines"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(PedDate; PedDate)
            {
                ApplicationArea = All;
            }
            field(Pedimento; Pedimento)
            {
                ApplicationArea = All;
            }
            field(NombreAduana; NombreAduana)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
        pedimentos: Record PedimentosTableHG;
        itemLines: Record "Tracking Specification";
    begin
        if pedimentos.FindSet() then begin
            repeat begin
                if rec."Lot No." = pedimentos.Lote then begin
                    rec.Pedimento := pedimentos.Pedimento;
                    rec.PedDate := pedimentos.FechaDate;
                    rec.NombreAduana := pedimentos.NombreAduana;
                    Modify();
                end;
            end until pedimentos.Next() = 0;
        end;
    end;

    var
        isVisible: Boolean;
}
