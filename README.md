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