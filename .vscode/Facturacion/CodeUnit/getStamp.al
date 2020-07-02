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
    begin

        page.Update;
        filtro := c.getFilter();
        sh.SetFilter(sh.UUIDHG, '');
        sh.setfilter(sh.Cancelled, 'No');
        sh.setfilter(sh.Closed, 'No');
        sh.SetFilter(sh."Posting Date", filtro);

        if sh.FindSet() then begin
            repeat begin
                if c.Refresh(sh."No.") = true then begin
                    if ft.FindSet() then begin
                        repeat begin
                            if sh."No." = ft.Folio then begin
                                sh.UUIDHG := ft.UUID;
                                sh."Fecha de timbrado" := ft.FechaTimbrado;
                                if sh."UUID Relation HG" = '' then begin
                                    sh."UUID Relation HG" := ft."UUID Relacionado";
                                end;
                                sh.Modify();
                            end;
                        end until ft.Next() = 0;
                    end;
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

        //page.Update;


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

        ClearAll();

        filtro := cf.getFilterNC();
        scm.setfilter(scm.Cancelled, 'No');
        scm.SetFilter(scm.UUIDNCHG, '');
        scm.SetFilter(scm."Posting Date", filtro);

        if nct.FindSet() then begin
            repeat begin
                if c.Refresh(scm."No.") = true then begin
                    if scm.FindSet() then begin
                        repeat begin
                            if scm.UUIDNCHG = '' then begin
                                if nct.Folio = scm."No." then begin
                                    scm.UUIDNCHG := nct.UUID;
                                    //scm."Fecha de timbrado" := nct.FechaTimbrado;
                                    scm.Modify();
                                end;
                            end;
                        end until scm.Next() = 0;
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