# Apple PKL flake

Nix packages for Apple PKL, since they arent yet pakaged on Nixpkgs.

To include them on your flake, import this repo onto it

```nix
{
  inputs = {
    # Assuming you already have a nixpkgs version imported
    apple-pkl-flake = {
      url = "github:tulilirockz/apple-pkl-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    # Anything here, then `inputs.apple-pkl-flake.packages.${pkgs.system}.pkl or jpkl.`
  };
}
```
