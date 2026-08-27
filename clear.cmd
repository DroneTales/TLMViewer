del /s /q build\*.exe
del /s /q build\*.dcu
del /s /q source\__history\*.~*
del /s /q source\__recovery\*.*

rd source\__history
rd source\__recovery
