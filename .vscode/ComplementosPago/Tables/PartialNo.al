table 70107 PartialNo
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Partial No."; Integer)
        {
            DataClassification = ToBeClassified;

        }

        field(3; CustLedegerEntryNo; Code[250])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; "ID")
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