table 50972 PedimentosReportTableHG
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50111; Pedimento; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50112; FechaPed; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50113; FechaPedTxt; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(1; index; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }
    /*keys
      {
          key(PK; MyField)
          {
              Clustered = true;
          }
      }*/
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
