# Scripts to generate coding style reports
## Changes made by this fork

Instead of using `coding-style.sh` you would use `my_cs.sh`.\
`my_cs.sh` adds a bunch of functionality:

- automaticly prints the errors (if any) after running the checker
- does not print errors from files that are ignored by atleast one `.gitignore`


## Usage

you can add the following line to your `~/.bashrc` to make your life easier
```shell
alias cs="path/to/cs_checker/my_cs.sh . ."
#example of real path:
#alias cs="$HOME/tek/cs_checker/my_cs.sh . ."
```

this allows you to run `cs` anywhere you want and it will run the checker then print the errors.

> [!CAUTION]
> due to how i made this script, it fetches any .gitignore that is in your workdir or below.
> and i'm a tiny bit lazy, so when you ignore a file from a sub .gitignore, it will behave as if you ignored it in the main .gitignore
> checkout the **[bug section](#bugs)** for more info.

## Requirements & official doc from forked repo
### Linux

Requirement :

- [Docker](https://docs.docker.com/engine/install/) installed
- [Curl](https://curl.se/download.html) installed

Use `coding-style.sh`

If using Nix, you can run `nix run github:epitech/coding-style-checker` to run a script printing you the list of infractions.

### Windows

Requirements :

- [Docker](https://docs.docker.com/engine/install/) installed
- [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) installed

Use `coding-style.ps1`

### MacOS

Requirements :

- [Nix](https://github.com/DeterminateSystems/nix-installer) installed

Use `nix run github:epitech/coding-style-checker` to run a script printing you the list of infractions.
(Supports both Intel and Apple Silicon)


## Bugs

let's say i have a project that looks something like this:

```
.
├── coding-style-reports.log
├── .gitignore
├── include
│   └── [...]
├── lib
│   ├── .gitignore
│   └── my
│       └── [...]
├── Makefile
├── panoramix
└── src
    └── [...]
```

and `./.gitignore` is empty but `./lib/.gitignore` contains `panoramix` \
when you do a gitpush, the file `./panoramix` will **NOT** be ignored by git and pushed on the repo. \
but for my cs, the MAJOR CO-1 that would arise from the binary file panoramix existing,
would be ignored because to the eye of of my script, there is only one .gitignore and it is at the root.
