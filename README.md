

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


