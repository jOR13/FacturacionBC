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

        //turbosina
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

        //transportadora


        field(50854; OrigenDestino; text[250])
        {
            CaptionML = ESP = 'Origen - Destino', ENG = 'Origen - Destino';
            DataClassification = ToBeClassified;
        }

        field(50855; Remision; text[250])
        {
            CaptionML = ENG = 'Remision', ESP = 'Remisión';
            DataClassification = ToBeClassified;
        }

        field(50856; FechaDeEntrega; text[250])
        {
            CaptionML = ESP = 'Delivery date', ENG = 'Fecha entrega';
            DataClassification = ToBeClassified;
        }

        field(50857; Tanque; text[250])
        {
            CaptionML = ESP = 'Tank No.', ENG = 'Numero de tanque';
            DataClassification = ToBeClassified;
        }

        field(50858; ProductoTrasnportado; text[250])
        {
            CaptionML = ESP = 'Transported item', ENG = 'Producto transportado';
            DataClassification = ToBeClassified;
        }


        //gas

        field(50860; NoTicket; Text[2040])
        {
            DataClassification = ToBeClassified;
        }

        field(50861; FechaEntregaGas; Text[2040])
        {
            DataClassification = ToBeClassified;
        }

        //Diesel

        field(50862; RemisonDiesel; Text[2040])
        {
            DataClassification = ToBeClassified;
        }

        field(50863; FechaEntregaDiesel; Text[2040])
        {
            DataClassification = ToBeClassified;
        }

    }


    var
        myInt: Integer;
        status: Boolean;
}