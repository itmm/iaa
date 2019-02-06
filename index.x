# Instant ARM Assembly
* Ein Assembler mit benutzerfreundlicher Syntax
* Entwickelt mit `hex` in C++

```
D{file: iaa.cpp}
	e{parts}
x{file: iaa.cpp}
```
* Die C++ Datei besteht aus mehreren Teilen

```
d{parts}
	e{includes}
x{parts}
```
* Zuerst bindet das Programm die Header ein

```
a{parts}
	e{globals}
x{parts}
```
* Dann definiert es globale Elemente

```
a{parts}
	e{main}
x{parts}
```
* Und zum Schluss kommt das Haupt-Programm

```
d{main}
	int main(
		int argc, const char* argv[]
	) {
		e{main parts};
	}
x{main}
```
* Das Hauptprogramm ist ebenfalls in mehrere Teile aufgeteilt

```
d{main parts}
	e{process args};
x{main parts};
```
* Zuerst werden die Argumente der Kommandozeile ausgewertet

```
a{main parts}
	e{assemble};
x{main parts};
```
* Dann wird der Maschinen-Code aus den Sourcen erzeugt

```
a{main parts}
	e{create binary};
x{main parts};
```
* Und das fertige Executable erstellt

# Ein Fake-Executable erstellen
* Die allererste Implementierung generiert nur ein statisches Executable
* Das ist noch kein Assembler
* aber ein guter Ausgangspunkt, um die Test-Umgebung aufzusetzen

```
d{includes}
	#include <fstream>
x{includes}
```
* Mit der C++ Standard-Bibliothek erstellt der Assembler das Executable
* Er bindet dazu den notwendigen Header ein

```
d{create binary} {
	const char path[] = "a.out";
	std::ofstream out {path};
	e{write binary};
	e{set permissions};
} x{create binary}
```
* Zuerst ist sogar der Name des Executables vorgegeben
* Wie beim C-Compiler wird es `a.out` genannt
* Nach dem Schreiben des Executables müssen dessen Zugriffsrechte
  erweitert werden
* damit das System die Datei ausführen kann

```
a{includes}
	#include <experimental/filesystem>
	namespace fs =
		std::experimental::filesystem;
x{includes}
```
* Der Assembler ändert über die C++ Standard-Bibliothek die Rechte
* Leider ist dieser Teil noch als experimentell eingestuft
* Der Source-Code verwendet lange Namespace-Namen

```
d{set permissions}
	fs::permissions(path,
		fs::perms::add_perms |
			fs::perms::owner_exec
	);
x{set permissions}
```
* Der Assembler fügt das Ausführungs-Recht zu den bestehenden Rechten
  hinzu

```
d{write binary} {
	const char binary[] =
		e{binary data};
	out.write(binary, sizeof(binary) - 1);
} x{write binary}
```
* Die Datei besteht aus einem unübersichtlichen Hex-Dump
* Der Assembler hat die Aufgabe, diese Datei dynamisch zu erzeugen

```
d{binary data}
	"\x7f\x45\x4c\x46\x01\x01\x01\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x02\x00\x28\x00\x01\x00\x00\x00"
	"\x98\x00\x01\x00\x34\x00\x00\x00"
	"\x2c\x03\x00\x00\x00\x02\x00\x05"
	"\x34\x00\x20\x00\x02\x00\x28\x00"
	"\x07\x00\x06\x00\x01\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\x01\x00"
	"\x00\x00\x01\x00\xc4\x00\x00\x00"
	"\xc4\x00\x00\x00\x05\x00\x00\x00"
	"\x00\x00\x01\x00\x04\x00\x00\x00"
	"\x74\x00\x00\x00\x74\x00\x01\x00"
x{binary data}
```
* Teil 1

```
a{binary data}
	"\x74\x00\x01\x00\x24\x00\x00\x00"
	"\x24\x00\x00\x00\x04\x00\x00\x00"
	"\x04\x00\x00\x00\x04\x00\x00\x00"
	"\x14\x00\x00\x00\x03\x00\x00\x00"
	"\x47\x4e\x55\x00\xaf\xb3\x35\x0e"
	"\xea\x09\x46\x9e\x30\xf2\x2c\x18"
	"\xff\x21\xbe\x10\x02\xb9\xb7\x22"
	"\x04\x70\xa0\xe3\x01\x00\xa0\xe3"
	"\x10\x10\x8f\xe2\x0b\x20\xa0\xe3"
	"\x00\x00\x00\xef\x01\x70\xa0\xe3"
	"\x00\x00\xa0\xe3\x00\x00\x00\xef"
	"\x48\x61\x6c\x6c\x6f\x20\x57\x65"
x{binary data}
```
* Teil 2

```
a{binary data}
	"\x6c\x74\x0a\x00\x41\x1a\x00\x00"
	"\x00\x61\x65\x61\x62\x69\x00\x01"
	"\x10\x00\x00\x00\x05\x36\x00\x06"
	"\x06\x08\x01\x09\x01\x0a\x02\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x74\x00\x01\x00"
	"\x00\x00\x00\x00\x03\x00\x01\x00"
	"\x00\x00\x00\x00\x98\x00\x01\x00"
	"\x00\x00\x00\x00\x03\x00\x02\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x03\x00\x03\x00"
x{binary data}
```
* Teil 3

```
a{binary data}
	"\x01\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x04\x00\xf1\xff"
	"\x11\x00\x00\x00\x01\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\xf1\xff"
	"\x16\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\xf1\xff"
	"\x23\x00\x00\x00\x04\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\xf1\xff"
	"\x29\x00\x00\x00\x01\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\xf1\xff"
	"\x30\x00\x00\x00\x03\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\xf1\xff"
x{binary data}
```
* Teil 4

