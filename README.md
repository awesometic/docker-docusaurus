# docker-docusaurus

![](https://img.shields.io/badge/multiarch-amd64(x86__64)%2C%20arm64%2C%20armv7%2C%20armv6-lightgrey?style=flat-square)
![](https://img.shields.io/github/workflow/status/awesometic/docker-docusaurus/buildx?style=flat-square)

![](https://img.shields.io/docker/image-size/awesometic/docusaurus/latest?style=flat-square)
![](https://img.shields.io/docker/pulls/awesometic/docusaurus?style=flat-square)
![](https://img.shields.io/docker/stars/awesometic/docusaurus?style=flat-square)

## What is Docusaurus

I'd like to quote the [official website](https://docusaurus.io/).
> Docusaurus makes it easy to maintain Open Source documentation websites.

## What this project provided for

I hope this project would be useful for those who uses docker for building their server.

## Features

### Core packages

I chose Alpine Linux for make it a **light-weight** service.
And I did choose node-alpine as its base image for the sake of some tweaks of Node.js version.

So this is composed of,

* Alpine Linux 3.14
* Node.js 16.7.0

with,

* The latest Docusaurus 2 beta comes with automatic updating

### Docusaurus 2

This image runs Docusaurus 2 beta instead of stable Docusaurus 1. Docusaurus 2 is developing very actively currently, so I hope that will be released in the near future.

![homepage](docs/docusaurus2_homepage.png)

I saw that there will be some migration jobs needed when a user upgrades their Docusarus 1 to the new Docusaurus 2. So, at this moment I think it is reasonable to use Docusaurus 2 for those who about to start constructing their own website.

But, officially, as this is an beta version yet, I put a automatic update trigger into this image. This can be disabled by setting environment variable like `AUTO_UPDATE=false`. By default this is enabled.

### Keep backing-up your docs

It is highly recommended that always do keeping backing-up your docs. For several reasons such as unexpected physical damage onto your harddrive or software corruptions under development and/or maintenance, you have to back-up your data into your other safe place.

### Supports multiple architectures

It builds from Github Actions for supporting multiple architectures such as AMD64(x86_64) and ARM64, ARMv7, ARMv6.

So that you can use this on most computers supporting Docker.

## How can I use this

Pull the image from Docker Hub.

```bash
docker pull awesometic/docusaurus
```

### Basic usage

You can just do dry-run this with the following command. The '--rm' option removes container when you terminate the interactive session.

```bash
docker run -it --rm \
-p 80:80 \
-v /config/dir:/docusaurus \
awesometic/docusaurus
```

This Docker image requires one mapped volume on host computer.

* `/docusaurus`: Where the Docusaurus source files located in

**In the first running**, it may takes several minutes to download/prepare the whole source code from the Internet. See the [When can I access my website](https://github.com/awesometic/docker-docusaurus#when-can-i-access-my-website) chapter below.

Then you have made a basic Docusaurus website having the following characteristics.

* Project sources are having UID 1000 and GID 1000 for non-root editing
* Enabled auto update
* Named "MyWebsite"
* Styled with "classic" template

If you want to run this image as a daemon with your parameters, try using the following command.

```bash
docker run -d --name=docusaurus \
-p 80:80 \
-v /config/dir:/docusaurus \
-e TARGET_UID=1000 \
-e TARGET_GID=1000 \
-e AUTO_UPDATE=true \
-e WEBSITE_NAME="awesometic-docs" \
-e TEMPLATE=classic \
awesometic/docusaurus
```

When the container runs, just let your browser browses:

``` http
http://localhost/
```

### When can I access my website

In the first running, so to speak, if it ran without configuration files that are created during the first run time before, the users cannot access the newly created Docusaurus website immediately. It will take more than 1 minutes because it downloads the latest Docusaurus source codes at the init process.

See the logs showing when the Docusaurus container runs.

```
Variables:
        - UID=1000
        - GID=1000
        - AUTO_UPDATE=true
        - WEBSITE_NAME=awesometic-docs
        - TEMPLATE=classic
        - RUN_MODE=development
/* Register a new cron job for auto updating... */
/* Successfully registered. */
/* Install docusaurus... */
npm WARN exec The following package was not found and will be installed: @docusaurus/init@latest

Creating new Docusaurus project ...
...
[4/4] Building fresh packages...
...
Success! Created awesometic-docs
...
/* Node modules already exist in /docusaurus/awesometic-docs/node_modules */
/* Start supervisord to start Docusaurus... */
2021-02-22 03:14:43,572 INFO Set uid to user 0 succeeded
2021-02-22 03:14:43,584 INFO supervisord started with pid 95
2021-02-22 03:14:44,589 INFO spawned: 'docusaurus' with pid 97
yarn run v1.22.5
$ docusaurus start --port 80 --host 0.0.0.0
2021-02-22 03:14:46,406 INFO success: docusaurus entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
Starting the development server...
Docusaurus website is running at: http://localhost:80/
ℹ Compiling Client
ℹ ｢wds｣: Project is running at http://0.0.0.0:80/
ℹ ｢wds｣: webpack output is served from /
ℹ ｢wds｣: Content not from webpack is served from /docusaurus/awesometic-docs
ℹ ｢wds｣: 404s will fallback to /index.html
✔ Client: Compiled successfully in 27.42s
ℹ Compiling Client
✔ Client: Compiled successfully in 507.94ms
```

As we can see the logs, at the first, the init process is downloading the full source codes from the Internet. Then it builds the source codes, and finally it starts with the specified port number. At this moment the logs are,

```
$ docusaurus start --port 80 --host 0.0.0.0
2021-02-22 03:14:46,406 INFO success: docusaurus entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
Starting the development server...
Docusaurus website is running at: http://localhost:80/
ℹ Compiling Client
ℹ ｢wds｣: Project is running at http://0.0.0.0:80/
ℹ ｢wds｣: webpack output is served from /
ℹ ｢wds｣: Content not from webpack is served from /docusaurus/awesometic-docs
ℹ ｢wds｣: 404s will fallback to /index.html
✔ Client: Compiled successfully in 27.42s
ℹ Compiling Client
✔ Client: Compiled successfully in 507.94ms
```

So, even if you cannot access it after running this Docker image, the container itself maybe not broken. Wait 1 or 2 minutes, then you can see the website front.

## Remains

* [ ] Production mode - Currently, this image always runs Docusaurus as development mode. The development mode allows live-updated as the admin edits whose site but it is not that solid because the visitors also can see the 'being editing' contents. This is acceptable for now but the production mode will be added on the requests.
* [ ] Support HTTPS - This image doesn't support SSL even if the generated cert files are preprared but you can apply SSL if you have external Let's Encrypt program and/or a reverse proxy server like "linuxserver/letsencrypt".

## License

This project comes with MIT license. Please see the [license file](LICENSE).
