table 70102 PermisosCRE
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }



        field(2; code; code[250])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "No. Permiso"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Last no Used"; integer)
        {
            DataClassification = ToBeClassified;
        }

        field(4; Comercializacion; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; code)
        {
            Clustered = true;
        }

        key(MyKey; id)
        {

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