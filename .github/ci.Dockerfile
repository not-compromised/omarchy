FROM archlinux:base
RUN pacman -Syu --noconfirm --needed bash git jq nodejs python lua plocate util-linux glib2 ffmpeg imagemagick libxkbcommon ripgrep diffutils sudo openssh desktop-file-utils inetutils \
    && useradd --create-home --uid 1000 tester
RUN git clone https://github.com/omacom/omarchy-pkgs.git /opt/omarchy-pkgs \
    && git -C /opt/omarchy-pkgs checkout 49c44db179b37fc188c698eb90d5e705947d2def \
    && git clone https://github.com/omacom/omarchy-iso.git /opt/omarchy-iso \
    && git -C /opt/omarchy-iso checkout 7cfb7111a06873d61c45d37034577d4ba08d3f4f
ENV PYTHONDONTWRITEBYTECODE=1
ENV OMARCHY_PATH=/work
ENV OMARCHY_PKGS_PATH=/opt/omarchy-pkgs
ENV OMARCHY_ISO_PATH=/opt/omarchy-iso
ENV PATH=/work/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
COPY --chown=tester:tester . /work
USER tester
WORKDIR /work
ENV HOME=/home/tester
CMD ["bash", "test/all"]
