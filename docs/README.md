# GOA systems documentation example

## Requirements

The following list contains the required dependencies to execute this examples `build.ps1`.

* [MiKTeX](https://miktex.org) - with pdflatex package
* [Pandoc](https://pandoc.org)
* [Eisvogel document template](https://github.com/Wandmalfarbe/pandoc-latex-template)
* [MkDocs](https://www.mkdocs.org)
* [Python](https://www.python.org)

## Installing prerequisites

### MiKTeX

![Confirm licence conditions](img/miktex_1.png)

Choose installation for current user only. This avoids providing administrator credentials.

![Install MiKTeX for current user](img/miktex_2.png)

![Specify installation directory](img/miktex_3.png)

![Select paper size and format](img/miktex_4.png)

![Review Installation](img/miktex_5.png)

![Installation process](img/miktex_6.png)

![Continue installation](img/miktex_7.png)

![Select to check for updates](img/miktex_8.png)

![Finish installation](img/miktex_9.png)

After the installation open the installed application.

![ Launch MiKTeX console](img/miktex_10.png)

Follow the screenshots to update the installed and install the required packages.

![Update hint](img/miktex_11.png)

![Start update checks](img/miktex_12.png)

![Switch to update view and install updates](img/miktex_13.png)

![Update process](img/miktex_14.png)

![Search and install "pdflatex" package.](img/miktex_15.png)

![Confirmation](img/miktex_16.png)

![Installation progress](img/miktex_17.png)

During usage dialogs like the following two might come up. This means that additional packages have to be installed. The first one is suitable for single packages to keep the overview what needs to be installed. The second one is for batch installations. Just uncheck "Always show this dialog" for automated package installation.

![Confirm installation of additional packages](img/miktex_18.png)

![Remove checkmark to enable automatic installation](img/miktex_19.png)

### Pandoc

Installation of Pandoc is easier. It gets automatically installed into the directory:

```
%LocalAppData%\Pandoc
```

Also the users %PATH% variable gets set to make it available on the command line.

![Pandoc installation](img/pandoc_1.png)

![Finishing Pandoc installation](img/pandoc_1.png)

#### Eisvogel template

Download and extract the template from the [releases page](https://github.com/Wandmalfarbe/pandoc-latex-template/releases), extract the zip file and copy the template to the following location:

```
"%AppData%\pandoc\templates\eisvogel.latex"
```

### Python (required to install MkDocs)

Download and install Python from the [distributions download page](https://www.python.org/downloads).

![Python download](img/python_1.png)

![Installation start screen](img/python_2.png)

![Select features](img/python_3.png)

![Specify install location](img/python_4.png)

![Updating pip to the latest version](img/python_5.png)

#### MkDocs