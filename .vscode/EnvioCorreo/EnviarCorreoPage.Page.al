page 60108 EnviarCorreoPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = EnviarCorreoTable;
    CaptionML = ENG = 'Send by Email', ESP = 'Envio por correo electrónico';
    Editable = true;

    layout
    {
        area(Content)
        {
            group("Enviar correo electrónico")
            {
                group("Datos del correo")
                {
                    field(Para; Para)
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field(Cc; Cc)
                    {
                        ApplicationArea = all;
                        ToolTipML = ENG = 'For add more emails use ; at the end of each. Example: firstmail@mail.com;secondmail@mail.com', ESP = 'Pare agregar mas destinatarios usa ; al final de cada email, ejemplo: primermail@mail.com;segundomail@mail.com';
                    }
                    field(CCo; CCo)
                    {
                        ApplicationArea = all;

                    }
                    field(Asunto; Asunto)
                    {
                        ApplicationArea = all;
                    }
                    field(Archivo; Archivo)
                    {
                        ApplicationArea = all;
                        ShowMandatory = true;
                    }
                    field(TipoContenido; TipoContenido)
                    {
                        ApplicationArea = all;
                        ShowMandatory = true;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            if TipoContenido = 2 then begin
                                state := false;
                            end else begin
                                state := true
                            end;
                        end;
                    }
                    field(Cuerpo; Cuerpo)
                    {
                        ApplicationArea = all;
                        Enabled = state;
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Enviar Factura")
            {
                Image = SendMail;
                ApplicationArea = All;
                Promoted = true;
                CaptionML = ENU = 'Send Email', ESP = 'Enviar correo';
                PromotedCategory = Process;
                trigger OnAction()
                var
                    class: Codeunit 397;
                    eventos: Codeunit ControlEventos;
                    answer: Boolean;
                begin

                    if rec.tipo = 'fac' then begin
                        eventos.envioCorreo(Cliente, Factura, "Entry No");
                    end;

                    if rec.tipo = 'nc' then begin
                        eventos.envioCorreoNC(Cliente, Factura);
                    end;

                    answer := Dialog.Confirm('Desea salir?', true);
                    if answer = true then begin
                        CurrPage.Close();
                    end
                    else begin
                        Rec.Para := '';
                        Rec.Cc := '';
                        Rec.CCo := '';
                        Rec.Asunto := '';
                        Rec.Archivo := 0;
                        Rec.Cuerpo := '';
                        rec.TipoContenido := 0;
                    end;
                end;
            }


        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
    end;

    var
        myInt: Integer;

        state: Boolean;
}
