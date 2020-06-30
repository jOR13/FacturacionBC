table 50976 Filtro
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; filtro; text[50])
        {
            Caption = 'Filtro para insertar facturas';
            DataClassification = ToBeClassified;

        }
        field(2; id; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(3; filtroNC; text[50])
        {
            Caption = 'Filtro para insertar NC';
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

page 50967 Filtro
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = filtro;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

                field(filtro; filtro)
                {
                    ApplicationArea = All;
                }

                field(filtroNC; filtroNC)
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