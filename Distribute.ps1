Add-Type -AssemblyName System.IO.Compression.FileSystem;
Add-Type -AssemblyName System.Xml;

$AddonName = "AlmaBarcodeLookup"

$RootDirectory = Resolve-Path .
$OutputDirectory = Join-Path -Path $RootDirectory -ChildPath $AddonName;

if (Test-Path $OutputDirectory) {
    Write-Host -NoNewline "Removing existing temporary directory...";
    Remove-Item $OutputDirectory -Recurse
    Write-Host "Done";
}

Write-Host -NoNewline "Creating temporary output directory...";
$result = New-Item -ItemType Directory $OutputDirectory
Write-Host "Done";

$filesToInclude = @(
    "config.xml",
    "DataMapping.lua",
    "Utility.lua",
    "LookupUtility.lua",
    "Main.lua",
    "AlmaApi.lua",
    "AlmaLookup.lua",
    "WebClient.lua"
);

$filesToEncrypt = @(
);

Write-Host "Copying addon files..."
foreach ($file in $filesToInclude) {
    Write-Host -NoNewLine "Copying $file..."
    Copy-Item -Path $file -Destination $OutputDirectory
    Write-Host "Done"
}

Write-Host "Encrytping addon files...";
foreach ($file in $filesToEncrypt) {
    Write-Host -NoNewLine "Encrypting $file..."
    LuaEncryptionUtility.exe -f $file -o $OutputDirectory
    Write-Host "Done"
}

$config = Join-Path -Path $OutputDirectory -ChildPath "Config.xml"
$document = New-Object -TypeName System.Xml.XmlDocument
$document.Load($config);

$fileNodes = $document.SelectNodes("/Configuration/Files/File");

foreach ($node in $fileNodes) {
    $file = $node.InnerText

    if ($file -eq "LuaTest.lua") {
        Write-Host "Removing LuaTest from config"
        $null = $node.ParentNode.RemoveChild($node);
    }

    if ($filesToEncrypt -contains $file) {
        $node.InnerText = [System.IO.Path]::ChangeExtension($file, ".elf");
    }
}

$document.Save($config);

$Documentation = Join-Path -Path $RootDirectory -ChildPath "Readme.md"

if (Test-Path $Documentation) {
    Write-Host -NoNewline "Exporting documentation...";

    $DocumentationOutput = Join-Path -Path $RootDirectory -ChildPath "Readme.html"

    invoke-expression "multimarkdown.exe $Documentation > $DocumentationOutput"
    Start-Sleep -m 1000

    if (Test-Path $DocumentationOutput) {
        Copy-Item -Path $DocumentationOutput -Destination $OutputDirectory
        Write-Host "Done";
    }
    Else
    {
        Write-Host "ERROR. FILE NOT FOUND!";
    }

}

$Compression = [System.IO.Compression.CompressionLevel]::Optimal
$Source = $OutputDirectory
$Destination = Join-Path -Path $RootDirectory -ChildPath "$AddonName.zip"

if (Test-Path $Destination) {
    Write-Host -NoNewline "Removing existing archive...";
    Remove-Item $Destination -Recurse
    Write-Host "Done";
}

Write-Host -NoNewline "Creating archive...";
[System.IO.Compression.ZipFile]::CreateFromDirectory($Source,$Destination,$Compression,$true)
Write-Host "Done";

Write-Host -NoNewline "Removing temporary directory...";
Remove-Item $OutputDirectory -Recurse
Write-Host "Done";