```
a{binary data}
	"\x35\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\xf1\xff"
	"\x3b\x00\x00\x00\x98\x00\x01\x00"
	"\x00\x00\x00\x00\x00\x00\x02\x00"
	"\x3e\x00\x00\x00\xb8\x00\x01\x00"
	"\x00\x00\x00\x00\x00\x00\x02\x00"
	"\x42\x00\x00\x00\x0b\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\xf1\xff"
	"\x4a\x00\x00\x00\xb8\x00\x01\x00"
	"\x00\x00\x00\x00\x00\x00\x02\x00"
	"\x4a\x00\x00\x00\xc3\x00\x01\x00"
	"\x00\x00\x00\x00\x00\x00\x02\x00"
x{binary data}
```
* Teil 5

```
a{binary data}
	"\x5c\x00\x00\x00\xc4\x00\x02\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
	"\x4d\x00\x00\x00\xc4\x00\x02\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
	"\x5b\x00\x00\x00\xc4\x00\x02\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
	"\x6c\x00\x00\x00\x98\x00\x01\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
	"\x67\x00\x00\x00\xc4\x00\x02\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
	"\x73\x00\x00\x00\xc4\x00\x02\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
x{binary data}
```
* Teil 6

```
a{binary data}
	"\x7b\x00\x00\x00\xc4\x00\x02\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
	"\x82\x00\x00\x00\xc4\x00\x02\x00"
	"\x00\x00\x00\x00\x10\x00\x02\x00"
	"\x00\x2f\x74\x6d\x70\x2f\x63\x63"
	"\x73\x50\x4b\x65\x44\x4c\x2e\x6f"
	"\x00\x65\x78\x69\x74\x00\x65\x78"
	"\x69\x74\x5f\x73\x75\x63\x63\x65"
	"\x73\x73\x00\x77\x72\x69\x74\x65"
	"\x00\x73\x74\x64\x6f\x75\x74\x00"
	"\x72\x65\x61\x64\x00\x73\x74\x64"
	"\x69\x6e\x00\x24\x61\x00\x6d\x73"
x{binary data}
```
* Teil 7

```
a{binary data}
	"\x67\x00\x6d\x73\x67\x5f\x6c\x65"
	"\x6e\x00\x24\x64\x00\x5f\x5f\x62"
	"\x73\x73\x5f\x73\x74\x61\x72\x74"
	"\x5f\x5f\x00\x5f\x5f\x62\x73\x73"
	"\x5f\x65\x6e\x64\x5f\x5f\x00\x5f"
	"\x5f\x62\x73\x73\x5f\x73\x74\x61"
	"\x72\x74\x00\x5f\x5f\x65\x6e\x64"
	"\x5f\x5f\x00\x5f\x65\x64\x61\x74"
	"\x61\x00\x5f\x65\x6e\x64\x00\x00"
	"\x2e\x73\x79\x6d\x74\x61\x62\x00"
	"\x2e\x73\x74\x72\x74\x61\x62\x00"
	"\x2e\x73\x68\x73\x74\x72\x74\x61"
x{binary data}
```
* Teil 8

```
a{binary data}
	"\x62\x00\x2e\x6e\x6f\x74\x65\x2e"
	"\x67\x6e\x75\x2e\x62\x75\x69\x6c"
	"\x64\x2d\x69\x64\x00\x2e\x74\x65"
	"\x78\x74\x00\x2e\x41\x52\x4d\x2e"
	"\x61\x74\x74\x72\x69\x62\x75\x74"
	"\x65\x73\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x1b\x00\x00\x00"
	"\x07\x00\x00\x00\x02\x00\x00\x00"
x{binary data}
```
* Teil 9

```
a{binary data}
	"\x74\x00\x01\x00\x74\x00\x00\x00"
	"\x24\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x04\x00\x00\x00"
	"\x00\x00\x00\x00\x2e\x00\x00\x00"
	"\x01\x00\x00\x00\x06\x00\x00\x00"
	"\x98\x00\x01\x00\x98\x00\x00\x00"
	"\x2c\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x04\x00\x00\x00"
	"\x00\x00\x00\x00\x34\x00\x00\x00"
	"\x03\x00\x00\x70\x00\x00\x00\x00"
	"\x00\x00\x00\x00\xc4\x00\x00\x00"
	"\x1b\x00\x00\x00\x00\x00\x00\x00"
x{binary data}
```
* Teil 10

```
a{binary data}
	"\x00\x00\x00\x00\x01\x00\x00\x00"
	"\x00\x00\x00\x00\x01\x00\x00\x00"
	"\x02\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\xe0\x00\x00\x00"
	"\x80\x01\x00\x00\x05\x00\x00\x00"
	"\x10\x00\x00\x00\x04\x00\x00\x00"
	"\x10\x00\x00\x00\x09\x00\x00\x00"
	"\x03\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x60\x02\x00\x00"
	"\x87\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x01\x00\x00\x00"
	"\x00\x00\x00\x00\x11\x00\x00\x00"
x{binary data}
```
* Teil 11

```
a{binary data}
	"\x03\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\xe7\x02\x00\x00"
	"\x44\x00\x00\x00\x00\x00\x00\x00"
	"\x00\x00\x00\x00\x01\x00\x00\x00"
	"\x00\x00\x00\x00"
x{binary data}
```
* Teil 12

# Platzhalter
* Noch leere Implementierung, um Warnungen zu verhindern

```
d{globals}
x{globals}
```
* Noch leere Implementierung, um Warnungen zu verhindern

```
d{process args}
x{process args}
```
* Noch leere Implementierung, um Warnungen zu verhindern

```
d{assemble}
x{assemble}
```
* Noch leere Implementierung, um Warnungen zu verhindern

