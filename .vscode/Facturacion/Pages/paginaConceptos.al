page 50684 PaginaConceptos
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Conceptos;
    Editable = true;
    Permissions = TableData 50522 = rimd;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(BaseTraslado; BaseTraslado)
                {
                    ApplicationArea = All;
                }
                field(Cantidad; Cantidad)
                {
                    ApplicationArea = All;
                }
                field(ClaveProdServ; ClaveProdServ)
                {
                    ApplicationArea = All;
                }
                field(ClaveUnidad; ClaveUnidad)
                {
                    ApplicationArea = All;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                }
                field(Descuento; Descuento)
                {
                    ApplicationArea = All;
                }
                field(Folio; Folio)
                {
                    ApplicationArea = All;
                }
                field(Importe; Importe)
                {
                    ApplicationArea = All;
                }
                field(ImporteTraslado; ImporteTraslado)
                {
                    ApplicationArea = All;
                }
                field(ImpuestoTraslado; ImpuestoTraslado)
                {
                    ApplicationArea = All;
                }
                field(NoIdentificacion; NoIdentificacion)
                {
                    ApplicationArea = All;
                }
                field(TasaOCuotaTraslado; TasaOCuotaTraslado)
                {
                    ApplicationArea = All;
                }
                field(TipoFactor; TipoFactor)
                {
                    ApplicationArea = All;
                }
                field(Unidad; Unidad)
                {
                    ApplicationArea = All;
                }
                field(ValorUnitario; ValorUnitario)
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
            action("Borrar facturas")
            {
                ApplicationArea = All;

                Image = Delegate;
                trigger OnAction()
                var
                    ft: Record facturas_Timbradas;
                    ftc: Record Conceptos;

                begin
                    ftc.DeleteAll();
                    ft.DeleteAll();
                end;
            }

            action("Borrar nc")
            {
                ApplicationArea = All;
                Image = Delegate;
                trigger OnAction()
                var
                    ft: Record NCTimbradas;
                    ftc: Record ConceptosNC;

                begin
                    ftc.DeleteAll();
                    ft.DeleteAll();
                end;
            }

            action("Filtro")
            {
                ApplicationArea = All;
                Image = Delegate;
                trigger OnAction()
                var
                    sh: Record "Sales Invoice Header";
                    scm: Record "Sales Cr.Memo Header";
                    ft: Record facturas_Timbradas;
                    page: Page "Posted Sales Invoices";
                    c: Codeunit codeUnitWS;
                begin
                    sh.SetFilter(sh.UUIDHG, '');
                    //sh.SetFilter(sh."Posting Date", '..Today');
                    if sh.FindSet() then begin
                        repeat begin
                            if ft.FindSet() then begin
                                repeat begin
                                    if sh."No." = ft.Folio then begin
                                        sh.UUIDHG := ft.UUID;
                                        if sh."UUID Relation HG" = '' then begin
                                            sh."UUID Relation HG" := ft."UUID Relacionado";
                                        end;
                                        sh.Modify();
                                    end;
                                end until ft.Next() = 0;
                            end;
                        end until sh.Next() = 0;
                    end;
                end;
            }
        }

    }

    var
        myInt: Integer;
}