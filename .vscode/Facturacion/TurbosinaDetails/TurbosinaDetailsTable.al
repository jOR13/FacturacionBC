table 50872 TurbosinaDetailsTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(2; aeropuerto; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(3; BOL; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(4; Pedimento; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(5; NoTanque; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(6; PeriodoFact; Text[150])
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

page 50871 Aeropuertos
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Aeropuertos;
    Editable = true;
    CaptionML = ENG = 'Airports', ESP = 'Aeropuertos';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(aeropuerto; aeropuerto)
                {
                    ApplicationArea = All;
                }
                field(id; id)
                {
                    ApplicationArea = All;
                }
                field(codigoAero; codigoAero)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}


table 50871 Aeropuertos
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(2; aeropuerto; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(3; codigoAero; Text[150])
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


}


table 50870 tanque
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(2; NoTanque; Text[150])
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
}


table 50869 BillOfLanding
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(2; NoBol; Text[150])
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
}
