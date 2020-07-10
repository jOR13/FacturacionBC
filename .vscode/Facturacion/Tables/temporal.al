page 50525 PageTemp
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = temporal;
    Editable = TRUE;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(DocNo; DocNo)
                {
                    ApplicationArea = All;
                }
                field(getRec; getRec)
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

table 50525 temporal
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; getRec; Text[250])
        {
            DataClassification = ToBeClassified;
            InitValue = '';
        }

        field(2; DocNo; Text[250])
        {
            DataClassification = ToBeClassified;
            InitValue = '';
        }
    }

    keys
    {
        key(PK; getRec)
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