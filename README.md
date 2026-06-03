# dotfiles

## When you can sudo

### Install

1. Clone this repo

 ```
 $ git clone --recurse-submodules --shallow-submodules git@github.com:jeeema/dotfiles.git ~/dotfiles
 ````

2. Update the submodules

 ```shell
 $ cd ~/dotfiles
 $ git submodule update --remote --recursive (--merge)
 ```

- Omitting `--merge` will discard any local modifications to the submodules and sync the submodules with the latest states of their official repositories. This will help make your own environment clean.
- Adding `--merge` may create a merge commit if you have, either intentionally or unintentionally, edited a certain file or checked-out a local branch in the submodules. In the first place, it would be much simpler and cleaner to manage a repository on its own, instead of as a submodule of `dotfiles`, if you really want to add some tweaks to it. Still, do *not* omit this option when you want to keep your modifications to the submodules.
- Merely running `git clone` without `--remote --recursive` options will leave `dotfiles/submodules` empty, but no worries! Just run `$ git submodule update --init --recursive`.

3. Install

 ```shell
 $ chmod u+x ./deploy
 $ ./deploy
 ```

```shell
$ ./deploy --help
Usage: deploy [OPTIONS...] [TARGETS...]

Options:
  -d, --debug    Enable debug mode
  -v, --verbose  Enable verbose output
  -f, --force    Force installation (override existing installations)
  -h, --help     Show this help message

Targets:
  --apt          Install & update APT packages
  --blesh        Install & update ble.sh
  --rust         Install & update Rust toolchains and crates
  --go           Install & update Go and tools
  --haskell      Install & update Haskell toolchains and packages
  --nodejs       Install & update Node.js and npm packages

By default, all targets are executed. If one or more target flags are
specified, only those explicitly selected targets will be run.
```

### Update

1. Update the submodules

 ```shell
 $ cd ~/dotfiles
 $ git submodule update --remote --recursive (--merge)
 ```
2. Update

 ```shell
 $ ./deploy
 ```

## When you cannot sudo

### Install

1. Clone this repo

 ```
 $ git clone --recurse-submodules --shallow-submodules git@github.com:jeeema/dotfiles.git ~/dotfiles
 ````

2. Update the submodules

 ```shell
 $ cd ~/dotfiles
 $ git submodule update --remote --recursive (--merge)
 ```
3. Install

 ```shell
 $ chmod u+x ./deploy_nosudo
 $ ./deploy_nosudo
 ```

### Update

1. Update the submodules

 ```shell
 $ cd ~/dotfiles
 $ git submodule update --remote --recursive (--merge)
 ```
2. Update

 ```shell
 $ ./deploy_nosudo
 ```

```shell
$ ./deploy_nosudo --help
Usage: deploy_nosudo [OPTIONS...] [TARGETS...]

Options:
  -d, --debug    Enable debug mode
  -v, --verbose  Enable verbose output
  -f, --force    Force installation (override existing installations)
  -h, --help     Show this help message
```
