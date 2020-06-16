tableextension 50519 SalesInvoiceHeaderExst extends "Sales Invoice Header"
{
    fields
    {

        field(50520; UUIDHG; Text[250])
        {
            Caption = 'UUID';
            TableRelation = facturas_Timbradas.UUID where(Folio = field("No."));
            DataClassification = ToBeClassified;
        }

        field(50522; "UUID Relation HG"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50523; "Tipo relacion"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Seleccione","Facturas","Notas de credito";

        }

    }


    var
        myInt: Integer;
        status: Boolean;
}