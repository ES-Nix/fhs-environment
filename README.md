

First working `fhs` + `hello`:

Using only `nix` + `flakes`:
```
nix build github:ES-Nix/fhs-environment/512cce8c11412140eec90fa33186d7673c75714b#fhs-environment
./result/fhs-env -c 'hello'
```


```
git clone https://github.com/ES-Nix/fhs-environment.git
cd fhs-environment
git checout 512cce8c11412140eec90fa33186d7673c75714b
nix build .#fhs-environment
./result/fhs-env -c 'hello'
```


It does not isolate environment variables, why?
```
nix build .#fhs-environment
./result/fhs-env -c 'env'
```

This is in two steps:

1)
`nix develop --ignore-environment`

2)
`hello`

Don't know how to make it in one step, none of these works:

`nix develop --ignore-environment --command hello`

`nix develop --ignore-environment --command bash -c 'hello'`

It may be needed when changing the hardcoded path to the `fhs-env`: 
`sudo nix-collect-garbage --delete-old`


```bash
nix \
shell \
--impure \
--expr \
'(
with builtins.getFlake "nixpkgs";  
with legacyPackages.${builtins.currentSystem}; 
  (
    buildFHSUserEnv { name = "fhs"; }
  )
)' \
--command \
fhs
```

```bash
nix \
shell \
--ignore-environment \
--impure \
--expr \
'(
with builtins.getFlake "nixpkgs";  
with legacyPackages.${builtins.currentSystem}; 
  (
    buildFHSUserEnv { 
      name = "fhs";
      targetPkgs = pkgs: with (builtins.getFlake "nixpkgs"); [
          bashInteractive
          hello
          cowsay          
        ];
      runScript = "bash";
    }
  )
)' \
--command \
fhs \
-c \
"hello | cowsay" 
```

```bash
nix \
shell \
--impure \
--expr \
'(
with builtins.getFlake "nixpkgs";  
with legacyPackages.${builtins.currentSystem}; 
  (
    buildFHSUserEnv { 
      name = "fhs";
      targetPkgs = pkgs: with (builtins.getFlake "nixpkgs"); [
          bashInteractive
          pkgsStatic.xorg.xclock
        ];
      runScript = "bash";
    }
  )
)' \
--command \
fhs \
-c \
"xclock"
```


```bash
nix \
shell \
--ignore-environment \
--impure \
--expr \
'(
with builtins.getFlake "nixpkgs";  
with legacyPackages.${builtins.currentSystem}; 
  (
    buildFHSUserEnv { 
      name = "fhs";
      targetPkgs = pkgs: with (builtins.getFlake "nixpkgs"); [
          bashInteractive
          pkgsStatic.xorg.xclock
        ];
      runScript = "bash";
    }
  )
)' \
--command \
fhs \
-c \
"xclock"
```

```bash
nix \
shell \
--impure \
--expr \
'(
with builtins.getFlake "nixpkgs";  
with legacyPackages.${builtins.currentSystem}; 
  (
    buildFHSUserEnv { 
      name = "fhs";
      targetPkgs = pkgs: with (builtins.getFlake "nixpkgs"); [
          hello
          cowsay
          figlet
        ];
      runScript = "bash";
    }
  )
)' \
--command \
fhs \
-c \
"hello | cowsay" 
```


```bash
nix \
shell \
--ignore-environment \
--store ~/my-nix \
nixpkgs#bashInteractive \
nixpkgs#hello \
nixpkgs#pkgsStatic.nix \
-c \
bash
```
