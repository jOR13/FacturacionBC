tableextension 50518 SalesCMHeaderExt extends "Sales Cr.Memo Header"
{
    fields
    {

        field(50518; UUIDNCHG; Text[250])
        {
            Caption = 'UUID';
        }
        field(50519; UUIDRelacionadoNC; Text[250])
        {
        }

        field(50923; "Fecha de timbrado"; text[250])
        {
            DataClassification = ToBeClassified;


        }

        field(50924; "Estado del CFDI"; text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50925; "TotalFactura"; text[250])
        {
            DataClassification = ToBeClassified;
            InitValue = 'Ver estado';


        }

        field(50926; "RFCR"; text[250])
        {
            DataClassification = ToBeClassified;

        }

    }
}
