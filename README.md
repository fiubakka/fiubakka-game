# trabajo-profesional-akka-client
Trabajo profesional: Juego distribuido en Akka (Client)

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

### Windows

To export the project as a Windows `.exe` file, you will first need to download the required Export Template. 
From the `Editor` menu, go to `Export Template Manager`, select `Official GitHub Releases mirror` from the `Download from` dropdown and click `Download and Install`.

![Export Template Manager Menu](docs/Godot_v4.2.1-stable_win64_03kHSVtMJj.png)

After the Export Template installation is finished, close the Export Template Manager and open the Export menu from `Project` > `Export`. From the Export menu, click Add and select `Windows Desktop`

![Export Menu](docs/Godot_v4.2.1-stable_win64_jn7nknKCvo.png)

This will create a new preset using the previously installed Export Template. 
Under the `Options` tab, in the `Application` section, you can complete project information such as the version, company name, game name, etc.
Next, check that the `Embed PCK` option is checked, under the `Binary Format` section.

![Embed PCK](docs/Godot_v4.2.1-stable_win64_S3QO2GvKky.png)

Finally, choose a destination directory (for example `/exported`), name your executable file and click `Save` to export the project. 

![Export file](docs/image.png)

**Note** the `Export with Debug` checkbox. When checked, the project will be exported with an output console which helps with debugging. In most cases, it should be unchecked

