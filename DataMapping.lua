DataMapping = {};
DataMapping.FieldMapping = {};

-- Icon Mapping
DataMapping.ClientImage = {};
DataMapping.ClientImage["Ares"] = "Search32";
DataMapping.ClientImage["ILLiad"] = "Search32";
DataMapping.ClientImage["Aeon"] = "srch_32x32";

-- Barcode Field Mapping
DataMapping.BarcodeFieldMapping = {};
DataMapping.BarcodeFieldMapping["Ares"] = "Item.ItemBarcode";
DataMapping.BarcodeFieldMapping["ILLiad"] = "Transaction.ItemNumber";
DataMapping.BarcodeFieldMapping["Aeon"] = "Transaction.ItemNumber";

--Ares Field Mapping
DataMapping.FieldMapping["Ares"] = {};
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "CallNumber",
    ImportField = "Item.Callnumber",
    ObjectType = "item",
    ObjectMapping = "call_number"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "ISXN",
    ImportField = "Item.ISXN",
    ObjectType = "item",
    ObjectMapping = "issn"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "ISXN",
    ImportField = "Item.ISXN",
    ObjectType = "item",
    ObjectMapping = "isbn"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "Title",
    ImportField = "Item.Title",
    ObjectType = "item",
    ObjectMapping = "title"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "Author",
    ImportField = "Item.Author",
    ObjectType = "item",
    ObjectMapping = "author"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "Edition",
    ImportField = "Item.Edition",
    ObjectType = "item",
    ObjectMapping = "complete_edition"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "Place",
    ImportField = "Item.PubPlace",
    ObjectType = "item",
    ObjectMapping = "place_of_publication"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "Pages",
    ImportField = "Item.PageCount",
    ObjectType = "item",
    ObjectMapping = "pages"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "Publisher",
    ImportField = "Item.Publisher",
    ObjectType = "item",
    ObjectMapping = "publisher_const"
});

-- New Ares field addition : 2-27-2020 --
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "Location",
    ImportField = "Item.ShelfLocation",
    ObjectType = "item",
    ObjectMapping = "location"
});
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "PubDate",
    ImportField = "Item.PubDate",
    ObjectType = "item",
    ObjectMapping = "date_of_publication"
});
-- End new Ares field addition : 2-27-2020 --

-- ILLiad Field Mapping
DataMapping.FieldMapping["ILLiad"] = {};
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "Author",
    ImportField = {
        RequestType = {
            Loan = "Transaction.LoanAuthor",
            Article = "Transaction.PhotoItemAuthor"
        }
    },
    ObjectType = "item",
    ObjectMapping = "author"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "ISXN",
    ImportField = "Transaction.ISSN",
    ObjectType = "item",
    ObjectMapping = "issn"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "ISXN",
    ImportField = "Transaction.ISSN",
    ObjectType = "item",
    ObjectMapping = "isbn"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "ArticleAuthor",
    ImportField = {
        RequestType = {
            Article = "Transaction.PhotoArticleAuthor"
        }
    },
    ObjectType = "item",
    ObjectMapping = "BibliographicDescription.AuthorOfComponent"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "Edition",
    ImportField = {
        RequestType = {
            Loan = "Transaction.LoanEdition",
            Article = "Transaction.PhotoItemEdition"
        }
    },
    ObjectType = "item",
    ObjectMapping = "complete_edition"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "Pages",
    ImportField = "Transaction.Pages",
    ObjectType = "item",
    ObjectMapping = "pages"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "Place",
    ImportField = {
        RequestType = {
            Loan = "Transaction.LoanPlace",
            Article = "Transaction.PhotoItemPlace"
        }
    },
    ObjectType = "item",
    ObjectMapping = "place_of_publication"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "Publisher",
    ImportField = {
        RequestType = {
            Loan = "Transaction.LoanPublisher",
            Article = "Transaction.PhotoItemPublisher"
        }
    },
    ObjectType = "item",
    ObjectMapping = "publisher_const"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "Title",
    ImportField = {
        RequestType = {
            Loan = "Transaction.LoanTitle",
            Article = "Transaction.PhotoJournalTitle"
        }
    },
    ObjectType = "item",
    ObjectMapping = "title"
});
table.insert(DataMapping.FieldMapping["ILLiad"], {
    MappingName = "CallNumber",
    ImportField = "Transaction.CallNumber",
    ObjectType = "item",
    ObjectMapping = "call_number"
});

-- Aeon Field Mapping
DataMapping.FieldMapping["Aeon"] = {};
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "Title",
    ImportField = "Transaction.ItemTitle",
    ObjectType = "item",
    ObjectMapping = "title"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "Author",
    ImportField = "Transaction.ItemAuthor",
    ObjectType = "item",
    ObjectMapping = "author"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "ISXN",
    ImportField = "Transaction.ItemISxN",
    ObjectType = "item",
    ObjectMapping = "issn"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "ISXN",
    ImportField = "Transaction.ItemISxN",
    ObjectType = "item",
    ObjectMapping = "isbn"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "Publisher",
    ImportField = "Transaction.ItemPublisher",
    ObjectType = "item",
    ObjectMapping = "publisher_const"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "Pages",
    ImportField = "Transaction.ItemPages",
    ObjectType = "item",
    ObjectMapping = "pages"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "CallNumber",
    ImportField = "Transaction.CallNumber",
    ObjectType = "item",
    ObjectMapping = "call_number"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "Place",
    ImportField = "Transaction.ItemPlace",
    ObjectType = "item",
    ObjectMapping = "place_of_publication"
});
table.insert(DataMapping.FieldMapping["Aeon"], {
    MappingName = "Edition",
    ImportField = "Transaction.ItemEdition",
    ObjectType = "item",
    ObjectMapping = "complete_edition"
});
