report 50516 HG_ReporteCFDI
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    //EnableExternalImages = true;
    WordLayout = 'Docs\HG_ReporteFacturasCFDI.docx';
    //EnableHyperlinks = true;

    dataset
    {

        dataitem(temporal; temporal)
        {
            column(getRec; getRec) { }

        }

        dataitem(facturas_Timbradas; facturas_Timbradas)
        {

            DataItemLinkReference = temporal;
            DataItemLink = Folio = field(getRec);
            column(CertificadoCadena; CertificadoCadena)
            {
            }
            column(RFCprovedor; "RFC provedor")
            {
            }
            column(Version; Version)
            {
            }

            column(Descripcion; Descripcion)
            {
            }
            column(Fecha; Fecha)
            {
            }
            column(FechaTimbrado; FechaTimbrado)
            {
            }
            column(Folio; Folio)
            {
            }
            column(FormaDePago; FormaDePago)
            {
            }
            column(IVA; IVA)
            {
            }
            column(Lugardeexpedicin; "Lugar de expedición")
            {
            }
            column(Metododepago; "Metodo de pago")
            {
            }
            column(Moneda; Moneda)
            {
            }
            column(NoCertificado; NoCertificado)
            {
            }
            column(NoCertificadoSAT; NoCertificadoSAT)
            {
            }
            column(Nombre; Nombre)
            {
            }
            column(NombreReceptor; NombreReceptor)
            {
            }
            column(QRString; "QR String")
            {
            }
            column(RFC; RFC)
            {
            }
            column(RegimenFiscal; "Regimen Fiscal")
            {
            }
            column(RfcReceptor; RfcReceptor)
            {
            }
            column(SelloDigitalCFD; SelloDigitalCFD)
            {
            }
            column(SelloSAT; SelloSAT)
            {
            }
            column(Subtotal; Subtotal)
            {
            }
            column(Total; Total)
            {
            }
            column(UUID; UUID)
            {
            }
            column(UUIDRelacionado; "UUID Relacionado")
            {
            }
            column(Tiporelacion; "Tipo relacion")
            {
            }

            column(UsoCFDI; UsoCFDI)
            {
            }
            column(id; id)
            {
            }
            column(tipoDeComprobante; tipoDeComprobante)
            {
            }

            column(TotalText; TotalText)
            {

            }
            column(TipoCambio; TipoCambio)
            {
            }
            column(CantidadLetra; CantidadLetra)
            {
            }
            column(DescuentoTotal; DescuentoTotal)
            {
            }


            column(temp; temp.blob) { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                eventHandler.DoGenerateBarcode(facturas_Timbradas."QR String", temp, facturas_Timbradas.UUID);
                CantidadLetra := cod.MakeRequest(TotalText, Moneda);
            end;

        }
        dataitem(Company_Information; "Company Information")
        {

            column(Name; Name) { }
            column(Address; Address) { }
            column(LugarDeExpedicion; "Post Code") { }
            column(RFCEmisor; "VAT Registration No.") { }
            column(RegimenFiscalEmisor; "SAT Tax Regime Classification") { }


        }

        dataitem("Cliente"; "Sales Invoice Header")
        {

            DataItemLinkReference = temporal;
            DataItemLink = "No." = field(getRec);

            column(OrderNo; "Order No.")
            {
            }

            column(UUID_Relation; "UUID Relation HG")
            {
            }

            column(CFDI_Relation; "CFDI Relation")
            {
            }

            column(BilltoAddress; "Bill-to Address")
            {
            }
            column(BilltoAddress2; "Bill-to Address 2")
            {
            }
            column(BilltoCity; "Bill-to City")
            {
            }
            column(BilltoCounty; "Bill-to County")
            {
            }
            column(BilltoName; "Bill-to Name")
            {
            }
            column(SelltoCountryRegionCode; "Sell-to Country/Region Code")
            {
            }
            column(BilltoPostCode; "Bill-to Post Code")
            {
            }

            column(BOL; BOL)
            {

            }
            column(PeriodoFact; PeriodoFact)
            {
            }
            column(ProductoTrasnportado; ProductoTrasnportado)
            {
            }
            column(Tanque; Tanque)
            {
            }

            column(aeropuerto; aeropuerto)
            {
            }
            column(WorkDescription; "Work Description")
            {
            }
            column(Remision; Remision)
            {
            }
            column(OrigenDestino; OrigenDestino)
            {
            }
            column(NoTanque; NoTanque)
            {
            }
            column(FechaDeEntrega; FechaDeEntrega)
            {
            }

            column(GetWorkDescription; GetWorkDescription)
            {
            }



        }

        dataitem(Conceptos; Conceptos)
        {

            DataItemLinkReference = temporal;
            DataItemLink = Folio = field(getRec);
            column(BaseTraslado; BaseTraslado)
            {
            }
            column(Cantidad; Cantidad)
            {
            }
            column(ClaveProdServ; ClaveProdServ)
            {
            }
            column(ClaveUnidad; ClaveUnidad)
            {
            }
            column(DescripcionConcepto; Descripcion)
            {
            }
            column(FolioConcepto; Folio)
            {
            }
            column(Importe; Importe)
            {
            }
            column(ImporteTraslado; ImporteTraslado)
            {
            }
            column(ImpuestoTraslado; ImpuestoTraslado)
            {
            }

            column(NoIdentificacion; NoIdentificacion)
            {

            }
            column(NoProducto; NoProducto)
            {
            }



            column(TasaOCuotaTraslado; TasaOCuotaTraslado)
            {
            }
            column(TipoFactor; TipoFactor)
            {
            }
            column(Unidad; Unidad)
            {
            }
            column(ValorUnitario; ValorUnitario)
            {
            }
            column(Descuento; Descuento)
            {
            }

        }
        dataitem(PedimentosTable; PedimentosTableHG)
        {

            DataItemLinkReference = temporal;
            DataItemLink = DocumentNo = field(DocNo);
            column(FechaDate; FechaDate)
            {
            }
            column(DocumentNo; DocumentNo)
            {
            }
            column(NombreAduana; NombreAduana)
            {
            }
            column(Pedimento; Pedimento)
            {
            }

        }


    }


    var
        num: text;
        tabla: Record temporal;
        temp: Record TempBlob temporary;
        eventHandler: Codeunit cuqr;
        cod: Codeunit codeUnitWS;

        NoProducto: Text;

}