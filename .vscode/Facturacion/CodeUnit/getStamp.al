codeunit 50504 getStamp
{

    Permissions = TableData 112 = rimd;

    [EventSubscriber(ObjectType::Page, page::"Posted Sales Invoices", 'OnOpenPageEvent', '', true, true)]

    procedure timbradas()
    var
        sh: Record "Sales Invoice Header";
        scm: Record "Sales Cr.Memo Header";
        ft: Record facturas_Timbradas;
        page: Page "Posted Sales Invoices";
        c: Codeunit codeUnitWS;
        filtro: text;
        eventHandler: Codeunit cuqr;
    begin

        page.Update;
        c.Refresh();

        filtro := c.getFilter();
        if filtro = '' then begin
            filtro := '-3D..Today';
        end;

        /*
        sh.SetFilter(sh.UUIDHG, '');
        sh.setfilter(sh.Cancelled, 'No');
        sh.SetFilter(sh."Posting Date", filtro);
        */



        ft.SetFilter(ft.FechaBC2, filtro);
        if ft.FindSet() then begin
            repeat
            begin
                if sh.Get(ft.Folio) then begin
                    if sh."No." = ft.Folio then begin
                        sh.UUIDHG := ft.UUID;
                        if sh."UUID Relation HG" = '' then begin
                            sh."UUID Relation HG" := ft."UUID Relacionado";
                            sh."Fecha de timbrado" := ft.FechaTimbrado;
                            sh.TotalFactura := ft.TotalText;
                            sh.RFCR := ft.RfcReceptor;
                        end;
                        sh.Modify();
                    end;
                end;
            end until ft.Next() = 0;
        end;
    end;
}

codeunit 50845 CREDITMEMOS
{
    Permissions = TableData 114 = rimd;
    [EventSubscriber(ObjectType::Page, page::"Posted Sales Credit Memos", 'OnOpenPageEvent', '', true, true)]
    procedure NCtimbradas()
    var
        nct: Record NCTimbradas;
        scm: Record "Sales Cr.Memo Header";
        sih: Record "Sales Invoice Header";
        page: Page "Posted Sales Credit Memos";
        c: Codeunit GetJsonNC;
        cf: Codeunit codeUnitWS;
        filtro: text;
        fil: text;
    begin

        //Agrega relacion de UUID
        if scm.FindSet() then begin
            repeat begin
                if sih.Get(scm."Applies-to Doc. No.") then begin
                    if sih."No." = scm."Applies-to Doc. No." then begin
                        if sih.UUIDHG <> '' then begin
                            scm.UUIDRelacionadoNC := sih.UUIDHG;
                            scm.Modify();
                        end;
                    end;
                end;
            end until scm.Next() = 0;
        end;

        c.Refresh();
        page.Update;
        //agrega nota de credito timbrada
        filtro := c.getFilterNC();
        if filtro = '' then begin
            filtro := '-3D..Today';
        end;

        nct.SetFilter(nct.FechaBC2, filtro);
        if nct.FindSet() then begin
            repeat
            begin
                if scm.Get(nct.Folio) then begin
                    if scm."No." = nct.Folio then begin
                        scm.UUIDNCHG := nct.UUID;
                        if scm.UUIDRelacionadoNC = '' then begin
                            scm.UUIDRelacionadoNC := nct."UUID Relacionado";
                            scm."Fecha de timbrado" := nct.FechaTimbrado;
                            scm.TotalFactura := nct.TotalText;
                            scm.RFCR := nct.RfcReceptor;
                        end;
                        scm.Modify();
                    end;
                end;
            end until nct.Next() = 0;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterActionEvent', 'Post', true, true)]
    local procedure MyProcedure()
    begin
        c.calCImporteTraslado();
        cod.calCImporteTrasladoNC();

        //NCtimbradas();
    end;



    var
        c: Codeunit codeUnitWS;
        cod: Codeunit GetJsonNC;

}