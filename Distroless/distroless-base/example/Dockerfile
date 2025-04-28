FROM gcc:latest AS build-env
COPY . /app
WORKDIR /app
RUN cc hello.c -o hello

FROM openeuler/distroless-base:2.38-oe2403lts
COPY --from=build-env /app /app
WORKDIR /app
CMD ["./hello"]