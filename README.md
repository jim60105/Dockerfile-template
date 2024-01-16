# Dockerfile template

> [!WARNING]
> Please be aware that this repository is fully licensed under the GPLv3.

This Dockerfile repository serves as a template for me to quickly start new Dockerfile projects, and conveniently copy and paste. These files are extracted from my previous projects, they cannot be used directly. They preserve the unique configurations of the original projects, along with my personal preferences and coding style. Kindly exercise caution when using them.

[!markdown/README.md](!markdown/README.md): Search for `jim60105/Dockerfile-template` and `source/Dockerfile-template` and replace them with the name of the new repository.

## Awesome Resources

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

## My works

| Repository                                                                             | Description                                                                                                                                                                                                                                                                  | Dockerfile                                                                                 | UBI                                                                                      |
| -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------- |
| [docker-whisperX](https://github.com/jim60105/docker-whisperX)                         | A Dockerfile and CI workflow focus on multi-stage building and optimal cache adjustment. It efficiently builds close to 200 Docker images, each with a size of 10G, on a weekly basis using the GitHub free runner.                                                          | [🔗](https://github.com/jim60105/docker-whisperX/blob/master/Dockerfile)                   | [🔗](https://github.com/jim60105/docker-whisperX/blob/master/ubi.Dockerfile)             |
| [docker-MSSQL-Server](https://github.com/jim60105/docker-MSSQL-Server)                 | A MSSQL Server Containerized Backup and Restoration Solution. My team relies on this solution to keep the development databases in sync between dozens of developers. Everyone has their own development database, so we can freely experiment with it without any concerns. | [🔗](https://github.com/jim60105/docker-MSSQL-Server/blob/master/volume-backup/Dockerfile) |                                                                                          |
| [docker-streamLink](https://github.com/jim60105/docker-streamlink)                     | Python pip package containerization.                                                                                                                                                                                                                                         | [🔗](https://github.com/jim60105/docker-streamlink/blob/master/alpine.Dockerfile)          | [🔗](https://github.com/jim60105/docker-streamlink/blob/master/ubi.Dockerfile)           |
| [docker-yt-dlp](https://github.com/jim60105/docker-yt-dlp)                             | Python pip package containerization.                                                                                                                                                                                                                                         | [🔗](https://github.com/jim60105/docker-yt-dlp/blob/master/alpine.Dockerfile)              | [🔗](https://github.com/jim60105/docker-yt-dlp/blob/master/ubi.Dockerfile)               |
| [docker-ytarchive](https://github.com/jim60105/docker-ytarchive)                       | Golang binary containerization.                                                                                                                                                                                                                                              | [🔗](https://github.com/jim60105/docker-ytarchive/blob/master/Dockerfile)                  | [🔗](https://github.com/jim60105/docker-ytarchive/blob/master/ubi.Dockerfile)            |
| [docker-twitcasting-recorder](https://github.com/jim60105/docker-twitcasting-recorder) | Python project containerization.                                                                                                                                                                                                                                             | [🔗](https://github.com/jim60105/docker-twitcasting-recorder/blob/master/Dockerfile)       | [🔗](https://github.com/jim60105/docker-twitcasting-recorder/blob/master/ubi.Dockerfile) |
| [docker-fc2-live-dl](https://github.com/jim60105/docker-fc2-live-dl)                   | Python project containerization.                                                                                                                                                                                                                                             | [🔗](https://github.com/jim60105/docker-fc2-live-dl/blob/master/alpine.Dockerfile)         | [🔗](https://github.com/jim60105/docker-fc2-live-dl/blob/master/ubi.Dockerfile)          |
| [YoutubeLiveChatToDiscord](https://github.com/jim60105/YoutubeLiveChatToDiscord)       | .NET 8 C# project with runtime-deps image + self-contained + publish-trimmed.                                                                                                                                                                                                | [🔗](https://github.com/jim60105/YoutubeLiveChatToDiscord/blob/master/Dockerfile)          |                                                                                          |
| [backup-dl](https://github.com/jim60105/backup-dl)                                     | .NET 8 C# project with runtime-deps image + self-contained + publish-trimmed.                                                                                                                                                                                                | [🔗](https://github.com/jim60105/backup-dl/blob/master/Dockerfile)                         |                                                                                          |
| [docker-Nextcloud](https://github.com/jim60105/docker-Nextcloud)                       | Docker compose file for Nextcloud.                                                                                                                                                                                                                                           |                                                                                            |                                                                                          |
| [docker-ReverseProxy](https://github.com/jim60105/docker-ReverseProxy)                 | Docker compose file for Reverse Proxy with automatic SSL certificate generation. I use it for my personal VPS reverse proxy.                                                                                                                                                 |                                                                                            |                                                                                          |
| [Recorder-moe/azure-uploader](https://github.com/Recorder-moe/azure-uploader)          | Call Azure REST api with shell script in container.                                                                                                                                                                                                                          | [🔗](https://github.com/Recorder-moe/azure-uploader/blob/master/Dockerfile)                |                                                                                          |
| [Recorder-moe/s3-uploader](https://github.com/Recorder-moe/s3-uploader)                | Use MinIO Client (mc) to upload files to S3 compatible storage.                                                                                                                                                                                                              | [🔗](https://github.com/Recorder-moe/s3-uploader/blob/master/Dockerfile)                   |                                                                                          |

## LICENSE

> [!CAUTION]
> A GPLv3 licensed Dockerfile means that you _**MUST**_ **distribute the source code with the same license**, if you
>
> - Re-distribute the image. (You can simply point to this GitHub repository if you doesn't made any code changes.)
> - Distribute a image that uses code from this repository.
> - Or **distribute a image based on this image**. (`FROM ghcr.io/jim60105/Dockerfile-template` in your Dockerfile)
>
> "Distribute" means to make the image available for other people to download, usually by pushing it to a public registry. If you are solely using it for your personal purposes, this has no impact on you.
>
> Please consult the [LICENSE](LICENSE) for more details.

<img src="https://github.com/jim60105/Dockerfile-template/assets/16995691/ea799bbb-d531-4514-baee-13874322ec48" alt="gplv3" width="300" />

[GNU GENERAL PUBLIC LICENSE Version 3](LICENSE)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).
