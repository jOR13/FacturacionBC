page 70145 NumerosParciales
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PartialNo;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Numeros)
            {
                field(ID; ID)
                {
                    ApplicationArea = All;
                }
                field("Partial No."; "Partial No.")
                {
                    ApplicationArea = All;
                }
                field(CustLedegerEntryNo; CustLedegerEntryNo)
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
            action(PartialNO)
            {
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                var

                    p: Record PartialNo;
                    i: Integer;
                begin
                    p.DeleteAll();
                    cod.calcPartial();

                end;
            }

            action(CalcTipoCambio)
            {
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                var
                    DCLE: Record "Detailed Cust. Ledg. Entry";
                begin
                    DCLE.SetFilter(DCLE."Entry Type", 'Application|Initial Entry');
                    DCLE.SetFilter(DCLE.Unapplied, 'false');
                    DCLE.SetFilter(DCLE.Amount, '<>0');
                    DCLE.SetFilter(DCLE."Amount (LCY)", '<>0');
                    if DCLE.FindSet() then begin
                        repeat begin
                            DCLE.TipoCambio := DCLE."Amount (LCY)" / DCLE.Amount;
                            DCLE.Modify();
                        end until DCLE.Next() = 0;
                    end;
                end;
            }

            action(getUUID)
            {
                ApplicationArea = All;
                Image = GetEntries;
                trigger OnAction()
                var
                    m: Codeunit Methods;
                begin
                    m.getUUIDS();
                end;
            }

            action(calcularRestante)
            {
                ApplicationArea = All;
                Image = Calculate;


                trigger OnAction()
                begin
                    //DCLE.SetFilter(SaldoRestante, '0');
                    DCLE.SetFilter("Cust. Ledger Entry No.", Format(2359893));
                    //DCLE.SetFilter("Entry Type", 'Initial Entry|Application');
                    //DCLE.SetFilter("Posting Date", '-30D..today');
                    if DCLE.FindSet() then begin
                        repeat begin
                            cod.restante(DCLE."Cust. Ledger Entry No.");
                        end until DCLE.Next() = 0;
                    end;
                end;

            }
        }
    }

    var
        cod: Codeunit Methods;
        DCLE: Record "Detailed Cust. Ledg. Entry";
}