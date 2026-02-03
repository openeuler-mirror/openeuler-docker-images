 # Quick reference

- The official [opencode](https://opencode.ai/) docker image.

- Maintained by: [openEuler infrastructure SIG](https://gitcode.com/openeuler/infrastructure).

- Where to get help: [openEuler infrastructure SIG](https://gitcode.com/openeuler/infrastructure)
# What is opencode

See: https://opencode.ai/

# Quick start
One line command to start a opencode container:

```bash
docker run \
    --name opencode \
    -v ~/.config/opencode:~/.config/opencode \ 
    -itd openeuler/opencode:1.1.48
```