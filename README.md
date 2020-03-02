# Alma Barcode Lookup Addon

## Versions

**1.1 -** Added new default mappings to the DataMapping.lua

**1.0 -** Initial release

## Summary
An Alma Barcode Lookup Addon that uses a barcode to perform an Alma API item lookup and imports the data returned into Ares, Aeon, and ILLiad.

## Settings

> **Alma API URL:** The URL to the Alma API.
>
> **Alma API Key:** API key used for interacting with the Alma API.
>
> **Allow Overwrite with Blank Value:** If turned on, empty values from the API response will overwrite any existing data. *Note:* Non-empty responses will always overwrite existing data.
>
>**Fields to Import:** This is a comma separated lists of the fields to import from the API response into the current product. The name of each field corresponds to the `MappingName` located in the `DataMapping.lua` file.
>The default fields to import are *CallNumber, ISXN, Title, Author, Edition, Place, Pages, and Publisher*. See the *Data Mappings*  or *FAQ* section of the documentation for more details.
>
>**Field to Perform Lookup With:** This is the field in which the barcode is read from. You may specify a custom field or leave it as `{Default}` which will use the field outlined in `DataMapping.lua`. The first value is the table in the database and the second value is the column.
>*Examples: {Default} (uses the field outlined in the DataMapping), Item.ItemBarcode, Transaction.ItemInfo1, or Transaction.Location*

## Buttons
The buttons for the Alma Barcode Lookup Addon are located in the *"Barcode Lookup"* ribbon in the top left of the requests.

>**Import By Barcode:** Currently, the only button in the Alma Barcode Lookup Addon. When clicked, it will use the provided barcode to make an Item Alma API call using the item's barcode.

## Data Mappings
Below are the default data mappings from the API response to Ares, Aeon, and ILLiad and the default location of the barcodes for each product. These data mappings can be changed in the `DataMapping.lua` file.

### Default Barcode Fields
| Product DataMapping                       | Location              |
|-------------------------------------------|-----------------------|
| DataMapping.BarcodeFieldMapping["Ares"]   | Item.ItemBarcode      |
| DataMapping.BarcodeFieldMapping["ILLiad"] | Transaction.ItemNumber|
| DataMapping.BarcodeFieldMapping["Aeon"]   | Transaction.ItemNumber|

#### Columns
>**Mapping Name:** Used to identify the mapping. The `Fields to Import` setting lists the *Mapping Names* for the addon to import.
>
>**Import Field:** The Ares, Aeon, or ILLiad field the API response item maps to. The first value is the table the field maps to and the second value is the desired column in the specified table.
>
>**Object Type:** Object type is the name of the response type from the API response.
>
>**Object Mapping:** The XML node name of the data you wish to import.

### Ares
| Mapping Name |  Import Field   | Object Type |               Object Mapping                |
| ------------ | --------------- | ----------- | ------------------------------------------- |
| CallNumber   | Item.Callnumber | item        | call_number                                 |
| ISXN         | Item.ISXN       | item        | issn                                        |
| ISXN         | Item.ISXN       | item        | isbn                                        |
| Title        | Item.Title      | item        | title              |
| Author       | Item.Author     | item        | author             |
| Edition      | Item.Edition    | item        | complete_edition            |
| Place        | Item.PubPlace   | item        | place_of_publication |
| Pages        | Item.PageCount  | item        | pages         |
| Publisher    | Item.Publisher  | item        | publisher_const          |
| Location     | Item.ShelfLocation | item     | location |
| PubDate      | Item.PubDate    | item        | `date_of_publication` |


### ILLiad
>***Note:*** Because ILLiad supports multiple request types, separate mappings to both *Loan* and *Article* can be provided to the appropriate fields.

| Mapping Name | Request Type |          Import Field          | Object Type |        Object Mapping         |
| ------------ | ------------ | ------------------------------ | ----------- | ----------------------------- |
| Author       | Loan         | Transaction.LoanAuthor         | item        | author                        |
| Author       | Article      | Transaction.PhotoItemAuthor    | item        | author                        |
| ISXN         | Both         | Transaction.ISSN               | item        | issn                          |
| ISXN         | Both         | Transaction.ISSN               | item        | isbn                          |
| Edition      | Loan         | Transaction.LoanEdition        | item        | complete_edition              |
| Edition      | Article      | Transaction.PhotoItemEdition   | item        | complete_edition              |
| Pages        | Both         | Transaction.Pages              | item        | pages                         |
| Place        | Loan         | Transaction.LoanPlace          | item        | place_of_publication          |
| Place        | Article      | Transaction.PhotoItemPlace     | item        | place_of_publication          |
| Publisher    | Loan         | Transaction.LoanPublisher      | item        | publisher_const               |
| Publisher    | Article      | Transaction.PhotoItemPublisher | item        | publisher_const               |
| Title        | Loan         | Transaction.LoanTitle          | item        | title         |
| Title        | Article      | Transaction.PhotoJournalTitle  | item        | title |
| CallNumber   | Both         | Transaction.CallNumber         | item        | call_number                   |

### Aeon
| Mapping Name |       Import Field        | Object Type |    Object Mapping    |
| ------------ | ------------------------- | ----------- | -------------------- |
| Title        | Transaction.ItemTitle     | item        | title                |
| Author       | Transaction.ItemAuthor    | item        | author               |
| ISXN         | Transaction.ItemISxN      | item        | issn                 |
| ISXN         | Transaction.ItemISxN      | item        | isbn                 |
| Publisher    | Transaction.ItemPublisher | item        | publisher_const      |
| Pages        | Transaction.ItemPages     | item        | pages                |
| CallNumber   | Transaction.CallNumber    | item        | call_number          |
| Place        | Transaction.ItemPlace     | item        | place_of_publication |
| Edition      | Transaction.ItemEdition   | item        | complete_edition     |

## FAQ

### How to change the field that the barcode is read from?
The setting that determines the field that the barcode is read from is located in the addon's settings as `"Field to Perform Lookup With"`. It takes in the word `{Default}` or the table name and the column name separated by a `'.'`.

By default it is `{Default}` which tells the addon to get the field from the `DataMapping.lua` file.

### How to change the mappings of an API Lookup Response to Aeon, Ares, or ILLiad's field?
To modify the mappings in this addon, you must edit the `DataMapping.lua` file. Each mapping is an entry on the `DataMapping.FieldMapping[Product Name]` table.

*Example data mapping table:*
```lua
DataMapping.FieldMapping["Ares"] = {};
table.insert(DataMapping.FieldMapping["Ares"], {
    MappingName = "CallNumber",
    ImportField = "Item.Callnumber",
    ObjectType = "item",
    ObjectMapping = "call_number"
});
```

To modify the Aeon, Ares, or ILLiad field the API response item will go into, change the `ImportField` value to desired field. The ImportField formula is `"{Table Name}.{Column Name}"`.

To modify the API response item to go into a particular Aeon, Ares, or ILLiad field, change the `ObjectMapping` value to the desired API XML node name.

### How to change a mapping's name?
The mapping names can be modified to fit the desired use case. Just change the `MappingName` value to the desired name and be sure to include the new `MappingName` value in the `"Fields to Import"` setting, so the addon knows to import that particular mapping.

### How to change Default Barcode Field?
The default barcode field is defined in the `DataMapping.BarcodeFieldMapping[{Product}]` table within the `DataMapping.lua` file. To change the mapping, modify the respective variable to the `"{Table}.{Column}"` of the new field to be mapped to.
