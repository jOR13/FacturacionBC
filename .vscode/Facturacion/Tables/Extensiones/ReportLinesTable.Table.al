table 57112 ReportLinesTableHG
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Index; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; ClaveProducto; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; ClaveUnidad; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Qty; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; UnitValue; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Amount; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; TaxType; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Tipo; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Base; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; ImporteTrasladado; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; ImporteLetra; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; SubTotal; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; IVATotal; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Total; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; TaxLineAmount; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Impuesto; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; Base1; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19; NumPedimento; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; FechaPedTxt; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; FechaPedimento; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; TipoFactor; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(23; TasaOCuota; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(24; Discount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    /*
          keys
          {
              key(PK; Index)
              {
                  Clustered = true;

              }
          }
      */
    var
        myInt: Integer;

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}
