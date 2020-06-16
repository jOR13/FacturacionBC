codeunit 50504 getStamp
{

    Permissions = TableData 112 = rimd;



    [EventSubscriber(ObjectType::Page, page::"Posted Sales Invoices", 'OnOpenPageEvent', '', true, true)]
    local procedure timbradas()
    var
        sh: Record "Sales Invoice Header";
        ft: Record facturas_Timbradas;
        page: Page "Posted Sales Invoices";
        c: Codeunit codeUnitWS;
        CurrentDate: Date;
    begin

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
                end else begin
                    c.Refresh();
                    page.Update;
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
        sh: Record "Sales Cr.Memo Header";
        ft: Record NCTimbradas;
        page: Page "Posted Sales Credit Memos";
        c: Codeunit GetJsonNC;
        CurrentDate: Date;
    begin
        sh.SetFilter(sh.UUIDNCHG, '');
        CurrentDate := Today();
        sh.SetFilter(sh."Posting Date", '%1..%2', CALCDATE('-30D', CurrentDate), CALCDATE('-0D', CurrentDate));
        /*
                sh.SetFilter(sh.UUIDRelacionadoNC, '');
                if sh.FindSet() then begin
                    repeat begin
                        if ft.FindSet() then begin
                            repeat begin
                                if sh."Applies-to Doc. No." = ft.Folio then begin
                                    sh.UUIDRelacionadoNC := ft.UUID;
                                    sh.Modify();
                                end;
                            end until ft.Next() = 0;
                        end;
                    end until sh.Next() = 0;
                end;
        */

        //sh.SetFilter(sh.UUIDNCHG, '');

        if sh.FindSet() then begin
            repeat begin
                if ft.FindSet() then begin
                    repeat begin
                        if sh."No." = ft.Folio then begin
                            sh.UUIDNCHG := ft.UUID;
                            if sh."Applies-to Doc. No." = ft.Folio then begin
                                sh.UUIDRelacionadoNC := ft.UUID;
                                sh.Modify();
                            end;
                        end;
                    end until ft.Next() = 0;
                end else begin
                    c.Refresh();
                    page.Update;
                end;
            end until sh.Next() = 0;
        end;


    end;


    var
        myInt: Integer;
}