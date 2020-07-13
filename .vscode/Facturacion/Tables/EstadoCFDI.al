table 60051 EstadoCDFITable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }


        field(2; status; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(3; Folio; text[500])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }

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