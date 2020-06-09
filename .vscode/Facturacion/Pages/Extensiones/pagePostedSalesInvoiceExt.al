pageextension 50505 pagePostedSalesInvoiceExt extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Work Description")
        {
            field("Tipo relacion"; "Tipo relacion")
            {
                ApplicationArea = all;
                Caption = 'Tipo de documento a relacionar';
                trigger OnValidate()
                var
                begin
                    show := false;


                    if (UUIDHG = '') then begin
                        stat := true;
                        "UUID Relation HG" := '';
                    end else begin
                        Message('Esta factura ya ha sido timbrada, no puede agregar o modificar');
                        "Tipo relacion" := 0;
                        stat := false;
                    end;

                end;
            }
            field("UUID Relation"; "UUID Relation HG")
            {
                ApplicationArea = All;
                Editable = stat;
                Style = Favorable;
                TableRelation = if ("Tipo relacion" = const(2)) "Sales Cr.Memo Header".UUIDNCHG where("Sell-to Customer No." = field("Sell-to Customer No."), UUIDNCHG = filter(<> ''))
                else
                if ("Tipo relacion" = const(1)) "Sales Invoice Header".UUIDHG where("Sell-to Customer No." = field("Sell-to Customer No."), UUIDHG = filter(<> ''));


                //TableRelation = "Sales Cr.Memo Header".UUID where("Sell-to Customer No." = field("Sell-to Customer No."));
                // TableRelation = "Sales Cr.Memo Header".UUID where("Sell-to Customer No." = field("Sell-to Customer No."));
                //TableRelation = "Sales Cr.Memo Header"."No." where(UUID = filter(<> ''));
            }
        }
    }

    var

        show: Boolean;
        stat: Boolean;
}