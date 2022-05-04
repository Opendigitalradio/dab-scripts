# Introduction
[Docker](https://www.docker.com) packages software into standardized units for development, shipment and deployment.

With Docker, you can run the ODR-mmbTools regardless of the operating system you are using, such as Windows, MacOS, *BSD or any non-Debian Linux.

# One-time setup
1. Install Docker on the host that will run the containers
1. Clone this repository or copy the dab-scripts/docker directory on the host
1. Adapt file `config/odr-dabmod.ini` to match your transceiver hardware and local RF spectrum
1. Adapt file `odr.env` to suit your configuration. Then run the following command:
    ```
    source odr.env
    ```

# Customized setup (changing the sample configuration)
1. Adapt file `config/ODR-encoders.conf` to suit your needs
1. Adapt file `config/odr-dabmux.info` to match the content of file `config/ODR-encoders.conf`
1. Adapt the structure of directory `config/mot` to match the content of file `config/ODR-encoders.conf`

# Operations
1. Create a docker volume, named `odr` with the configuration files:
    ```
    docker run \
        --interactive \
        --tty \
        --rm \
        --volume $(pwd)/config:/mnt/source \
        --volume odr:/mnt/dest \
        ubuntu:22.04 \
        bash -c "cd /mnt/source ; cp -R * /mnt/dest"
    ```
1. Start broadcasting the DAB/DAB+ ensemble (3 containers, named `odr-encoders`, `odr-dabmux` and `odr-dabmod`)
    ```
    docker compose up --detach
    ```
1. Stop broadcasting the DAB/DAB+ ensemble
    ```
    docker compose down
    ```
