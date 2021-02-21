# Swashbuckle-CLI-Node-.NET-SDK

A set of bash scripts to build variations of .NET SDK, Node and Swashbuckle CLI docker images

---

### Using the images

You can use the prebuilt images as base images for your images, the tag follow this format:

```Dockerfile
FROM shkarface/shkarface/swashbuckle-cli-node-dotnet:SWASHBUCKLE-NET-NODE
```

This will use the image with:

    Node 14.x
    .NET SDK 5.0
    Swashbuckle v6.0.7

```Dockerfile
FROM shkarface/shkarface/swashbuckle-cli-node-dotnet:6.0.7-net3.1-node14.x
```

---

### Building locally

To build all the image variations locally, run:

```shell
./src/build-all.sh
```

You can build a specific variation using:

```shell
./src/build.sh \
    --net DOTNET_VERSION \
    --node NODE_VERSION \
    --swashbuckle SWASHBUCKLE_VERSION
```

To see a list of all available options for both scripts:

```shell
./src/build.sh --help
./src/build-all.sh --help
```
