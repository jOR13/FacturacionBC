codeunit 50504 getStamp
{

    Permissions = TableData 112 = rimd;



    [EventSubscriber(ObjectType::Page, page::"Posted Sales Invoices", 'OnOpenPageEvent', '', true, true)]
    local procedure timbradas()
    var
        sh: Record "Sales Invoice Header";
        scm: Record "Sales Cr.Memo Header";
        ft: Record facturas_Timbradas;
        page: Page "Posted Sales Invoices";
        c: Codeunit codeUnitWS;
        CurrentDate: Date;
    begin

        c.Refresh();
        page.Update;

        sh.SetFilter(sh.UUIDHG, '');
        CurrentDate := Today();
        sh.SetFilter(sh."Posting Date", '%1..%2', CALCDATE('-30D', CurrentDate), CALCDATE('-0D', CurrentDate));

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
        CurrentDate: Date;
    begin
        c.Refresh();
        page.Update;

        scm.SetFilter(scm.UUIDNCHG, '');
        CurrentDate := Today();
        scm.SetFilter(scm."Posting Date", '%1..%2', CALCDATE('-30D', CurrentDate), CALCDATE('-0D', CurrentDate));


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
        c.calCImporteTrasladoNC();
    end;


    var
        c: Codeunit codeUnitWS;
}