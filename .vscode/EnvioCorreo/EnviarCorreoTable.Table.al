table 60113 EnviarCorreoTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Index; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; Para; Text[250])
        {
            Caption = 'Para';
            DataClassification = ToBeClassified;
        }
        field(3; Cc; Text[250])
        {
            Caption = 'Cc';
            DataClassification = ToBeClassified;
        }
        field(4; CCo; Text[250])
        {
            Caption = 'CCo';
            DataClassification = ToBeClassified;
        }
        field(5; Asunto; Text[250])
        {
            Caption = 'Asunto';
            DataClassification = ToBeClassified;
        }
        field(6; Archivo; Option)
        {
            Caption = 'Archivo adjunto';
            DataClassification = ToBeClassified;
            OptionMembers = "",xmlYpdf,PDF,XML;
            OptionCaption = ' ,XML y PDF,PDF,XML';
            Editable = true;
        }
        field(7; Cuerpo; Text[250])
        {
            Caption = 'Contenido personalizado';
            DataClassification = ToBeClassified;
        }
        field(8; Cliente; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header"."Bill-to Customer No.";
        }
        field(9; TipoContenido; Option)
        {
            Caption = 'Contenido del mensaje';
            DataClassification = ToBeClassified;
            OptionMembers = "","Mensaje personalizado","Plantilla del cuerpo del correo electrónico del remitente";
            OptionCaption = ' ,Mensaje personalizado, Plantilla del cuerpo del correo electrónico del remitente';
            Editable = true;
        }
        field(10; Factura; text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(11; PDF; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(12; PDFName; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; importe; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; IsCreditNote; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(16; tipo; text[30])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(pk; Cliente)
        {
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
