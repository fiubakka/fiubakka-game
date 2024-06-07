# Fiubakka Game
Trabajo profesional: Juego distribuido en Akka (Client)

## Game installation

Welcome to Fiubakka! If you'd like to play the game, simply follow the steps for your OS:

#### Windows
#### Quick start
- Install Cloudflare Daemon by running `setup.bat` once
- Play the game by running `play.bat`
#### Manual installation
- Download and install [cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/#1-download-and-install-cloudflared):
```powershell
winget install --id Cloudflare.cloudflared
```
- Download Fiubakka
- Before running the game, start the cloudflared tunnel:
```powershell
cloudflared access tcp --hostname fiubakka.marcosrolando.uk --url 127.0.0.1:2020
```
- Play the game by running `fiubakka.exe`

#### Linux
#### Quick start
- For installation, run `setup.sh` once. This will download and install the Cloudflare Daemon (`cloudflared`) on your system
- Run `play.sh` and start playing!

#### Manual installation
Alternatively, you can run the steps manually

- Download and install [cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/#1-download-and-install-cloudflared):
```bash
# Add cloudflare gpg key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add this repo to your apt repositories
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
sudo apt-get update && sudo apt-get install cloudflared
```
- Download Fiubakka
- Before running the game, start the cloudflared tunnel:
```bash
cloudflared access tcp --hostname fiubakka.marcosrolando.uk --url 127.0.0.1:2020
```
- Run the game on another terminal:
```bash
./fiubakka
```

## Dependencies

* [godot](https://godotengine.org/download/archive/4.1.3-stable/)

## How to run the client

First, the godot executable needs to be added to $PATH. To do that you can run the following commands (/usr/bin is just an example. You can use any folder present in $PATH)

  ```console
> sudo cp Godot_v4.1.3-stable_linux.x86_64 /usr/bin
> sudo mv Godot_v4.1.3-stable_linux.x86_64 godot
```

After cloning the repository, the protobuf submodule needs to be updated using the command:
`git submodule update --recursive --remote`

That brings all the .proto files from another repository, but before using them they need to be compiled by running the following command: `./godbuf-compile.sh`

Once the server is running, you can start the client by running the command `godot` on the root directory. If you want to open the godot ide, you can add the `-e` parameter.

## Exporting the project

### Windows / Linux

To export the project as an executable file (either a Windows `.exe` file or a Linux executable binary), you will first need to download the required Export Template. 
From the `Editor` menu, go to `Manage Export Templates`, select `Official GitHub Releases mirror` from the `Download from` dropdown and click `Download and Install`.

![Export Template Manager Menu](docs/Godot_v4.2.1-stable_win64_03kHSVtMJj.png)

After the Export Template installation is finished, close the Export Template Manager and open the Export menu from `Project` > `Export`. From the Export menu, click Add and select your target platform. In this example we will choose `Windows Desktop`, but this guide works for `Linux/X11` as well.

![Export Menu](docs/Godot_v4.2.1-stable_win64_jn7nknKCvo.png)

This will create a new preset using the previously installed Export Template. 
Under the `Options` tab, in the `Application` section, you can complete project information such as the version, company name, game name, etc.
Next, check that the `Embed PCK` option is checked, under the `Binary Format` section.

![Embed PCK](docs/Godot_v4.2.1-stable_win64_S3QO2GvKky.png)

Finally, choose a destination directory (for example `/exported`), name your executable file and click `Save` to export the project. 

![Export file](docs/image.png)

**Note** the `Export with Debug` checkbox. When checked, the project will be exported with an output console which helps with debugging. In most cases, it should be unchecked


### CLI
You can also export the project if you previously setup both the Godot CLI and the export presets. Simply run the `build.sh` bash script from your terminal like so:
```bash
$ build.sh <preset> <exported_name> <version>
```
`preset` is the name of your installed export presets, and should be either "Linux/X11" or "Windows"

`exported_name` is an optional argument which defined the executable file name. If not provided, it will be exported as `fiubakka`

`version` is an optional value which will be appended to the executable file name. For example if you run `build.sh Linux/X11 fiubakka 3` you will generate the executable `exported/fiubakka-3`

## Localization

Localized text is kept in `translations/translations.csv`. It has the following structure:


|keys|<lang_1>|<lang_2>|...|
| --- | --- | --- | --- |
|GREETING|Hello!|Hola!|...|
|GAME_OVER|Game over|Fin del juego|...|

Where the column `keys` contains the label tag of the localized text and the `lang_x` columns contain the 
corresponding translations for every defined language. For example, `lang_1` could be `en` (English) and `lang_2` could be `es` (Spanish). The locale column name has to be one of the [supported locale codes](https://docs.godotengine.org/en/stable/tutorials/i18n/locales.html)

To avoid errors when using commas, line breaks, double quotes or other special characters, remember to wrap a translation in quotes `"`.

When you add, remove or modify a translation, you need to import (or re-import) the translation file from the editor, under the Import tab:

![locale import](docs/locale-import.png)

Once imported, Godot will generate new `.translation` files for every defined locale in the `csv` files. You will then need to add them from the `Localization` settings:

![adding locales](docs/adding-locales.png)

Lastly, configure your testing locale from the project settings to the locale you wish to test:

![locale project settings](docs/locale-project-settings.png)


In short, everytime you add or modify a translation you have to:
- edit `translations.csv`
- re-import the translations csv file from the editor

For more details on locales in Godot:
- [Importing translations](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_translations.html)
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html)
- [Supported locale codes](https://docs.godotengine.org/en/stable/tutorials/i18n/locales.html)


