# Latest cjxl
$downloadUrl = "https://github.com/libjxl/libjxl/releases/latest/download/jxl-x64-windows-static.zip"

# Задаем путь, куда будет загружен архив
$downloadPath = "$env:TEMP\libjxl.zip"

# Задаем путь, куда будет распакован архив
$extractPath = "./jxl"

# Задаем путь к cjxl.exe
$cjxlPath = Join-Path -Path $extractPath -ChildPath "cjxl.exe"

# 1. Загрузка последней версии cjxl
Write-Host "Загрузка cjxl..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

# 2. Распаковка архива
Write-Host "Распаковка архива..."
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
Remove-Item -Path $downloadPath -Force


# Задаем путь к папке, в которой нужно искать файлы
$sourceDir = "./"

# Задаем путь к папке, куда будут сохранены файлы в формате .jpeg-xl
$destinationDir = "./Converted"

# Создаем папку назначения, если она не существует
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir
}

# Получаем список всех .jpg и .jpeg файлов в исходной папке
$jpgFiles = Get-ChildItem -Path $sourceDir -Include *.jpg, *.jpeg -File -Recurse

# Проходимся по каждому файлу и конвертируем его в .jpeg-xl
foreach ($file in $jpgFiles) {
    $sourceFilePath = $file.FullName
    $destinationFilePath = Join-Path -Path $destinationDir -ChildPath ($file.BaseName + ".jxl")

    # Команда для конвертации
    $command = "./jxl/cjxl.exe `"$sourceFilePath`" `"$destinationFilePath`""

    # Выполняем команду
    Invoke-Expression -Command $command
    Write-Host "Конвертация завершена: $sourceFilePath -> $destinationFilePath"
}

Write-Host "Все файлы успешно конвертированы."

