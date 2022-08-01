ARG         base=alpine:3.16

###

FROM        ${base} as build

ARG         version=8.13.0
ARG         repo=libvips/libvips

RUN         apk add --no-cache --virtual .build-deps \
                build-base \
                meson \
                cmake \
                pkgconfig \
                glib-dev \
                expat-dev \
                gobject-introspection-dev \
                librsvg-dev \
                libexif-dev \
                libjpeg-turbo-dev \
                libheif-dev \
                libjxl-dev \
                libspng-dev \
                poppler-glib \
                fftw-dev \
                libimagequant-dev \
                lcms2-dev \
                libwebp-dev \
                cfitsio-dev \
                openjpeg-dev \
                openexr-dev && \
            wget -O - https://github.com/${repo}/archive/refs/tags/v${version}.tar.gz | tar xz

WORKDIR     libvips-${version}

RUN         meson setup build && \
            cd build && \
            meson compile && \
            meson test && \
            meson install

###

FROM        ${base}

ENTRYPOINT  ["vips"]

RUN         apk add --no-cache --virtual .run-deps \
                glib \
                expat \
                gobject-introspection \
                librsvg \
                libexif \
                libjpeg-turbo \
                libheif \
                libjxl \
                libspng \
                poppler-glib \
                fftw \
                libimagequant \
                lcms2 \
                libwebp \
                cfitsio \
                openjpeg \
                openexr

COPY        --from=build /usr/local/bin /usr/local/bin
COPY        --from=build /usr/local/include /usr/local/include
COPY        --from=build /usr/local/lib /usr/local/lib
