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
        sh.SetFilter(sh.UUIDHG, '');
        sh.setfilter(sh.Cancelled, 'No');
        sh.setfilter(sh.Closed, 'No');
        sh.SetFilter(sh."Posting Date", filtro);

        if sh.FindSet() then begin
            repeat begin
                if ft.FindSet() then begin
                    repeat begin
                        if sh."No." = ft.Folio then begin
                            sh.UUIDHG := ft.UUID;
                            if sh."UUID Relation HG" = '' then begin
                                sh."UUID Relation HG" := ft."UUID Relacionado";
                                sh."Fecha de timbrado" := ft.FechaTimbrado;
                            end;
                            sh.Modify();
                        end;
                    end until ft.Next() = 0;
                end;
            end until sh.Next() = 0;
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
    begin

        c.Refresh();
        page.Update;

        sih.SetFilter(sih.UUIDHG, '<> ""');
        if sih.FindSet() then begin
            repeat begin
                if scm.FindSet() then begin
                    repeat begin
                        if sih."No." = scm."Applies-to Doc. No." then begin
                            if sih.UUIDHG <> '' then begin
                                scm.UUIDRelacionadoNC := sih.UUIDHG;
                                scm.Modify();
                            end;
                        end;
                    end until scm.Next() = 0;
                end;
            end until sih.Next() = 0;
        end;
        filtro := c.getFilterNC();
        scm.SetFilter(scm.UUIDNCHG, '');
        scm.SetFilter(scm."Posting Date", filtro);
        if nct.FindSet() then begin
            repeat begin
                if scm.FindSet() then begin
                    repeat begin
                        if nct.Folio = scm."No." then begin
                            scm.UUIDNCHG := nct.UUID;
                            scm.Modify();
                        end;
                    end until scm.Next() = 0;
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