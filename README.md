

Using only `nix` + `flakes` have an working `fhs` + `hello`:
```
nix build github:ES-Nix/fhs-environment/c0d8bcd2e0e1e26c30a6b0ed20dc77108c47bcd1#fhs-environment
./result/bin/fhs-env -c 'hello && tests_locale_with_python'
```


```
git clone https://github.com/ES-Nix/fhs-environment.git
cd fhs-environment
git checout c0d8bcd2e0e1e26c30a6b0ed20dc77108c47bcd1
nix build .#fhs-environment
./result/bin/fhs-env -c 'hello'
./result/bin/fhs-env -c 'tests_locale_with_python'
```


It isolates environment variables, how/why?
Search in this link [`the exec -c option`](https://www.putorius.net/exec-command.html) for the text
`the exec -c option`. So, the use of `exec -c ${self.packages.${system}.fhs-environment}/bin/fhs-env`
explain this.

```
git clone https://github.com/ES-Nix/fhs-environment.git
cd fhs-environment
git checout c0d8bcd2e0e1e26c30a6b0ed20dc77108c47bcd1
nix build .#fhs-environment
./result/bin/fhs-env -c 'env'
```

This is in two steps:

1)
```
git clone https://github.com/ES-Nix/fhs-environment.git
cd fhs-environment
git checout c0d8bcd2e0e1e26c30a6b0ed20dc77108c47bcd1
nix develop`
```

2)
```
hello
tests_locale_with_python
```

Don't know how to make it in one step, none of these works:

`nix develop --ignore-environment --command hello`

`nix develop --ignore-environment --command bash -c 'hello'`



./result/bin/fhs-env -c 'readlink $(which python3)'

python3 -c 'import locale; locale.setlocale(locale.LC_ALL, "pt_BR.UTF-8")'

file $(echo $(readlink --canonicalize $(echo $LOCALE_ARCHIVE)))
