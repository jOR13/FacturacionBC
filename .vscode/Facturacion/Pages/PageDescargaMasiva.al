page 50905 PageDescargaMasiva
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = rangos;
    Editable = true;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {

                field("Folio Inicial"; "Folio Inicial")
                {
                    ApplicationArea = All;
                }
                field("Folio final"; "Folio final")
                {
                    ApplicationArea = All;
                }
                field(Descargar; Descargar)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        codigo: Codeunit DescargaMasivaPDFYXML;
                    begin
                        codigo.descargaMasiva(rec."Folio Inicial", rec."Folio final");
                    end;
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

table 50906 Rangos
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; MyField; Integer)
        {
            DataClassification = ToBeClassified;

        }

        field(2; "Folio Inicial"; Integer)
        {
            DataClassification = ToBeClassified;

        }

        field(3; "Folio final"; integer)
        {
            DataClassification = ToBeClassified;

        }

        field(4; "Descargar"; Boolean)
        {
            DataClassification = ToBeClassified;

        }




    }

    keys
    {
        key(PK; MyField)
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