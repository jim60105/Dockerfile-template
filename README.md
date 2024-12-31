# Containerfile template

> [!WARNING]
> Please be aware that this repository is fully licensed under the GPLv3.

This repository collects all of my containerization works and serves as a template for quickly starting new projects. These files are extracted from my previous projects, they cannot be used directly. They preserve the unique configurations of the original projects, along with my personal preferences and coding style. Kindly exercise caution when using them.

## My works

| Repository | Description | Containerfile |
|--|--|--|
| [docker-whisperX](https://github.com/jim60105/docker-whisperX) | A Dockerfile and CI workflow focus on multi-stage building and optimal cache adjustment. It efficiently builds close to ***200*** Docker images, each with a size of ***10G,*** on a weekly basis using the GitHub free runner. | [🔗](https://github.com/jim60105/docker-whisperX/blob/master/Dockerfile) |
| [docker-stable-diffusion-webui](https://github.com/jim60105/docker-stable-diffusion-webui) | Python ML project containerization and Docker build CI workflow fully on the GitHub free runner. The main goal of designing this image is to keep it ***small and follow best practices.*** Successfully controlled the size to around ***10GB,*** saving approximately ***1/3*** of the capacity compared to other existing solutions. | [🔗](https://github.com/jim60105/docker-stable-diffusion-webui/blob/master/Dockerfile)|
| [docker-MSSQL-Server](https://github.com/jim60105/docker-MSSQL-Server) | A MSSQL Server Containerized Backup and Restoration Solution. My team relies on this solution to keep the development databases in sync between dozens of developers. Everyone has their own development database, so we can freely experiment with it without any concerns. | [🔗](https://github.com/jim60105/docker-MSSQL-Server/blob/master/volume-backup/Dockerfile) |
| [docker-Oracle-Database](https://github.com/jim60105/docker-Oracle-Database) | Same as the previous one, but it's for Oracle Database. | |
| [docker-static-ffmpeg-upx](https://github.com/jim60105/docker-static-ffmpeg-upx) | This is the wader/static-ffmpeg compressed with UPX, makes the binary size reduce to about ***26%.*** I created this image mainly for my other projects that uses **static-ffmpeg.** Also added the compressed **dumb-init** since I often use it together. | [🔗](https://github.com/jim60105/docker-static-ffmpeg-upx/blob/master/Dockerfile) |
| [docker-infinite-image-browsing](https://github.com/jim60105/docker-infinite-image-browsing) | Python pip package containerization with ***Nuitka*** compiled to executable and run in a container without the python runtime. | [🔗](https://github.com/jim60105/docker-infinite-image-browsing/blob/master/nuitka.Dockerfile) |
| [docker-streamLink](https://github.com/jim60105/docker-streamlink)| Python pip package containerization. | [🔗](https://github.com/jim60105/docker-streamlink/blob/master/alpine.Dockerfile) |
| [docker-yt-dlp](https://github.com/jim60105/docker-yt-dlp) | Python pip package containerization. | [🔗](https://github.com/jim60105/docker-yt-dlp/blob/master/alpine.Dockerfile)|
| [docker-ytarchive](https://github.com/jim60105/docker-ytarchive) | Golang containerization with UPX compressed. | [🔗](https://github.com/jim60105/docker-ytarchive/blob/master/Dockerfile) |
| [docker-twitcasting-recorder](https://github.com/jim60105/docker-twitcasting-recorder) | Python project containerization.| [🔗](https://github.com/jim60105/docker-twitcasting-recorder/blob/master/Dockerfile) |
| [docker-fc2-live-dl](https://github.com/jim60105/docker-fc2-live-dl) | Python project containerization.| [🔗](https://github.com/jim60105/docker-fc2-live-dl/blob/master/alpine.Dockerfile) |
| [docker-MoE-LLaVA](https://github.com/jim60105/docker-MoE-LLaVA) | Python project containerization with ML dependencies (CUDA, torch). | [🔗](https://github.com/jim60105/docker-MoE-LLaVA/blob/master/Dockerfile) |
| [docker-SillyTavern](https://github.com/jim60105/docker-SillyTavern) | Node.js project containerization + Helm chart. | [🔗](https://github.com/jim60105/docker-SillyTavern/blob/master/Dockerfile) |
| [YoutubeLiveChatToDiscord](https://github.com/jim60105/YoutubeLiveChatToDiscord) | C# .NET 8 project with runtime-deps image + self-contained + publish-trimmed.| [🔗](https://github.com/jim60105/YoutubeLiveChatToDiscord/blob/master/Dockerfile) |
| [backup-dl](https://github.com/jim60105/backup-dl) | C# .NET 8 project with runtime-deps image + self-contained + publish-trimmed.| [🔗](https://github.com/jim60105/backup-dl/blob/master/Dockerfile) |
| [toolbx](https://github.com/jim60105/toolbx) | [Toolbx](https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/) is a tool for Linux, which allows the use of interactive command line environments for software development and troubleshooting the host operating system, without having to install software on the host. These are my personal Fedora toolbox images, which I use for development and daily usage. | [🔗](https://github.com/jim60105/toolbx/blob/master/base.Containerfile) |
| [docker-OpenTelemetry](https://github.com/jim60105/docker-OpenTelemetry) | Docker compose for deploying OpenTelemetry Monitoring Solution with Docker | |
| [docker-Nextcloud](https://github.com/jim60105/docker-Nextcloud) | Docker compose file for Nextcloud. | |
| [docker-minecraft](https://github.com/jim60105/docker-minecraft) | Docker compose file for my Minecraft server. Contains a simple solution to deal with the problem of Podman not having GELF log driver. | |
| [docker-ReverseProxy](https://github.com/jim60105/docker-ReverseProxy) | Docker compose file for Reverse Proxy with automatic SSL certificate generation. I use it for my personal VPS reverse proxy. | |
| [Recorder-moe/azure-uploader](https://github.com/Recorder-moe/azure-uploader) | Call Azure REST api with shell script in container. | [🔗](https://github.com/Recorder-moe/azure-uploader/blob/master/Dockerfile) |
| [Recorder-moe/s3-uploader](https://github.com/Recorder-moe/s3-uploader) | Use MinIO Client (mc) to upload files to S3 compatible storage. | [🔗](https://github.com/Recorder-moe/s3-uploader/blob/master/Dockerfile) |
| [Recorder-moe/LivestreamRecorderFrontend](https://github.com/Recorder-moe/LivestreamRecorderFrontend) | Angular npm build and Nginx unprivileged image. (Closed source) | |
| [Recorder-moe/LivestreamRecorderBackend](https://github.com/Recorder-moe/LivestreamRecorderBackend) | Azure Functions containerization with python, yt-dlp, ffmpeg installed. | [🔗](https://github.com/Recorder-moe/LivestreamRecorderBackend/blob/master/Dockerfile)|
| [HoloArchivists/twspace-dl](https://github.com/HoloArchivists/twspace-dl) | Python project containerization with venv solution. | [🔗](https://github.com/HoloArchivists/twspace-dl/blob/main/Dockerfile) |
| [bmaltais/kohya_ss](https://github.com/bmaltais/kohya_ss)| Python project containerization with ML dependencies (CUDA, torch, xformers). I helped this amazing open-source project set up the docker build CI. | [🔗](https://github.com/bmaltais/kohya_ss/blob/master/Dockerfile) |

## Other Awesome Resources

### Best practices

- [Docker Docs: Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/instructions/)
- [Openshift Docs: Creating images](https://docs.openshift.com/container-platform/4.14/openshift_images/create-images.html)
- [IBM Docs: Best practices for designing a universal application image](https://developer.ibm.com/learningpaths/universal-application-image/design-universal-image)

### Nginx

- [NGINX Unprivileged Docker Image (Run as a non root, unprivileged user)](https://github.com/nginxinc/docker-nginx-unprivileged)

### Python

- [Creating the Perfect Python Dockerfile | by Luis Sena | Medium](https://luis-sena.medium.com/creating-the-perfect-python-dockerfile-51bdec41f1c8)
- [Multi-stage builds #2: Python specifics](https://pythonspeed.com/articles/multi-stage-docker-python/)
- [To Virtualenv or not to Virtualenv for Docker? This is the question. | by Jarek Potiuk | Medium](https://potiuk.com/to-virtualenv-or-not-to-virtualenv-for-docker-this-is-the-question-6f980d753b46)  
  This article explains why you should **NOT** use virtualenv in Docker.
- [Optimising Python3 with Nuitka and Docker Scratch](https://medium.com/dazn-tech/nuitka-python3-and-scratch-4ce209ed6dd6)  
  Compile Python program to binary with Nuitka and run it in a scratch container.  
  This means no "entire" Python runtime and dependencies is needed in the final image.  
  This article demonstrates based on the most basic premise and may require some adjustments in practical applications.  
  Starting from the `debian:slim` will make life easier. 😉

### Podman

- [Containerfile Reference](https://github.com/containers/common/blob/main/docs/Containerfile.5.md)
- [podman-build — Podman documentation](https://docs.podman.io/en/stable/markdown/podman-build.1.html)
- [How to debug issues with volumes mounted on rootless containers | Enable Sysadmin | Redhat](https://www.redhat.com/sysadmin/debug-rootless-podman-mounted-volumes)
- [Container permission denied: How to diagnose this error | Enable Sysadmin | Redhat](https://www.redhat.com/sysadmin/container-permission-denied-errors)

### Advanced Docker

- [Advanced Docker / BuildKit Caching with 5 tricks to speed up your image builds](https://www.augmentedmind.de/2023/11/19/advanced-buildkit-caching/)

## LICENSE

<img src="https://github.com/jim60105/Dockerfile-template/assets/16995691/ea799bbb-d531-4514-baee-13874322ec48" alt="gplv3" width="300" />

[GNU GENERAL PUBLIC LICENSE Version 3](LICENSE)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).

> [!CAUTION]
> A GPLv3 licensed Containerfile means that you ***MUST*** **distribute the source code with the same license**, if you
>
> - Re-distribute the image. (You can simply point to this GitHub repository if you doesn't made any code changes.)
> - Distribute a image that uses code from this repository.
> - Or **distribute a image based on this image**. (`FROM ghcr.io/jim60105/Containerfile-template` in your Containerfile)
>
> "Distribute" means to make the image available for other people to download, usually by pushing it to a public registry. If you are solely using it for your personal purposes, this has no impact on you.
>
> Please consult the [LICENSE](LICENSE) for more details.
