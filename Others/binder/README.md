# Quick reference

- The official keybinder docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# keybinder | openEuler
Current keybinder docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

keybinder is a library for registering global keyboard shortcuts. Keybinder works with GTK-based applications using the X Window System.

# Supported tags and respective Dockerfile links
The tag of each `binder` docker image is consist of the version of `binder` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                                  | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|---------------|
| [0.3.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/binder/0.3.2/24.03-lts-sp1/Dockerfile) | keybinder 0.3.2 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/binder` image from docker

	```bash
	docker pull openeuler/binder:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to run your own code using keybinder.
    ```
    docker run -it --rm openeuler/binder:{Tag} bash
    ```
  
- Install the X Virtual Framebuffer (Xvfb)

    ``` 
    dnf install xorg-x11-server-Xvfb
    ```
    This provides a virtual X11 server that can run graphical applications without a physical display.

- Start the Xvfb Server
    
    ```
    Xvfb :99 -screen 0 1024x768x24 &
    ```
    This launches Xvfb on display number `:99`.

- Set the DISPLAY Environment Variable

    ```
    export DISPLAY=:99
    ```
    This directs graphical applications to connect to the Xvfb virtual display.
    
- Example: A minimal binder program

    Create a file named `test.c` with the following content:
    ```
    #include <gtk/gtk.h>
    #include <keybinder.h>
    
    void my_callback(const char *keystring, void *user_data) {
        g_print("Hotkey '%s' activated!\n", keystring);
    }
    
    int main(int argc, char *argv[]) {
        gtk_init(&argc, &argv);
        keybinder_init();
        keybinder_bind("<Ctrl><Alt>t", my_callback, NULL);
        g_print("Listening for Ctrl+Alt+T...\n");
        gtk_main();
        return 0;
    }
    ```
    
- Compile the program

    Use the new version of `Keybinder` to compile the program:
    ```
    gcc test.c \
      -I/usr/include/gtk-3.0 \
      -I/usr/local/include/keybinder-3.0 \
      $(pkg-config --cflags --libs gtk+-3.0) \
      -L/usr/local/lib -lkeybinder-3.0 \
      -Wl,-rpath=/usr/local/lib \
      -o keybinder
    ```
    This command compiles `test.c` with GTK3 and Keybinder headers and libraries, producing the executable `keybinder`.
  
- Run the program

    ```
    ./keybinder
    ```
    The program will connect to the virtual X server (Xvfb) and listen for the keybindings defined in your code.
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).