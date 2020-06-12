pageextension 50506 pagePostSalesInvoicesExt extends 143
{
    Editable = true;


    layout
    {
        modify("No.")
        {
            Style = Favorable;
            StyleExpr = color;
        }
        addafter("Location Code")
        {
            field(UUID; UUIDHG)
            {
                ApplicationArea = all;
            }
        }

        addafter(UUID)
        {

            field("UUID Relation"; "UUID Relation HG")
            {
                ApplicationArea = All;
                Visible = true;
                Style = Favorable;
                TableRelation = UUIDRelacionados."UUID Relacionado" where(Folio = field("No."));
            }

        }
    }

    actions
    {
        addfirst(processing)
        {
            group("Facturación electrónica HG")
            {
                Image = Invoice;
                action("PDF de la Factura")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Report;
                    trigger OnAction()
                    var
                        //reporte: Report ReporteCFDI;
                        reporte: Report HG_ReporteCFDI;
                        cod: Codeunit codeUnitWS;
                        temp: Record temporal;
                        facturas: Record facturas_Timbradas;
                    begin
                        if rec.UUIDHG = '' then begin
                            Message('La factura no se ha timbrado');
                        end else begin
                            facturas.SetFilter(facturas.Folio, rec."No.");
                            temp.Init();
                            temp.getRec := Rec."No.";
                            temp.DocNo := Rec."Order No.";
                            temp.Insert();
                            Commit();
                            reporte.RunModal();
                            temp.DeleteAll();
                            Clear(reporte);
                        end;
                    end;
                }

                action("Timbrar facturas")
                {
                    ApplicationArea = All;
                    Image = AddAction;
                    trigger OnAction()
                    var
                        cod: Codeunit getStamp;
                    begin
                        HYPERLINK('http://192.168.1.73');
                        c.calCImporteTraslado();
                        c.calCImporteTrasladoNC();
                        cod.NCtimbradas();

                    end;
                }
                action("Refrescar timbradas")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Refrescar lista';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = CalculateLines;
                    trigger OnAction();
                    var
                        page: Page facturas;
                    begin
                        page.RunModal();
                        c.Refresh();
                        CurrPage.Update;
                        Commit();


                    end;
                }

                action("Descargar XML")
                {
                    image = CreateXMLFile;
                    ApplicationArea = All;

                    trigger onAction()
                    var
                        myInt: Integer;
                    begin

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if UUIDHG <> '' then begin
            color := true;
        end else begin
            color := false;
        end;
    end;

    var

        mitabla: Record "Sales Invoice Header";
        OutStr: OutStream;
        myInt: Integer;
        mystream: InStream;
        tipocode: TextEncoding;
        texto: Text;
        testfile: File;
        txt: text;
        c: Codeunit codeUnitWS;
        color: Boolean;
}


