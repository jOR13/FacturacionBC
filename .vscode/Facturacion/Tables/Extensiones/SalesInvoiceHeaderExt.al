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

        field(50849; aeropuerto; Text[150])
        {
            CaptionML = ENG = 'Airport', ESP = 'Aeropuerto';
            DataClassification = ToBeClassified;
        }

        field(50850; BOL; Text[150])
        {
            CaptionML = ENG = 'Bill of Landing', ESP = 'BOL';
            DataClassification = ToBeClassified;
        }

        field(50851; Pedimento; Text[150])
        {
            CaptionML = ENG = 'Pedimento', ESP = 'Pedimento';
            DataClassification = ToBeClassified;
        }

        field(50852; NoTanque; Text[150])
        {
            CaptionML = ENG = 'Tank number', ESP = 'Numero de tanque';
            DataClassification = ToBeClassified;
        }

        field(50853; PeriodoFact; Text[150])
        {
            CaptionML = ENG = 'Billing period', ESP = 'Periodo de facturación';
            DataClassification = ToBeClassified;
        }

    }


    var
        myInt: Integer;
        status: Boolean;
}