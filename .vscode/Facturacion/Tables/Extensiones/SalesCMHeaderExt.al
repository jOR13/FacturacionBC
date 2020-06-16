tableextension 50518 SalesCMHeaderExt extends "Sales Cr.Memo Header"
{
    fields
    {

        field(50518; UUIDNCHG; Text[250])
        {
            Caption = 'UUID';
            //TableRelation = facturas_Timbradas.UUID where(Folio = field("No."));
        }
        field(50519; UUIDRelacionadoNC; Text[250])
        {
            // Caption = 'UUID Relacionado';



        }

    }
}
